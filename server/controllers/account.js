var AccountController = function (userModel) {
    this.crypto = require('crypto');
    this.uuid = require('node-uuid');
    this.ApiResponse = require('../models/api-response.js');
    this.ApiMessages = require('../models/api-messages.js');
    this.UserProfile = require('../models/user-profile.js');
    this.User = require('../models/user.js');
};

AccountController.prototype.hashPassword = function (password, salt, callback) {
    // We use pbkdf2 to hash and iterate 10k times by default
    var iterations = 10000,
        keyLen = 64; // 64 bit.
    this.crypto.pbkdf2(password, salt, iterations, keyLen, callback);
};

// register method
AccountController.prototype.register = function (newUser, callback) {
    var me = this;
    console.log('check if the phone exist: ' + newUser.phone);
    me.User.findOne({ phone: newUser.phone }, function (err, user) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }
        if (user) {
            console.log('already have this user');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_ALREADY_EXISTS } }));
        } else {
            console.log('valid phone number: ' + newUser.phone + ' name is ' + newUser.firstName + newUser.lastName);
            newUser.save(function (err, user, numberAffected) {
                if (err) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                }
                if (numberAffected === 1) {
                    var userProfileModel = new me.UserProfile({
                        identifier: user.id,
                        phone: user.phone,
                        firstName: user.firstName,
                        lastName: user.lastName
                    });

                    return callback(err, new me.ApiResponse({
                        success: true, extras: {
                            userProfileModel: userProfileModel
                        }
                    }));
                } else {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_CREATE_USER } }));
                }
            });
        }
    });
};

AccountController.prototype.logon = function(phone, password, callback) {
    var me = this;
    console.log('the phone number is ' + phone + ' password is ' + password);
    // the findOne method is provided by mongoose
    me.User.findOne({ phone: phone }, function (err, user) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }

        if (user) {
            me.hashPassword(password, user.passwordSalt, function (err, passwordHash) {
                // check the password hash
                if (passwordHash == user.passwordHash) {
                    // create a new user profile model and send it back to front end
                    var userProfileModel = new me.UserProfile({
                        identifier: user.id,
                        phone: user.phone,
                        firstName: user.firstName,
                        lastName: user.lastName
                    });
                    // set the session
                    // me.session.userProfileModel = userProfileModel;
                    console.log(user.phone + ' log on successfully');
                    return callback(err, new me.ApiResponse({
                        success: true, extras: {
                            userProfileModel:userProfileModel
                        }
                    }));
                } else {
                    // invalid password
                    console.log('invalid password');
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.INVALID_PWD } }));
                }
            });
        } else {
            // can not find user with this phone
            console.log('account not found');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }
    });
};

AccountController.prototype.resetPassword = function(phone, password, callback) {
    var me = this;
    console.log('the phone number is ' + phone + ' new password is ' + password);
    me.User.findOne({ phone: phone}, function(err, user) {
        if (err) {
            return callback(err, new me.ApiResponse({success: false, extras: {msg: me.ApiMessages.DB_ERROR}}));
        }

        if (user) {
            me.hashPassword(password, user.passwordSalt, function(err, passwordHash) {
                me.User.update({phone: phone}, {passwordHash: passwordHash}, function(err, numberAffected, raw) {
                    if (err) {
                        return callback(err, new me.ApiResponse({success: false, extras:{msg: me.ApiMessages.DB_ERROR}}));
                    }

                    if (numberAffected < 1) {
                        return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_RESET_PASSWORD } }));
                    } else {
                        console.log('reset password successfully');
                        var userProfileModel = new me.UserProfile({
                            identifier: user.id,
                            phone: user.phone,
                            firstName: user.firstName,
                            lastName: user.lastName
                        });
                        return callback(err, new me.ApiResponse({ success: true, extras: {userProfileModel: userProfileModel} }));
                    }
                })
            });
        } else {
            // can not find user with this phone
            console.log('account not found');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }
    });
};

AccountController.prototype.getUserFromUserRegistration = function(userRegistrationModel) {
    var me = this;
    if (userRegistrationModel.password !== userRegistrationModel.passwordConfirm) {
        return new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.PASSWORD_CONFIRM_MISMATCH } });
    }

    var passwordSaltIn = this.uuid.v4(),
            cryptoIterations = 10000, // Must match iterations used in controller#hashPassword.
            cryptoKeyLen = 64,       // Must match keyLen used in controller#hashPassword.
            passwordHashIn;

    var user = new this.User({
        phone: userRegistrationModel.phone,
        firstName: userRegistrationModel.firstName,
        lastName: userRegistrationModel.lastName,
        passwordHash: this.crypto.pbkdf2Sync(userRegistrationModel.password, passwordSaltIn, cryptoIterations, cryptoKeyLen),
        passwordSalt: passwordSaltIn
    });

    return new me.ApiResponse({ success: true, extras: { user: user } });
}

module.exports = AccountController;
