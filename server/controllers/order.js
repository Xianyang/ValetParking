var OrderController = function () {
    this.ApiResponse = require('../models/api-response.js'),
    this.ApiMessages = require('../models/api-messages.js'),
    this.CarProfile = require('../models/car/car-profile.js'),
    this.User = require('../models/user/user.js'),
    this.Valet = require('../models/valet/valet.js'),
    this.Car = require('../models/car/car.js'),
    this.Order = require('../models/order/order.js'),
    this.Async = require('Async');
};

// register method
OrderController.prototype.add = function (newOrder, callback) {
    var me = this;

    // Step 1 - check if the user exist
    me.User.findOne({ phone: newOrder.userPhone }, function (err, user) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }
        if (user) {
            // Step 2 - check if the car exist
            me.Car.findOne({ plate: newOrder.carPlate}, function (err, car) {
                if (err) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                }

                if (car) {
                    // Step 3 - check if the order exist
                    me.Order.find({userPhone: newOrder.userPhone, carPlate: newOrder.carPlate}, function (err, orders) {
                        if (err) {
                            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                        }

                        if (orders.length) {
                            for (var i = 0; i < orders.length; i++) {
                                if (orders[i].endAt == undefined) {
                                    console.log('order exist, create at ' + orders[i].createAt);
                                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ORDER_ALREADY_EXISTS }}));
                                }
                            }
                        }

                        newOrder.createAt = new Date();
                        newOrder.userIdentifier = user._id;
                        newOrder.userFirstName = user.firstName;
                        newOrder.userLastName = user.lastName;
                        newOrder.userPhone = user.phone;
                        newOrder.carIdentifier = car._id;
                        newOrder.carPlate = car.plate;
                        newOrder.carBrand = car.brand;
                        newOrder.carColor = car.color;

                        newOrder.save(function (err, car, numberAffected) {
                            if (err) {
                                return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                            }

                            if (numberAffected === 1) {
                                console.log('add an order successfully with plate ' + newOrder.carPlate);
                                return callback(err, new me.ApiResponse({
                                    success: true, extras: {
                                        orderProfileModel: newOrder
                                    }
                                }));
                            } else {
                                return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                            }
                        });
                    });
                } else {
                    console.log('can not fine this car');
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_FIND_CAR } }));
                }
            });
        } else {
            console.log('can not find this user');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }
    });
};

OrderController.prototype.getOrderForUser = function (userProfile, callback) {
    var me = this;

    // check if the user exist
    me.User.findOne({ phone: userProfile.phone }, function (err, user) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }
        if (user) {
            console.log('found the user, name is ' + user.firstName + user.lastName);
            me.Order.find({userPhone: user.phone}, function (err, orders) {
                if (err) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                }

                console.log('This user has ' + orders.length + ' orders');
                return callback(err, new me.ApiResponse({success: true, extras:{orders: orders}}));
            });
        } else {
            console.log('can not find this user');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }
    });
}

OrderController.prototype.getAllOrders = function (valetProfile, callback) {
    var me = this;

    // check if the user exist
    me.Valet.findOne({ phone: valetProfile.phone }, function (err, valet) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }
        if (valet) {
            console.log('found the valet, name is ' + valet.firstName + valet.lastName);
            me.Order.find({endAt: undefined}, function (err, orders) {
                if (err) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                }

                console.log('There are ' + orders.length + ' opening orders');
                return callback(err, new me.ApiResponse({success: true, extras:{orders: orders}}));
            });
        } else {
            console.log('can not find this user');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }
    });
}

OrderController.prototype.recallOrderByUser = function (orderRecall, callback) {
    var me = this;

    // Step 1 - check if the user exist
    me.User.findOne({ phone: orderRecall.userPhone }, function (err, user) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }

        if (!user) {
            console.log('can not find this user');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ACCOUNT_NOT_FOUND } }));
        }

        console.log('found the user, name is ' + user.firstName + user.lastName);
        // Step 2 - check if the car exist
        me.Car.findOne({ plate: orderRecall.carPlate}, function (err, car) {
            if (err) {
                return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
            }

            if (!car) {
                // delete this order
                me.Order.find({_id:orderRecall._id }).remove().exec();
                console.log('can not find this car');
                return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_FIND_CAR}}));
            }

            console.log('found the car, plate is ' + car.plate);

            // Step 3 - check if the order exist
            me.Order.findOne({_id: orderRecall._id}, function (err, order) {
                if (err) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                }

                if (!order) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_FIND_ORDER}}));
                }

                if (order.userRequestAt == undefined && order.endAt == undefined) {
                    order.userRequestAt = new Date();

                    order.save(function (err, order, numberAffected) {
                        if (err) {
                            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                        }

                        if (numberAffected === 1) {
                            console.log('recall an order successfully with car plate ' + order.carPlate);
                            return callback(err, new me.ApiResponse({success: true, extras: {orderProfileModel: order}}));
                        } else {
                            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_UPDATE_ORDER } }));
                        }
                    });
                } else {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.ORDER_ALREADY_RECALLED } }));
                }
            });
        });
    });
};

OrderController.prototype.endOrderByValet = function (orderEnd, callback) {
    var me = this;

    // Step 1 - check if the user exist
    me.Valet.findOne({ phone: orderEnd.valetPhone }, function (err, valet) {
        if (err) {
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
        }

        if (!valet) {
            console.log('can not find this valet');
            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.VALET_NOT_FOUND}}));
        }

        console.log('found the valet, name is ' + valet.firstName + valet.lastName);
        // Step 2 - check if the car exist
        me.Car.findOne({ plate: orderEnd.carPlate}, function (err, car) {
            if (err) {
                return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
            }

            if (!car) {
                // delete this order
                me.Order.find({_id:orderEnd._id }).remove().exec();
                console.log('can not find this car');
                return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_FIND_CAR}}));
            }

            console.log('found the car, plate is ' + car.plate);

            // Step 3 - check if the order exist
            me.Order.findOne({_id: orderEnd._id}, function (err, order) {
                if (err) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                }

                if (!order) {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_FIND_ORDER}}));
                }

                if (order.userRequestAt != undefined && order.endAt == undefined) {
                    order.endAt = new Date();

                    order.save(function (err, order, numberAffected) {
                        if (err) {
                            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.DB_ERROR } }));
                        }

                        if (numberAffected === 1) {
                            console.log('end an order successfully with car plate ' + order.carPlate);
                            return callback(err, new me.ApiResponse({success: true, extras: {orderProfileModel: order}}));
                        } else {
                            return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_UPDATE_ORDER } }));
                        }
                    });
                } else {
                    return callback(err, new me.ApiResponse({ success: false, extras: { msg: me.ApiMessages.COULD_NOT_UPDATE_ORDER } }));
                }
            });
        });
    });
};


function processArray(items, process) {
    var todo = items.concat();

    setTimeout(function() {
        process(todo.shift());
        if(todo.length > 0) {
            setTimeout(arguments.callee, 25);
        }
    }, 25);
}

module.exports = OrderController;
