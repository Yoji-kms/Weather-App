//
//  MainData.swift
//  Weather App
//
//  Created by Yoji on 01.02.2024.
//

import Foundation

struct MainData {
    let temp: Int
    let feelsLike: Int
    let tempMin: Int
    let tempMax: Int
    let humidity: Int
    
    init(temp: Float, feelsLike: Float, tempMin: Float, tempMax: Float, humidity: Int) {
        self.temp = temp.toRoundedInt
        self.feelsLike = feelsLike.toRoundedInt
        self.tempMin = tempMin.toRoundedInt
        self.tempMax = tempMax.toRoundedInt
        self.humidity = humidity
    }
    
    init() {
        self.temp = 0
        self.feelsLike = 0
        self.tempMin = 0
        self.tempMax = 0
        self.humidity = 0
    }
}

extension Float {
    var toRoundedInt: Int {
        Int(self.rounded(.toNearestOrEven))
    }
}
