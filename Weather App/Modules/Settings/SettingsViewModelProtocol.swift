//
//  SettingsViewModelProtocol.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

protocol SettingsViewModelProtocol: ViewModelProtocol {
    func updateSettings(
        temperatureBool: Bool,
        windSpeedBool: Bool,
        timeFormatBool: Bool,
        notificationsBool: Bool
    )
}
