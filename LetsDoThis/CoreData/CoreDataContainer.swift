//
//  CoreDataController.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 16/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import CoreData
protocol CoreDataContainer {
    var persistentContainer:NSPersistentContainer { get set }
}
class CoreDataContainerImplementation:NSObject, CoreDataContainer {
    var persistentContainer:NSPersistentContainer
    init (completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "LetsDoThis")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
}
