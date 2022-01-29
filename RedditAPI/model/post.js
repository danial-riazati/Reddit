const mongoose = require("../database");
const Joi = require("joi");

const PostSchema = new mongoose.Schema({
  community_name: {
    type: String,
    required: true,
  },
  publisher_name: {
    type: String,
    required: true,
  },
  community_id: {
    type: String,
    required: true,
  },
  publisher_id: {
    type: String,
    required: true,
  },
  created_date: {
    type: Date,
    default: Date.now,
  },
  text:{
    type: String,
    required: true,
  },
  likes: [{ type: String }],
  dislikes: [{ type: String }],
  comments: [{ type: String }],
});

const Post = mongoose.model("Post", PostSchema);

exports.Post = Post;
