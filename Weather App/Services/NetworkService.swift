//
//  NetworkService.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

//let apiKey = "3b1e37249d0c44a535766a620ce6fe9f"
final class NetworkService {
    static let shared = NetworkService()
    
    lazy var key = {
        let keychainSearchingQuery = [
            kSecClass as String: kSecClassKey,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(keychainSearchingQuery as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            let key: [UInt8] = [51, 98, 49, 101, 51, 55, 50, 52, 57, 100, 48, 99, 52, 52, 97, 53, 51, 53, 55, 54, 54, 97, 54, 50, 48, 99, 101, 54, 102, 101, 57, 102]
            let keyData = Data(key)
            let keychainItemQuery = [
                kSecValueData as String: keyData,
                kSecClass as String: kSecClassKey
            ]
            
            let status = SecItemAdd(keychainItemQuery as CFDictionary, nil)
            return self.decode(array: key)
        }
        
        guard let keyData = item as? Data else {
            return nil
        }
        
        let key: [UInt8] = Array(keyData)
        return "&appid=\(self.decode(array: key) ?? "")"
    }()
    
    let forecast = "https://api.openweathermap.org/data/2.5/forecast?lat=59.8944&lon=30.2642&units=metric"
    let currentWeather = "https://api.openweathermap.org/data/2.5/weather?lat=59.8944&lon=30.2642&units=metric"
    
    private func encode(key: String) {
        var array:[UInt8] = []
        key.data(using: .utf8)?.forEach { byte in
            array.append(byte)
        }
        print(array)
    }
    
    private func decode(array: [UInt8]) -> String? {
        return String(data: Data(array), encoding: .utf8)
    }
}
