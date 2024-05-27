//
//  CoreDataService.swift
//  Weather App
//
//  Created by Yoji on 13.12.2023.
//

import Foundation
import CoreData

final class CoreDataService {
    lazy var persistentContaner: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                print("🔴 Core data error: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContaner.viewContext
        return context
    }()
}
