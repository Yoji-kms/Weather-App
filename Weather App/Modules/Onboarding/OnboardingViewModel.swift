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
    let coordinatesService: CoordinatesService
    let coreDataService: CoreDataService
    
    init(locationService: LocationService, coordinatesService: CoordinatesService, coreDataService: CoreDataService) {
        self.locationService = locationService
        self.coordinatesService = coordinatesService
        self.coreDataService = coreDataService
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
                self.coordinator?.pushViewController(coordinatesService: self.coordinatesService, locationService: self.locationService, coreDataService: self.coreDataService)
                UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isLocationRequested.rawValue)
            }
        case .denyDidTap:
            coordinator?.pushViewController(coordinatesService: self.coordinatesService, locationService: self.locationService, coreDataService: self.coreDataService)
            UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isLocationRequested.rawValue)
        }
    }
}
