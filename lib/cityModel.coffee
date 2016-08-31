mongoClient = require('mongodb').MongoClient
config      = require '../config.json'
Q           = require 'q'

saveCity = (json) ->
    return Q.promise (resolve, reject) ->
        mongoClient.connect config.mongodburl, (err, db) ->
            cities = db.collection 'cities'
            
            cities.insert json, (err, results) ->
                resolve results
                do db.close

findCities = (addresses) ->
    Q.promise (resolve, reject) ->
        mongoClient.connect config.mongodburl, (err, db) ->
            cities = db.collection 'cities'
            
            cities.find({address: {$in: addresses}}).toArray (err, cities) ->
                resolve cities
                do db.close

module.exports = { saveCity, findCities }

