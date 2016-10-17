var AccountController = function (valetModel) {
    this.crypto = require('crypto');
    this.uuid = require('node-uuid');
    this.ApiResponse = require('../models/api-response.js');
    this.ApiMessages = require('../models/api-messages.js');
    this.ValetProfile = require('../models/valet/valet-profile.js');
    this.Valet = require('../models/valet/valet.js');
};

AccountController.prototype.hashPassword = function (password, salt, callback) {
    // We use pbkdf2 to hash and iterate 10k times by default
    var iterations = 10000,
        keyLen = 64; // 64 bit.
    this.crypto.pbkdf2(password, salt, iterations, keyLen, callback);
};

// register method
AccountController.prototype.register = function (newValet, callback) {
    var me = this;
    console.log('check if the phone exist: ' + newValet.phone);
    me.Valet.findOne({ phone: newValet.phone }, function (err, valet) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }
        if (valet) {
            console.log('already have this valet');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_ALREADY_EXISTS } }));
        } else {
            console.log('valid phone number: ' + newValet.phone + ' name is ' + newValet.firstName + newValet.lastName);
            newValet.save(function (err, valet, numberAffected) {
                if (err) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                }
                if (numberAffected === 1) {
                    var valetProfileModel = new me.ValetProfile({
                        identifier: valet.id,
                        phone: valet.phone,
                        firstName: valet.firstName,
                        lastName: valet.lastName
                    });

                    console.log('create valet successfully with phone ' + valet.phone);
                    return callback(err, new me.ApiResponse({
                        success: true, extras: {
                            valetProfileModel: valetProfileModel
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
    me.Valet.findOne({ phone: phone }, function (err, valet) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }
        if (valet) {
            me.hashPassword(password, valet.passwordSalt, function (err, passwordHash) {
                // check the password hash
                if (passwordHash == valet.passwordHash) {
                    // create a new valet profile model and send it back to front end
                    var valetProfileModel = new me.ValetProfile({
                        identifier: valet.id,
                        phone: valet.phone,
                        firstName: valet.firstName,
                        lastName: valet.lastName
                    });
                    // set the session
                    // me.session.valetProfileModel = valetProfileModel;
                    console.log(valet.phone + ' valet log on successfully');
                    return callback(err, new me.ApiResponse({
                        success: true, extras: {
                            valetProfileModel:valetProfileModel
                        }
                    }));
                } else {
                    // invalid password
                    console.log('invalid password');
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.INVALID_PWD } }));
                }
            });
        } else {
            // can not find valet with this phone
            console.log('account not found');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }
    });
};

AccountController.prototype.resetPassword = function(phone, password, callback) {
    var me = this;
    console.log('the phone number is ' + phone + ' new password is ' + password);
    me.Valet.findOne({ phone: phone}, function(err, valet) {
        if (err) {
            return callback(err, new me.ApiResponse({success: false, extras: {msg: me.ApiMessages.DB_ERROR}}));
        }

        if (valet) {
            me.hashPassword(password, valet.passwordSalt, function(err, passwordHash) {
                me.Valet.update({phone: phone}, {passwordHash: passwordHash}, function(err, numberAffected, raw) {
                    if (err) {
                        return callback(err, new me.ApiResponse({success: false, extras:{msg: me.ApiMessages.DB_ERROR}}));
                    }

                    if (numberAffected < 1) {
                        return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_RESET_PASSWORD } }));
                    } else {
                        console.log(valet.phone + ' valet reset password successfully');
                        var valetProfileModel = new me.ValetProfile({
                            identifier: valet.id,
                            phone: valet.phone,
                            firstName: valet.firstName,
                            lastName: valet.lastName
                        });
                        return callback(err, new me.ApiResponse({ success: true, extras: {valetProfileModel: valetProfileModel} }));
                    }
                })
            });
        } else {
            // can not find valet with this phone
            console.log('account not found');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }
    });
};

AccountController.prototype.getValetFromValetRegistration = function(valetRegistrationModel) {
    var me = this;
    if (valetRegistrationModel.password !== valetRegistrationModel.passwordConfirm) {
        return new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.PASSWORD_CONFIRM_MISMATCH } });
    }

    var passwordSaltIn = this.uuid.v4(),
            cryptoIterations = 10000, // Must match iterations used in controller#hashPassword.
            cryptoKeyLen = 64,       // Must match keyLen used in controller#hashPassword.
            passwordHashIn;

    var valet = new this.Valet({
        phone: valetRegistrationModel.phone,
        firstName: valetRegistrationModel.firstName,
        lastName: valetRegistrationModel.lastName,
        passwordHash: this.crypto.pbkdf2Sync(valetRegistrationModel.password, passwordSaltIn, cryptoIterations, cryptoKeyLen),
        passwordSalt: passwordSaltIn
    });

    return new me.ApiResponse({ success: true, extras: { valet: valet } });
}

module.exports = AccountController;
