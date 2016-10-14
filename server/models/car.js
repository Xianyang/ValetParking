// ./models/car.js

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var CarSchema = new Schema({
    identifier: String,
    userIdenfier: String,
    brand: String,
    plate: String,
    color: String,
});

module.exports = mongoose.model('Car', CarSchema);
