//
//  NewsAPIModels.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 15/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import CoreData

struct SourceResponse:Codable {
    var status:String
    var code:String?
    var message:String?
    var sources:[Source]?
}

struct NewsResponse:Codable {
    var status:String
    var code:String?
    var message:String?
    var totalResults:Int?
    var articles:[Article]?
}

struct Article:Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage:String?
    var publishedAt:String?
}



/// Source DTO
struct Source:Codable {
    var id:String?
    var name:String?
    var description:String?
    var url: String?
    var category:String?
    var language: String?
    var country: String?
    
    func createOrFetchManagedObjectInCoreData(with managedObjectContext:NSManagedObjectContext) -> SourceMO? {
//        Fetching or creating managed object
        if let sourceMo = fetchManagedObjectFromCoreData(managedObjectContext: managedObjectContext,createNewObject: true) {
            
//            Updating all the values
            sourceMo.id = id
            if let name = self.name {
                sourceMo.name = name
            }
            if let country = self.country {
                sourceMo.country = country
            }
            if let description = self.description {
                sourceMo.desc = description
            }
            if let language = self.language {
                sourceMo.language = language
            }
            if let url = self.url {
                sourceMo.url = url
            }
            if let category = self.category {
                sourceMo.category = category
            }
            return sourceMo
        }
        else {
            return nil
        }
    }
    
    func getIconPath() -> String? {
        guard let managedObjectContext = AppDelegate.coreDataContainer?.persistentContainer.newBackgroundContext() else {
            return nil
        }
        guard let sourceMo = fetchManagedObjectFromCoreData(managedObjectContext: managedObjectContext,createNewObject: false) else {
            return nil
        }
        guard let iconPath = sourceMo.iconPath else {
            return nil
        }
        return iconPath
    }
    
    fileprivate func fetchManagedObjectFromCoreData(managedObjectContext:NSManagedObjectContext, createNewObject: Bool) -> SourceMO?{
        let sourceFetch:NSFetchRequest<SourceMO> = SourceMO.fetchRequest()
        
        guard let predicate = buildFetchPredicate() else {
            return nil
        }
        
        sourceFetch.predicate = predicate
        
        var sourceMo:SourceMO! = nil
        do {
            let sources = try managedObjectContext.fetch(sourceFetch)
            if sources.count != 0 {
                sourceMo = sources[0]
            } else if createNewObject {
                sourceMo = NSEntityDescription.insertNewObject(forEntityName: SourceMO.entityName, into: managedObjectContext) as! SourceMO
            }
            return sourceMo
        }
        catch {
            return sourceMo
        }
    }
    
    fileprivate func buildFetchPredicate() -> NSPredicate? {
        if let id = self.id {
            return NSPredicate(format: "id == %@", id)
        } else if let url = self.url {
            return NSPredicate(format: "url = %@", url)
        }
        else {
            return nil
        }
    }
}
