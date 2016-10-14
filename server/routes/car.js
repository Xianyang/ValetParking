var express = require('express'),
    router = express.Router(),
    AccountController = require('../controllers/account.js'),
    CarController = require('../controllers/car.js'),
    User = require('../models/user.js'),
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

module.exports = router;
