mongoClient = require('mongodb').MongoClient
config      = require '../config.json'
Q           = require 'q'

saveLocation = (json) ->
    return Q.promise (resolve, reject) ->
        mongoClient.connect config.mongodburl, (err, db) ->
            locations = db.collection 'locations'
            
            locations.insert json, (err, inserted) ->
                resolve inserted
                do db.close

findLocations = (addresses) ->
    Q.promise (resolve, reject) ->
        mongoClient.connect config.mongodburl, (err, db) ->
            locations = db.collection 'locations'
            
            locations.find({address: {$in: addresses}}).toArray (err, locations) ->
                resolve locations
                do db.close

module.exports = { saveLocation, findLocations }
