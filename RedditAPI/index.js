const express = require("express");
const app = express();
var bodyParser = require('body-parser')
const bcrypt = require("bcrypt");
const app_config = require("./app_config.json");
const jwt = require("jsonwebtoken");
const { User, validateUser } = require("./model/user");
const _ = require("lodash");

const { UserAuthentication } = require("./middleware/authentication");
const Joi = require("joi");
const { x } = require("joi");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(function (req, res, next) {

    // Website you wish to allow to connect
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:1234');

    // Request methods you wish to allow
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

    // Request headers you wish to allow
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

    // Set to true if you need the website to include cookies in the requests sent
    // to the API (e.g. in case you use sessions)
    res.setHeader('Access-Control-Allow-Credentials', true);

    // Pass to next layer of middleware
    next();
});
app.listen(3000, () => console.log("Listening on port 3000..."));

app.get("/", async (req, res) => {
  console.log("xdssds");
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
  console.log("hello");
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
