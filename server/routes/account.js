var express = require('express'),
    router = express.Router(),
    AccountController = require('../controllers/account.js'),
    UserRegistration = require('../models/user/user-registration.js'),
    UserLogon = require('../models/user/user-logon.js'),
    UserResetPassword = require('../models/user/user-reset-pwd.js'),
    User = require('../models/user/user.js'),
    UserSession = require('../models/user/user-session.js'),
    ApiResponse = require('../models/api-response.js');

var accountController = new AccountController(User);

router.route('/account/user/register').post(function (req, res) {
    console.log('get a user register post')
    // var accountController = new AccountController(User);
    var userRegistration = new UserRegistration(req.body);

    // If there's no form data, send a bad request code.
    if (!userRegistration.phone) {
        res.status(400);
        return res.send('');
    }

    // check if the two passwords are identical
    var apiResponseStep1 = accountController.getUserFromUserRegistration(userRegistration);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    if (apiResponseStep1.success) {
        accountController.register(apiResponseStep1.extras.user, function (err, apiResponseStep2) {
            return res.send(apiResponseStep2);
        });
    } else {
        return res.send(apiResponseStep1);
    }
});

router.route('/account/user/logon').post(function (req, res) {
    console.log('get a user logon post');
    var userLogon = new UserLogon(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    accountController.logon(userLogon.phone, userLogon.password, function (err, response) {
        return res.send(response);
    });
});

router.route('/account/user/set_new_password').post(function (req, res) {
    console.log('get a user reset password post');
    var userResetPassword = new UserResetPassword(req.body);

    res.set("Access-Control-Allow-Origin", "http://localhost:42550");   // Enable CORS in dev environment.

    accountController.resetPassword(userResetPassword.phone, userResetPassword.password, function(err, response) {
        return res.send(response);
    });
});

module.exports = router;
