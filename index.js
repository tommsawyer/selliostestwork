var getCities      = require('./lib/cities'),
    getCoordinates = require('./lib/geocoding'),
    mongo          = require('./lib/cityModel'),
    Q              = require('q'),
    express        = require('express'),
    app            = express();

var citiesCoords = [];

var loadCityCoordinates = function(address, index) {
    return getCoordinates(address).then(function(coords) {
        console.log('Получил координаты для адреса: ' + address + ' --> ' + JSON.stringify(coords) );
        var city = {
            address: address,
            longitude: coords.longitude,
            latitude: coords.latitude
        };

        mongo.saveCity(city);
        citiesCoords[index] = city;
        return address;
    });
};

console.log('Загружаю все города');
getCities().then(function(addresses) {
    console.log('Загрузил города. Адреса: \n' + JSON.stringify(addresses));
    console.log('Ищу их в монге');
    mongo.findCities(addresses).then(function(cities) {
        console.log('Нашел следующие записи: ' + cities);
        var promises = addresses.reduce(function(result, address, index) {
            var city;
            if (city = cities.find(element => element.address === address)) {
                citiesCoords[index] = city;
            } else {
                console.log('Города ' + addresses[index] + ' в бд нет. Ищу для него координаты и сохраняю');
                result.push(loadCityCoordinates(address, index));
            }

            return result;
        }, []);

        Q.all(promises).then(function(result) {
            console.log('Информация успешно загружена!');
            console.log('Запускаю сервер на 3000-ом порту');
            app.listen(3000);
        })
    });
});


app.set('view engine', 'jade');

app.get('/', function(req, res) {
    res.render('cities', {
        cities: citiesCoords
    });
});
