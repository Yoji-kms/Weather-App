//
//  Forecast.swift
//  Weather App
//
//  Created by Yoji on 01.02.2024.
//

import Foundation

struct Forecast {
    let list: [Weather]
    let city: City
    let dates: [Date]
    
    init(list: [Weather], city: City) {
        self.list = list
        self.city = city
        self.dates = list.map { $0.dt }.uniqueDates()
    }
    
    init() {
        self.list = []
        self.city = City()
        self.dates = []
    }
}
