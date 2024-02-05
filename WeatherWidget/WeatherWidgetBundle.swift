//
//  WeatherWidgetBundle.swift
//  WeatherWidget
//
//  Created by Yoji on 23.10.2023.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
        WeatherWidgetLiveActivity()
    }
}
