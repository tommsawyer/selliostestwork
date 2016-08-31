var request = require('request'),
    Q       = require('q');

const GOOGLE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json';
const GOOGLE_API_KEY = 'AIzaSyDd9rKprmpXcngwAXDj-pV6WSkmnWz8kn0';

var getUrl = function(address) {
    return GOOGLE_API_URL + '?key=' + GOOGLE_API_KEY + '&address=' + encodeURIComponent(address);
};

var getCoordinates = function(address) {
    var requestOptions = {
        url: getUrl(address),
    };
    
    return Q.promise(function(resolve, reject) {
        request(requestOptions, function(err, response, body) {
            var body = JSON.parse(body);

            resolve({
                longitude: body.results[0].geometry.location.lng,
                latitude: body.results[0].geometry.location.lat
            });
        });
    });
};

module.exports = getCoordinates;
