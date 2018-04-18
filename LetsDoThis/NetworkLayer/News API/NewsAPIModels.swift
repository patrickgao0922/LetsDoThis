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

struct Source:Codable {
    var id:String?
    var name:String?
    var description:String?
    var url: String?
    var category:String?
    var language: String?
    var country: String?
    
    func createOrFetchManagedObjectInCoreData(with managedObjectContext:NSManagedObjectContext) -> SourceMO? {
//        Fetching first
        let sourceFetch:NSFetchRequest<SourceMO> = SourceMO.fetchRequest()

        guard let id = self.id else {
            return nil
        }
        sourceFetch.predicate = NSPredicate(format: "id == %@", id)
        var sourceMo:SourceMO! = nil
        do {
            let sources = try managedObjectContext.fetch(sourceFetch)
            if sources.count != 0 {
                sourceMo = sources[0]
            }
            else {
                sourceMo = NSEntityDescription.insertNewObject(forEntityName: SourceMO.entityName, into: managedObjectContext) as! SourceMO
            }
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
        catch {
            return nil
        }
    }
}
