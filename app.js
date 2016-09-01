require('coffee-script/register');

var Server = require('./server.coffee');
var loadLocations = require('./loadlocations.coffee');

loadLocations().then(function(locations) {
    var server = new Server();
    server.setLocations(locations);
    server.loadRoutes();
    server.start();
});
