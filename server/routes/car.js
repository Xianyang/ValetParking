var express = require('express'),
    router = express.Router(),
    AccountController = require('../controllers/account.js'),
    CarController = require('../controllers/car.js'),
    User = require('../models/user.js'),
    UserProfile = require('../models/user-profile.js'),
    CarProfile = require('../models/car-profile.js'),
    Car = require('../models/car.js'),
    ApiResponse = require('../models/api-response.js');

var accountController = new AccountController(User);
var CarController = new CarController()

router.route('/car/add').post(function (req, res) {
    console.log('get a add car post');
    var car = new Car(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    CarController.add(car, function (err, response) {
        return res.send(response);
    });
});

router.route('/car/get_cars_for_user').post(function (req, res) {
    console.log('get a fetch cars post');
    var userProfile = new UserProfile(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    CarController.getCarForUser(userProfile, function (err, response) {
        return res.send(response);
    });
});

router.route('/car/update').post(function (req, res) {
    console.log('get a update car post');
    var carProfile = new CarProfile(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    CarController.update(carProfile, function (err, response) {
        return res.send(response);
    });
});

router.route('/car/delete').post(function (req, res) {
    console.log('get a delete car post');
    var carProfie = new CarProfile(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    CarController.delete(carProfie, function (err, response) {
        return res.send(response);
    });
});

module.exports = router;
