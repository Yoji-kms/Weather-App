//
//  Sys.swift
//  Weather App
//
//  Created by Yoji on 25.10.2023.
//

import Foundation

struct SysResponse: Decodable {
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
    let pod: String?
}
