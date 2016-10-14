var express = require('express'),
    bodyParser = require('body-parser'),
    cookieParser = require('cookie-parser'),
    mongoose = require('mongoose'),
    expressSession = require('express-session'),
    MongoStore = require('connect-mongo')(expressSession),
    accountRoute = require('./routes/account'),
    carRoute = require('./routes/car'),
    // bookingRoutes = require('./routes/bookings'),
    assert = require('assert')
    app = express(),
    port = 3001;

var dbName = 'bookitDB';
var connectionString = 'mongodb://localhost:27017/' + dbName;

mongoose.connect(connectionString);

app.use(expressSession({
    secret: '128013A7-5B9F-4CC0-BD9E-4480B2D3EFE9',
    resave: true,
    saveUninitialized: true,
    store: new MongoStore({
        url: 'mongodb://localhost/test-app',
        ttl: 20 * 24 * 60 * 60 // = 20 days.
    })
}));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
// app.use('/api', [accountRoutes, bookingRoutes]);
// set routers
app.get('/', function (req, res) {
	res.send('<html><body><h1>Hello World</h1></body></html>');
});

app.use('/api', [accountRoute, carRoute]);

var server = app.listen(port, function () {
    console.log('Express server listening on port ' + server.address().port);
});
