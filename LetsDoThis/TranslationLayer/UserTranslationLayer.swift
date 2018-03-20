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
    func translateUserJsonToUserDTO(fromUserJson userJson:JSON) throws -> UserDTO
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
    
    func translateUserJsonToUserDTO(fromUserJson userJson:JSON) throws -> UserDTO {
        guard let id = userJson["_id"].string else{
            throw userJson["_id"].error!
        }
        guard let email = userJson["email"].string  else{
            throw userJson["email"].error!
        }
        guard let firstname = userJson["firstname"].string else{
            throw userJson["firstname"].error!
        }
        guard let lastname = userJson["lastname"].string else{
            throw userJson["lastname"].error!
        }
        
        let userDTO = UserDTO(with: id, email: email, firstname: firstname, lastname: lastname)
        return userDTO
        
    }
}
