//
//  OnboardingViewModel.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation
import CoreLocation

final class OnboardingViewModel: OnboardingViewModelProtocol {
    var coordinator: OnboardingCoordinator?
    
    let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    enum ViewInput {
        case acceptDidTap
        case denyDidTap
    }
    
    func updateState(input: ViewInput) {
        switch input {
        case .acceptDidTap:
            self.locationManager.requestWhenInUseAuthorization()
            coordinator?.pushViewController()
        case .denyDidTap:
            coordinator?.pushViewController()
        }
        UserDefaults.standard.setValue(true, forKey: "isLocationRequested")
    }
}
