var express = require('express'),
    router = express.Router(),
    ValetController = require('../controllers/valet.js'),
    ValetRegistration = require('../models/valet/valet-registration.js'),
    ValetLogon = require('../models/valet/valet-logon.js'),
    ValetResetPassword = require('../models/valet/valet-reset-pwd.js'),
    Valet = require('../models/valet/valet.js'),
    ValetSession = require('../models/valet/valet-session.js'),
    ApiResponse = require('../models/api-response.js');

var valetController = new ValetController(Valet);

router.route('/account/valet/register').post(function (req, res) {
    console.log('get a valet register post')

    var valetRegistration = new ValetRegistration(req.body);

    // If there's no form data, send a bad request code.
    if (!valetRegistration.phone) {
        res.status(400);
        return res.send('');
    }

    // check if the two passwords are identical
    var apiResponseStep1 = valetController.getValetFromValetRegistration(valetRegistration);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    if (apiResponseStep1.success) {
        valetController.register(apiResponseStep1.extras.valet, function (err, apiResponseStep2) {
            return res.send(apiResponseStep2);
        });
    } else {
        return res.send(apiResponseStep1);
    }
});

router.route('/account/valet/logon').post(function (req, res) {
    console.log('get a valet logon post');
    var valetLogon = new ValetLogon(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    valetController.logon(valetLogon.phone, valetLogon.password, function (err, response) {
        return res.send(response);
    });
});

router.route('/account/valet/set_new_password').post(function (req, res) {
    console.log('get a valet set new password post');
    var valetResetPassword = new ValetResetPassword(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    valetController.resetPassword(valetResetPassword.phone, valetResetPassword.password, function(err, response) {
        return res.send(response);
    });
});

module.exports = router;
