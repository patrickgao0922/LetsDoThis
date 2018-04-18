//
//  SourceMO+CoreDataProperties.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 18/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//
//

import Foundation
import CoreData


extension SourceMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourceMO> {
        return NSFetchRequest<SourceMO>(entityName: "Source")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var url: String?
    @NSManaged public var category: String?
    @NSManaged public var country: String?
    @NSManaged public var iconPath: String?
    @NSManaged public var language: String?

}
