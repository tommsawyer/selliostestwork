require('coffee-script/register');

var Server = require('./server.coffee');
var loadCities = require('./loadcities.coffee');

loadCities().then(function(cities) {
    var server = new Server();
    server.setCities(cities);
    server.loadRoutes();
    server.start();
});
