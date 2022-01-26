const express = require('express');
const app = express();

const bcrypt = require('bcrypt');
const app_config = require('./app_config.json');
const jwt = require('jsonwebtoken');
const { User, validateUser } = require('./model/user');
//const { Country, validateCountry ,validateCountryData} = require('./model/country');
const _ = require('lodash');

const { UserAuthentication} = require("./middleware/authentication");
const Joi = require('joi');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));
app.listen(3000, () => console.log('Listening on port 3000...'));


app.get('/' , async (req,res)=>{
    return res.send(
        'Server is running'
    )
})


app.post('/signup', async (req, res) => {

    const { error } = validateUser(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    let user = await User.findOne({ name: req.body.name });
    if (user) return res.status(400).send('User already exists. ');

    user = new User({ name: req.body.name, password: req.body.password });
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(user.password, salt);

    await user.save();

    return res.header('x-auth-token', jwt.sign({ _id: user._id, role: 'user' }, app_config.jwtKey))
        .send({
            _id: user._id,
            name: user.name
        });
});

app.post('/signin', async (req, res) => {

    const { error } = validateUser(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    let user = await User.findOne({ name: req.body.name });
    if (!user) return res.status(400).send('Username or password is incorrect!');

    var checkPass =await bcrypt.compare( req.body.password,user.password);
    if(!checkPass) return res.status(400).send('password is incorrect!');
    
    return res.header('x-auth-token', jwt.sign({ _id: user._id, role: 'user' }, app_config.jwtKey))
        .send({
            _id: user._id,
            name: user.name
        });
});
