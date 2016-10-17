// ./models/order.js

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var OrderSchema = new Schema({
    createAt : String,
    userRequestAt : String,
    endAt : String,
    parkingPlace : String,
    userIdentifier : String,
    userFirstName : String,
    userLastName : String,
    userPhone : String,
    carIdentifier : String,
    carPlate : String,
    carBrand : String,
    carColor : String,
});

module.exports = mongoose.model('Order', OrderSchema);
