//
//  MainScreenPageViewModel.swift
//  Weather App
//
//  Created by Yoji on 13.02.2024.
//

import UIKit
import CoreLocation

final class MainScreenPageViewModel: MainScreenPageViewModelProtocol {
    var coordinator: MainScreenPageCoordinator?
    private let locationService: LocationService
    private let coordinatesServise: CoordinatesService
    
    private(set) var data: [Coordinates] = []
    
    enum ViewInput {
        case cityChanged(()->Void)
        case initCity(([UIViewController])->Void)
        case locationButtonDidTap((MainScreenViewController)->Void)
    }
    
    init(coordinatesServise: CoordinatesService, locationService: LocationService) {
        self.coordinatesServise = coordinatesServise
        self.locationService = locationService
    }
    
    func updateState(input: ViewInput) {
        switch input {
        case .cityChanged(let completion):
            completion()
        case .initCity(let completion):
            self.initCity(completion: completion)
        case .locationButtonDidTap(let completion):
            self.coordinator?.presentCreateFolderAlertController() { newCityString in
                let basicUrl = NetworkService.shared.getUrl(requestType: .geo(newCityString))
                
                let url = basicUrl
                Task {
                    guard
                        let geoResponses: [GeoResponse] = await url.handleAsDecodable(),
                        let geoResponse = geoResponses.first
                    else { return }
                    let coordinates = geoResponse.coordinates
                    
                    if !self.data.contains(coordinates) {
                        self.coordinatesServise.saveCoordinates(coordinates) { dbCoordinates in
                            self.data = dbCoordinates.map { $0.toCoordinates() ?? Coordinates() }
                            guard let newMainScreenViewController = self.coordinator?.addMainViewController(
                                with: coordinates
                            ) else { return }
                            completion(newMainScreenViewController)
                        }
                    }
                }
            }
        }
    }
    
    private func initCity(completion: @escaping ([UIViewController])->Void) {
        self.coordinatesServise.fetch { [weak self] dbCoordinates in
            guard let self else { return }
            
            self.data = dbCoordinates
                .map { $0.toCoordinates() ?? Coordinates() }
            
            if
                !self.data.contains(where: { $0.isCurrentLocation }),
                self.locationService.isAuthorized
            {
                self.locationService.getLocation() { [weak self] newCoordinates in
                    guard let self else { return }
                    self.coordinatesServise.saveCoordinates(newCoordinates) { newDbCoordinates in
                        self.data = newDbCoordinates
                            .map { $0.toCoordinates() ?? Coordinates() }
                        self.addMainScreenControllersForData(completion: completion)
                    }
                }
            } else if !self.data.isEmpty {
                self.addMainScreenControllersForData(completion: completion)
            } else {
                guard
                    let initialViewController = self.coordinator?.addAddLocationViewController()
                else { return }
                completion([initialViewController])
            }
        }
    }
    
    private func addMainScreenControllersForData(completion: @escaping ([UIViewController])->Void) {
        var initialMainScreenViewControllers = [MainScreenViewController]()
        for coordinates in self.data {
            guard
                let initialMainScreenViewController = self.coordinator?.addMainViewController(
                    with: coordinates
                )
            else { return }
            initialMainScreenViewControllers.append(initialMainScreenViewController)
        }
        completion(initialMainScreenViewControllers)
    }
}
