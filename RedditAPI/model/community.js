const mongoose = require("../database");
const Joi = require("joi");

const communitySchema = new mongoose.Schema({
  name:{
    type:String,
    unique:true,
  },
  admins: [{type: String}],
  users: [{type:String}],
});

const Community = mongoose.model("Community", communitySchema);


exports.Community = Community;
