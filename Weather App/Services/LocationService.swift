//
//  LocationService.swift
//  Weather App
//
//  Created by Yoji on 03.04.2024.
//

import Foundation
import CoreLocation

final class LocationService {
    lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        
        return manager
    }()
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
//            enableLocationFeatures()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
//            disableLocationFeatures()
            break
            
        case .notDetermined:        // Authorization not determined yet.
           manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
}
