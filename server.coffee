express = require('express')
app     = do express

class Server
    constructor: () ->
        app.set 'view engine', 'jade'
       
    loadRoutes: () ->
        locations = @locations
        app.get '/', (req, res) ->
            res.render 'locations', {locations}

    setLocations: (locations) ->
        @locations = locations

    start: () ->
        app.listen 3000, () ->
            console.log 'Сервер запущен на порту 3000'

module.exports = Server
