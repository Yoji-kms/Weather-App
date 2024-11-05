//
//  DailyWeatherReportViewModel.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

final class DailyWeatherReportViewModel: DailyWeatherReportViewModelProtocol {
    weak var coordinator: DailyWeatherReportCoordinator?
    
    let dates: [Date]
    let city: String
    private let forecast: Forecast
    
    private lazy var dailyWeathers = {
        var weathers = [DailyWeather]()
        
        for dateIndex in 1..<self.dates.count {
            let currentDate = self.dates[dateIndex-1]
            let nextDate = self.dates[dateIndex]
            
            let currentDayWeathers = self.forecast.list.filter { $0.dt.isEqualWithDate(currentDate) }
            let nextDayWeathers = self.forecast.list.filter { $0.dt.isEqualWithDate(nextDate) }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            
            let dayWeather = currentDayWeathers.getByHours(12)
            let nightWeather = nextDayWeathers.getByHours(0)
            
            let dailyWeather = DailyWeather(dayWeather: dayWeather, nightWeather: nightWeather, date: currentDate)
            
            weathers.append(dailyWeather)
        }
        
        guard let lastDate = self.dates.last else { return weathers }
        let lastDateWeathers = self.forecast.list.filter { $0.dt.isEqualWithDate(lastDate) }
        
        var lastDayWeather: Weather?
        
        if lastDateWeathers.count == 4 {
            lastDayWeather = lastDateWeathers.getByHours(9)
        } else if lastDateWeathers.count > 4 {
            lastDayWeather = lastDateWeathers.getByHours(12)
        }
        
        guard let lastDayWeather else { return weathers }
        
        let lastDailyWeather = DailyWeather(dayWeather: lastDayWeather, nightWeather: nil, date: lastDate)
        weathers.append(lastDailyWeather)
        
        return weathers
    }()
    
    
    
    init(forecast: Forecast) {
        self.forecast = forecast
        self.city = forecast.city.name
        self.dates = forecast.dates.uniqueDatesWithoutCurrent()
    }
    
    func updateWeatherBy(dateId: Int, completion: @escaping (DailyWeather?)->Void) {
        let dailyWeather = dateId < self.dailyWeathers.count ? self.dailyWeathers[dateId] : nil
        completion(dailyWeather)
    }
}

private extension [Weather] {
    func getByHours(_ hours: Int) -> Weather {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        guard let result = self.filter({ weather in
            let weatherHours = dateFormatter.string(from: weather.dt)
            return Int(weatherHours) == hours
        }).first else {
            return Weather()
        }
        
        return result
    }
}

struct DailyWeather {
    let dayWeather: Weather
    let nightWeather: Weather?
    let date: Date
}
