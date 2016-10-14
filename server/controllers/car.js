var CarController = function (userModel) {
    this.ApiResponse = require('../models/api-response.js');
    this.ApiMessages = require('../models/api-messages.js');
    this.UserProfile = require('../models/user-profile.js');
    this.User = require('../models/user.js'),
    this.Car = require('../models/car.js');
};

module.exports = CarController;
