//
//  UserTranslationLayer.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 17/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import SwinjectStoryboard

internal protocol UserTranslationLayer {
    func translateUserJsonToUserModalAndSave(from jsonObject:JSON)
}

internal class UserTranslationLayerImplementation:UserTranslationLayer {
    var coreDataContainer:CoreDataContainer
    var dependencyRegistry: DependencyRegistry
    init() {
        dependencyRegistry = DependencyRegistry(container: SwinjectStoryboard.defaultContainer)
        if let coreDataContainer = dependencyRegistry.container.resolve(CoreDataContainer.self) {
            self.coreDataContainer = coreDataContainer
        }
        else {
            fatalError("Unable to load core data container")
        }
    }
    /// Translate user profile from http response to Core Data User modal and save into core data.
    ///
    /// - Parameter jsonObject: User JSON Object
    func translateUserJsonToUserModalAndSave(from jsonObject: JSON) {
        guard let id = jsonObject["_id"].string else {
            return
        }
        guard let email = jsonObject["email"].string else {
            return
        }
        guard let firstname = jsonObject["firstname"].string else {
            return
        }
        guard let lastname = jsonObject["lastname"].string else {
            return
        }
        let managedObjectContext = coreDataContainer.persistentContainer.newBackgroundContext()
        let userMO = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! UserMO
        
        userMO.id = id
        userMO.email = email
        userMO.firstname = firstname
        userMO.lastname = lastname
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save managed object context: \(error)")
        }
        
        return
        
    }
}
