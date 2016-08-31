request        = require 'request'
Q              = require 'q'
GOOGLE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json'
GOOGLE_API_KEY = 'AIzaSyDd9rKprmpXcngwAXDj-pV6WSkmnWz8kn0'

getUrl = (address) ->
   "#{GOOGLE_API_URL}?key=#{GOOGLE_API_KEY}&address=#{encodeURIComponent(address)}"

getCoordinates = (address) ->
    Q.promise (resolve, reject) ->
        url = getUrl(address)
        request url, (err, response, body) ->
            parsedBody = JSON.parse body

            resolve {
                longitude: parsedBody.results[0].geometry.location.lng,
                latitude: parsedBody.results[0].geometry.location.lat
            }

module.exports = getCoordinates
