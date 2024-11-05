//
//  NetworkService.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    enum Label: String {
        case weather = "weather"
    }
    
    lazy var weatherKey: String? = {
        guard let key = self.getKeyFromKeychain(label: .weather) else { return nil }
        return "&appid=\(self.decode(array: key) ?? "")"
    }()
    
    enum Request {
        case forecast(Coordinates)
        case currentWeather(Coordinates)
        case geo(String)
    }
    
    func getUrl(requestType request: Request) -> String {
        switch request {
        case .forecast(let coordinates):
            return "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.lat)&lon=\(coordinates.lon)&units=metric"
        case .currentWeather(let coordinates):
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.lat)&lon=\(coordinates.lon)&units=metric"
        case .geo(let city):
            return "https://nominatim.openstreetmap.org/search?q=\(city)&format=json\(city)&format=json&limit=1"
        }
    }
    
    private func encode(key: String) {
        var array:[UInt8] = []
        key.data(using: .utf8)?.forEach { byte in
            array.append(byte)
        }
        print(array)
    }
    
    private func decode(array: [UInt8]?) -> String? {
        guard let array else { return nil }
        return String(data: Data(array), encoding: .utf8)
    }
    
    private func addKeyToKeychain(key: [UInt8], label: String) -> [UInt8] {
        let keyData = Data(key)
        let keychainItemQuery: [String: Any] = [
            kSecValueData as String: keyData,
            kSecAttrLabel as String: label,
            kSecClass as String: kSecClassKey
        ]
        
        _ = SecItemAdd(keychainItemQuery as CFDictionary, nil)
        return key
    }
    
    private func getKeyFromKeychain(label: Label) -> [UInt8]? {
        let keychainSearchingQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrLabel as String: label.rawValue,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(keychainSearchingQuery as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            var key: [UInt8]
            switch label {
            case .weather:
                key = [51, 98, 49, 101, 51, 55, 50, 52, 57, 100, 48, 99, 52, 52, 97, 53, 51, 53, 55, 54, 54, 97, 54, 50, 48, 99, 101, 54, 102, 101, 57, 102]
            }
            return self.addKeyToKeychain(key: key, label: label.rawValue)
        }
        
        guard let keyData = item as? Data else {
            return nil
        }
        
        let key: [UInt8] = Array(keyData)
        return key
    }
}
