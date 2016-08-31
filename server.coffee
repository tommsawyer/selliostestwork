express = require('express')
app     = do express

class Server
    constructor: () ->
        app.set 'view engine', 'jade'
       
    loadRoutes: () ->
        cities = @cities
        app.get '/', (req, res) ->
            res.render 'cities', {cities}

    setCities: (cities) ->
        @cities = cities

    start: () ->
        app.listen 3000, () ->
            console.log 'Сервер запущен на порту 3000'

module.exports = Server
