var mongoClient = require('mongodb').MongoClient,
    config      = require('../config.json');

var Q           = require('q');

var saveCity = function(json) {
    return Q.promise(function(resolve, reject) {
        mongoClient.connect(config.mongodburl, function(err, db) {
            var cities = db.collection('cities');
            
            cities.insert(json, function(err, results) {
                resolve(results);
                db.close();
            });
        });
    });
};

var findCities = function(addresses) {
    return Q.promise(function(resolve, reject) {
        mongoClient.connect(config.mongodburl, function(err, db) {
            var cities = db.collection('cities');
            
            cities.find({address: {$in: addresses}}).toArray(function(err, cities) {
                resolve(cities);
                db.close();
            });
        })
    });
};

module.exports = { saveCity, findCities  };

