const mongoose = require('../database');
const Joi = require('joi');
const passwordComplexity = require("joi-password-complexity");




const userSchema = new mongoose.Schema({
    name:{
        type: String,
        required: true,
        minlength: 5,
        maxlength: 30
    },
    password:{
        type: String,
        required: true,
        minlength: 5,
        maxlength: 1024 
    }
});

const User = mongoose.model('User', userSchema);

const complexityOptions = {
    min: 6,
    max: 15,
    lowerCase: 1,
    upperCase: 1,
    numeric: 1,

  };
  

function validateUser(user){
    return Joi.object({
        name: Joi.string().min(5).max(30).required(),
        password: passwordComplexity(complexityOptions).required()
    }).validate(user);
}

exports.User = User;
exports.validateUser = validateUser;