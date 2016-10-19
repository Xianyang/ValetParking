var express = require('express'),
    router = express.Router(),
    UserProfile = require('../models/user/user-profile.js'),
    OrderController = require('../controllers/order.js'),
    Order = require('../models/order/order.js'),
    OrderCreation = require('../models/order/order-creation.js');


var orderController = new OrderController();

router.route('/order/add').post(function (req, res) {
    console.log('----------get a create order post----------');
    // var order = new OrderCreation(req.body);
    var order = new Order(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    orderController.add(order, function (err, response) {
        return res.send(response);
    });
});

router.route('/order/get_orders_for_user').post(function (req, res) {
    console.log('----------get a fetch orders post----------');
    var userProfile = new UserProfile(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    orderController.getOrderForUser(userProfile, function (err, response) {
        return res.send(response);
    });
});

// router.route('/car/get_cars_for_user').post(function (req, res) {
//     console.log('get a fetch cars post');
//     var userProfile = new UserProfile(req.body);
//
//     res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.
//
//     CarController.getCarForUser(userProfile, function (err, response) {
//         return res.send(response);
//     });
// });
//
// router.route('/car/update').post(function (req, res) {
//     console.log('get a update car post');
//     var carProfile = new CarProfile(req.body);
//
//     res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.
//
//     CarController.update(carProfile, function (err, response) {
//         return res.send(response);
//     });
// });
//
// router.route('/car/delete').post(function (req, res) {
//     console.log('get a delete car post');
//     var carProfie = new CarProfile(req.body);
//
//     res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.
//
//     CarController.delete(carProfie, function (err, response) {
//         return res.send(response);
//     });
// });

module.exports = router;
