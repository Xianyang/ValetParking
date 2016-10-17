// ./models/user.js

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var ValetSchema = new Schema({
    phone: String,
    firstName: String,
    lastName: String,
    passwordHash: String,
    passwordSalt: String
});

module.exports = mongoose.model('Valet', ValetSchema);
