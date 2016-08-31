getCities      = require "./lib/cities"
getCoordinates = require "./lib/geocoding"
mongo          = require "./lib/cityModel"
Q              = require "q"

citiesCoords = []

loadCityCoordinates = (address, index) ->
    getCoordinates(address).then (coords) ->
        console.log "Получил координаты для адреса: #{address}  --> #{JSON.stringify(coords)}"

        city = {
            address: address,
            longitude: coords.longitude,
            latitude: coords.latitude
        }

        mongo.saveCity city
        citiesCoords[index] = city
        address

module.exports = () ->
    console.log 'Загружаю города'

    getCities().then (addresses) ->
        console.log "Загрузил города. Адреса: \n #{JSON.stringify(addresses)}"
        console.log 'Ищу их в монге'

        mongo.findCities(addresses).then (cities) ->
            console.log "Нашел следующие записи: #{JSON.stringify(cities)}"

            promises = addresses.reduce (result, address, index) ->
                city = cities.find (element) ->
                    element.address == address

                if (city)
                    citiesCoords[index] = city
                else
                    console.log "Города #{address} в бд нет. Ищу для него координаты и сохраняю"
                    result.push(loadCityCoordinates(address, index))

                return result
            , []

            Q.all(promises).then () ->
                citiesCoords
