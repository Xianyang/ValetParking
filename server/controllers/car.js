var CarController = function () {
    this.ApiResponse = require('../models/api-response.js'),
    this.ApiMessages = require('../models/api-messages.js'),
    this.CarProfile = require('../models/car-profile.js'),
    this.User = require('../models/user.js'),
    this.Car = require('../models/car.js');
};

// register method
CarController.prototype.add = function (newCar, callback) {
    var me = this;

    // check if the user exist
    me.User.findOne({ phone: newCar.userPhone }, function (err, user) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }
        if (user) {
            console.log('found the user, name is ' + user.firstName + user.lastName);
            newCar.save(function (err, car, numberAffected) {
                if (err) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                }

                if (numberAffected === 1) {
                    var carProfile = new me.CarProfile({
                        identifier: car.id,
                        userPhone: car.userPhone,
                        brand: car.brand,
                        plate: car.plate,
                        color: car.carColor
                    });
                    console.log('add a car successfully with plate ' + car.plate);
                    return callback(err, new me.ApiResponse({
                        success: true, extras: {
                            carProfileModel: carProfile
                        }
                    }));
                } else {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_CREATE_CAR } }));
                }
            });
        } else {
            console.log('can not find this user');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }
    });
};

module.exports = CarController;
