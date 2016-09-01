getLocations   = require "./lib/locations"
getCoordinates = require "./lib/geocoding"
mongo          = require "./lib/locationModel"
Q              = require "q"


loadLocationCoordinates = (address) ->
    getCoordinates(address).then (coords) ->
        console.log "Получил координаты для адреса: #{address}  --> #{JSON.stringify(coords)}"

        location = {
            address: address,
            longitude: coords.longitude,
            latitude: coords.latitude
        }

        mongo.saveLocation location
        location

module.exports = () ->
    console.log 'Загружаю города'
    loadedLocations = []
    loadedAddresses = []
    
    getLocations().then (addresses) ->
        loadedAddresses = addresses
        console.log "Загрузил города. Адреса: \n #{JSON.stringify(addresses)}"
        console.log 'Ищу их в монге'
        mongo.findLocations(addresses)
    .then (locations) ->
        console.log "Нашел следующие записи: #{JSON.stringify(locations)}"

        loadedAddresses.reduce (result, address, index) ->
            location = locations.find (element) ->
                element.address == address

            if (location)
                loadedLocations[index] = location
            else
                console.log "Города #{address} в бд нет. Ищу для него координаты и сохраняю"
                result.push(loadLocationCoordinates(address).then (location) ->
                    loadedLocations[index] = location
                )

            return result
        , []
    .then Q.all
    .then () ->
        loadedLocations
