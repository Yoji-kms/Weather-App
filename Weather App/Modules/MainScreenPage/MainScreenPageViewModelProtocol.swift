//
//  MainScreenPageViewModelProtocol.swift
//  Weather App
//
//  Created by Yoji on 13.02.2024.
//

import Foundation

protocol MainScreenPageViewModelProtocol: ViewModelProtocol {
    func updateState(input: MainScreenPageViewModel.ViewInput)
    var data: [Coordinates] { get }
}
