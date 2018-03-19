//
//  Utilities.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 19/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import CoreData
import Swinject
@testable import LetsDoThis

/// Utility Class for providing support functions
class TestUtilities {
    var dependencyRegistry:DependencyRegistry?
    var container:Container?
    var managedObjectContext:NSManagedObjectContext?
    
    init() {
        container = Container()
        dependencyRegistry = DependencyRegistry(container:container!)
        let coreDataContainer = dependencyRegistry?.container.resolve(CoreDataContainer.self)
        managedObjectContext = coreDataContainer?.persistentContainer.newBackgroundContext()
    }
    
    func fetchTestUserMOObect() -> UserMO? {
        let predicate = NSPredicate(format: "email == %@", "test@gmail.com")
        let fetchRequest = CoreData.NSFetchRequest<NSFetchRequestResult>(entityName:"User")
        fetchRequest.predicate = predicate
        var userMOs:[UserMO]
        do {
            userMOs = try managedObjectContext?.fetch(fetchRequest) as! [UserMO]
        }
        catch {
            return nil
        }
        if userMOs.count > 0 {
            return userMOs[0]
        } else {
            return nil
        }
    }
    func cleanUpTestUserMoObject() {
        let userMO = fetchTestUserMOObect()
        
        if let userMO = userMO {
            print("Cleaning Up")
            managedObjectContext?.delete(userMO)
            
            do {
                try managedObjectContext?.save()
            }
            catch {
                print("There is error while saving managedObjectContext: \(error.localizedDescription)")
            }
        }
        
        
    }
    
}
