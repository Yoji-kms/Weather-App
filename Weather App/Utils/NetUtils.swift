//
//  NetUtils.swift
//  Weather App
//
//  Created by Yoji on 24.10.2023.
//

import Foundation

extension String {
    func handleAsDecodable <T: Decodable>() async -> T? {
        do {
            guard let url = URL(string: self) else {
                return nil
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            print("♦️\(error)")
            return nil
        }
    }
}
