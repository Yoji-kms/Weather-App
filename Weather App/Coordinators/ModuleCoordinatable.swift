//
//  ModuleCoordinatable.swift
//  Weather App
//
//  Created by Yoji on 05.02.2024.
//

import Foundation

protocol ModuleCoordinatable: Coordinatable {
    var module: Module? { get }
    var moduleType: Module.ModuleType { get }
}
