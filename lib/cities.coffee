request = require 'request'
Q       = require 'q'
API_URL = 'http://demo.beaver-mysql-logger.com/cities.json'

module.exports = () -> 
    Q.promise (resolve, reject) ->
        request API_URL, (err, response, body) ->
            addresses = JSON.parse(body).map (city) ->
                [city.address, city.city, city.country].join(', ')
            
            resolve addresses
