//
//  MainScreenViewModelProtocol.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

protocol MainScreenViewModelProtocol: ViewModelProtocol {
    func updateStateNet(request: MainScreenViewModel.NetRequest)
    func updateState(viewInput: MainScreenViewModel.ViewInput)
    var weather: Weather { get }
    var forecast: Forecast { get }
}
