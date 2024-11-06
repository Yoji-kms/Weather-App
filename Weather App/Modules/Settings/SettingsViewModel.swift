//
//  SettingsViewModel.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

final class SettingsViewModel: SettingsViewModelProtocol {
    weak var coordinator: SettingsCoordinator?
    
    let temperatureBool: Bool
    let windSpeedBool: Bool
    let timeFormatBool: Bool
    let notificationsBool: Bool
    
    init() {
        let settings = Settings.shared
        self.temperatureBool = settings.temperature.bool
        self.windSpeedBool = settings.windSpeed.bool
        self.timeFormatBool = settings.timeFormat.bool
        self.notificationsBool = settings.isNotificationsOff
    }
    
    func updateSettings(
        temperatureBool: Bool,
        windSpeedBool: Bool,
        timeFormatBool: Bool,
        notificationsBool: Bool
    ) {
        Settings.shared.update(
            temperatureBool: temperatureBool,
            windSpeedBool: windSpeedBool,
            timeFormatBool: timeFormatBool,
            notificationsBool: notificationsBool
        )
        
        self.coordinator?.popViewController()
    }
}
