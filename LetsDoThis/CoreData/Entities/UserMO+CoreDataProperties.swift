//
//  UserMO+CoreDataProperties.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 17/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstname: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastname: String?

}
