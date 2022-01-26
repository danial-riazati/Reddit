const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/redditdb')
    .then(() => console.log("db connected successfully. "))
    .catch(e => console.log('db could not connect! error : ', e));

module.exports = mongoose;