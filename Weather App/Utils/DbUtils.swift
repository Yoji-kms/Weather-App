//
//  DbUtils.swift
//  Weather App
//
//  Created by Yoji on 01.02.2024.
//

import Foundation

extension ForecastEntity {
    func toForecast() -> Forecast? {
        let weatherList = (
            self.weather?.map { weather in
                (weather as? WeatherEntity)?.toWeather() ?? Weather()
            } ?? []
        ).sorted { weather1, weather2 in
            let date1 = weather1.dt
            let date2 = weather2.dt
            return date1 < date2
        }
        guard let city = self.city?.toCity() else { return nil }
        let forecast = Forecast(
            list: weatherList,
            city: city
        )
        return forecast
    }
}

extension WeatherEntity {
    func toWeather() -> Weather {
        let weather = Weather(
            coord: self.coordWeather?.toCoordinates(),
            weatherItem: self.weatherItem?.toWeatherItem() ?? WeatherItem(),
            main: self.mainData?.toMainData() ?? MainData(),
            clouds: self.clouds?.toClouds() ?? Clouds(),
            wind: self.wind?.toWind() ?? Wind(),
            dt: self.dt ?? Date(),
            pop: self.pop,
            sys: self.sys?.toSys(),
            name: self.name
        )
        
        return weather
    }
}

extension CityEntity {
    func toCity() -> City {
        let city = City(
            name: self.name ?? "",
            coord: self.coordCity?.toCoordinates() ?? Coordinates(),
            sunset: self.sunset ?? Date(),
            sunrise: self.sunrise ?? Date()
        )
        return city
    }
}

extension CoordinatesEntity {
    func toCoordinates() -> Coordinates? {
        let coordinates = Coordinates(dbCoord: self)
        return coordinates
    }
}

extension WeatherItemEntity {
    func toWeatherItem() -> WeatherItem {
        return WeatherItem(description: self.weatherDescription ?? "", main: self.main ?? "")
    }
}

extension MainDataEntity {
    func toMainData() -> MainData {
        let mainData = MainData(
            temp: self.temp,
            feelsLike: self.feelsLike,
            tempMin: self.tempMin,
            tempMax: self.tempMax,
            humidity: Int(self.humidity)
        )
        return mainData
    }
}

extension CloudsEntity {
    func toClouds() -> Clouds {
        return Clouds(all: Int(self.all))
    }
}

extension WindEntity {
    func toWind() -> Wind {
        return Wind(speed: self.speed, deg: Int(self.deg))
    }
}

extension SysEntity {
    func toSys() -> Sys {
        let sys = Sys(sunrise: self.sunrise, sunset: self.sunset, pod: self.pod)
        return sys
    }
}
