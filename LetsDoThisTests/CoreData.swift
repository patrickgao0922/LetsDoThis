//
//  CoreData.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 17/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import CoreData
import Swinject
import Quick
import Nimble
@testable import LetsDoThis

class TestCoreData:QuickSpec {
    override func spec() {
        var dependencyRegistry:DependencyRegistry?
        var container:Container?
        var managedObjectContext:NSManagedObjectContext?
        func setup() {
            container = Container()
            dependencyRegistry = DependencyRegistry(container:container!)
            let coreDataContainer = dependencyRegistry?.container.resolve(CoreDataContainer.self)
            managedObjectContext = coreDataContainer?.persistentContainer.newBackgroundContext()
        }
        
        func fetchUserMOObect() -> UserMO? {
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
        
        func cleanUp() {
            let userMO = fetchUserMOObect()
            
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
        beforeSuite {
            setup()
        }
        describe("User") {
            it("User Model save():") {
                guard managedObjectContext != nil else {
                    fail("Couldn't find managed object context.")
                    return
                }
                let userMO = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext!) as! UserMO
                userMO.id = "test"
                userMO.email = "test@gmail.com"
                userMO.firstname = "test"
                userMO.lastname = "test"
                do {
                    try managedObjectContext?.save()
                } catch {
                    fail(error.localizedDescription)
                }
                // Assert
                let fetchedUserMO = fetchUserMOObect()
                expect(fetchedUserMO).toNot(beNil())
            }
            
        }
        afterSuite {
            cleanUp()
        }
    }
}
