//
//  CoordinatesService.swift
//  Weather App
//
//  Created by Yoji on 14.02.2024.
//

import Foundation
import CoreData

final class CoordinatesService {
    let coreDataService: CoreDataService
    private(set) var data: [CoordinatesEntity] = []
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.coreDataService.persistentContaner.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    init (coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        self.fetch() { coordinates in
            self.data = coordinates
        }
    }
    
    func fetch(completion: @escaping ([CoordinatesEntity]) -> Void) {
        let context = self.backgroundContext
        context.perform { [weak self] in
            guard let self else { return }
            let fetchRequest = CoordinatesEntity.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "isCurrentLocation", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                self.data = try context.fetch(fetchRequest).map { $0 }
                self.coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    completion(self.data)
                }
            } catch {
                print("🔻 Error: \(error.localizedDescription)")
                self.data = []
                completion(self.data)
            }
        }
    }
    
    func saveCoordinates(
        _ coordinates: Coordinates,
        completion: @escaping ([CoordinatesEntity])->Void
    ) {
        let context = self.backgroundContext
        context.perform { [weak self] in
            guard let self else { return }
            if !self.data.contains(where: { $0.toCoordinates() == coordinates }) {
                self.createCoordinates(context: context, coordinates: coordinates) { newDbCoordinates in
                    do {
                        if context.hasChanges {
                            try context.save()
                            self.coreDataService.mainContext.perform { [weak self] in
                                guard let self else { return }
                                if newDbCoordinates.isCurrentLocation {
                                    self.data.insert(newDbCoordinates, at: 0)
                                } else {
                                    self.data.append(newDbCoordinates)
                                }
                                completion(self.data)
                            }
                        }
                    } catch {
                        print("🔴 Coordinates create Core data error:\(error.localizedDescription)")
                    }
                }
            } else {
                self.coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    completion(self.data)
                }
            }
        }
    }
    
    func updateCoordinates(
        _ coordinates: Coordinates,
        newCoordinates: Coordinates,
        completion: @escaping ([CoordinatesEntity])->Void
    ) {
        let context = self.backgroundContext
        context.perform { [weak self] in
            guard let self else { return }
            
            if self.data.contains(
                where: { $0.lat == coordinates.lat && $0.lon == coordinates.lon && $0.isCurrentLocation }
            ) {
                guard 
                    let dbCoordinatesWithoutContext = self.getCoordinates(coordinates)
                    
                else { return }
                
                let dbCoordinates = context.object(with: dbCoordinatesWithoutContext.objectID) as? CoordinatesEntity
                
                dbCoordinates?.lat = newCoordinates.lat
                dbCoordinates?.lon = newCoordinates.lon
                
                do {
                    if context.hasChanges {
                        try context.save()
                        self.coreDataService.mainContext.perform { [weak self] in
                            guard let self else { return }
                            if dbCoordinates != nil {
                                completion(self.data)
                            } else {
                                return
                            }
                        }
                    }
                } catch {
                    print("🔴 Coordinates update Core data error:\(error.localizedDescription)")
                }
            } else {
                self.coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    completion(self.data)
                }
            }
        }
    }
    
    private func createCoordinates(
        context: NSManagedObjectContext, coordinates: Coordinates, completion: @escaping (CoordinatesEntity)->Void
    ) {
        if !self.data.contains(
            where: { $0.lat == coordinates.lat && $0.lon == coordinates.lon }
        ) {
            let dbCoordinates = CoordinatesEntity(context: context)
            dbCoordinates.lat = coordinates.lat
            dbCoordinates.lon = coordinates.lon
            dbCoordinates.isCurrentLocation = coordinates.isCurrentLocation
            completion(dbCoordinates)
        }
    }
    
    func getCoordinates(_ coordinates: Coordinates?) -> CoordinatesEntity? {
        guard let coordinates else { return nil }
        return self.data.filter {
            $0.lat == coordinates.lat && $0.lon == coordinates.lon
        }.first
    }
    
    func getCoordinatesBy(coordinates: Coordinates, completion: @escaping (CoordinatesEntity?)->Void) {
        self.backgroundContext.perform { [weak self] in
            guard let self else { return }
            if self.data.contains(where: { dbCoord in
                guard let dbCoordinates = dbCoord.toCoordinates() else {
                    return false
                }
                if coordinates.isCurrentLocation {
                    return dbCoordinates.isCurrentLocation
                }
                return dbCoordinates == coordinates
            }) {
                let fetchRequest = CoordinatesEntity.fetchRequest()
                let predicate = NSPredicate(
                    format: "lat == %f AND lon == %f",
                    coordinates.lat,
                    coordinates.lon
                )
                fetchRequest.predicate = predicate
                let savedCoordinates = try? self.backgroundContext.fetch(fetchRequest) as [CoordinatesEntity]
                self.coreDataService.mainContext.perform {
                    completion(savedCoordinates?.first)
                }
            }
        }
    }
}
