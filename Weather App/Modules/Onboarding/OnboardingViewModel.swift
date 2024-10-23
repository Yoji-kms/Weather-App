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
    
    let locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    enum ViewInput {
        case acceptDidTap
        case denyDidTap
    }
    
    func updateState(input: ViewInput) {
        switch input {
        case .acceptDidTap:
            self.locationService.requestWhenInUseAuthorization() { [weak self] in
                guard let self else { return }
                self.coordinator?.pushViewController()
                UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isLocationRequested.rawValue)
            }
        case .denyDidTap:
            coordinator?.pushViewController()
            UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isLocationRequested.rawValue)
        }
    }
}
