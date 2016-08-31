var request = require('request'),
    Q       = require('q');

const API_URL = 'http://demo.beaver-mysql-logger.com/cities.json';

module.exports = function() {
    return Q.promise(function(resolve, reject) {
        request(API_URL, function(err, response, body) {
            resolve(JSON.parse(body).map(function(city) {
                return [city.address, city.city, city.country].join(', ');
            }));
        });
    });
}




