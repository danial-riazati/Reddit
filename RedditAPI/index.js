const express = require("express");
const app = express();
var bodyParser = require("body-parser");
const bcrypt = require("bcrypt");
const app_config = require("./app_config.json");
const jwt = require("jsonwebtoken");
const { User, validateUser } = require("./model/user");
const { Community } = require("./model/community");
const { Post } = require("./model/post");
const _ = require("lodash");

const { UserAuthentication } = require("./middleware/authentication");
const Joi = require("joi");
const { x } = require("joi");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(function (req, res, next) {
  // Website you wish to allow to connect
  res.setHeader("Access-Control-Allow-Origin", "http://localhost:1234");

  // Request methods you wish to allow
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, OPTIONS, PUT, PATCH, DELETE"
  );

  // Request headers you wish to allow
  res.setHeader(
    "Access-Control-Allow-Headers",
    "X-Requested-With,content-type,x-auth-token"
  );

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions)
  res.setHeader("Access-Control-Allow-Credentials", true);

  // Pass to next layer of middleware
  next();
});
app.listen(3000, () => console.log("Listening on port 3000..."));

app.get("/", async (req, res) => {
  return res.send("Server is running");
});

app.post("/signup", async (req, res) => {
  const { error } = validateUser(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  let user = await User.findOne({ name: req.body.name });
  if (user) return res.status(400).send("User already exists. ");

  user = new User({ name: req.body.name, password: req.body.password });
  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);

  await user.save();

  return res.send({
    id: user._id,
    name: user.name,
    token: jwt.sign({ _id: user._id, role: "user" }, app_config.jwtKey),
  });
});

app.post("/signin", async (req, res) => {
  const { error } = validateUser(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  let user = await User.findOne({ name: req.body.name });
  if (!user) return res.status(400).send("Username or password is incorrect!");

  var checkPass = await bcrypt.compare(req.body.password, user.password);
  if (!checkPass) return res.status(400).send("password is incorrect!");

  return res.send({
    id: user._id,
    name: user.name,
    token: jwt.sign({ _id: user._id, role: "user" }, app_config.jwtKey),
  });
});

app.post("/community", UserAuthentication, async (req, res) => {
  let community = await Community.findOne({ name: req.body.name });
  if (community) return res.status(400).send("community name is used before! ");
  var user = jwt.verify(req.header("x-auth-token"), app_config.jwtKey);
  community = Community();
  community.name = req.body.name;
  community.admins = [user._id];
  community.users = [user._id];
  await community.save();

  return res.send({
    id: community._id,
  });
});

app.get("/posts", UserAuthentication, async (req, res) => {
  var user = jwt.verify(req.header("x-auth-token"), app_config.jwtKey);
  
  let communities = await Community.find(
    { users: { $in: [user._id] } },
    { _id: 0, name: 1 }
  );
  
  var x = [];
  communities.forEach(function (t) {
    x.push(t.name);
  });
  let posts = await Post.find(
    { community_name: { $in: x } },
    { _id: 0, __v: 0 }
  );

  return res.send(posts);
});
app.get("/communities", UserAuthentication, async (req, res) => {
  var user = jwt.verify(req.header("x-auth-token"), app_config.jwtKey);
  
  let communities = await Community.find(
    { users: { $in: [user._id] } }
  );
  
  return res.send(communities);
});

app.post("/posts", UserAuthentication, async (req, res) => {
  var user = jwt.verify(req.header("x-auth-token"), app_config.jwtKey);
  var x = await User.findOne({_id:user._id});
  var community = await Community.findOne({name:req.body.community_name});
  if(!community) return res.status(400).send('can\'t find community with this name! ')
 
  if(!community.admins.includes(user._id)) return res.status(400).send('you don\'t have access! ')
  p = new Post({
    community_name: req.body.community_name,
    community_id: community._id,
    publisher_name: x.name,
    publisher_id: x._id,
    text: req.body.text,
    created_date : req.body.created_date
  });
  await p.save()
  return res.send(p);
});
