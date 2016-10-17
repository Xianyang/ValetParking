// ./models/user-session.js

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var ValetSessionSchema = new Schema({
    sessionId: String,
    userId: String
});

module.exports = mongoose.model('ValetSession', ValetSessionSchema);
