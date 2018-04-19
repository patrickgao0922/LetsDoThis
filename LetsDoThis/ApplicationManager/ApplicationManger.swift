//
//  ApplicationManger.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 17/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

//typealias SourceFavicon = (id:Source,imagePath:String)

protocol ApplicationManger {
    func updateSources() -> Single<[Source]>
}

class ApplicationMangerImplementation:ApplicationManger {
    fileprivate var newsAPIClient:NewsAPIClient!
    fileprivate var coreDataContainer:CoreDataContainer
    fileprivate var managedObjectContext:NSManagedObjectContext
    init(with newsAPIClient:NewsAPIClient, using coreDataContainer:CoreDataContainer) {
        self.newsAPIClient = newsAPIClient
        self.coreDataContainer = coreDataContainer
        self.managedObjectContext = coreDataContainer.persistentContainer.newBackgroundContext()
    }
    
    
    func updateSources() -> Single<[Source]> {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        return newsAPIClient.getSources(inCountry: nil, onCategory: nil, inLanguage: nil)
                .observeOn(scheduler)
            .map({ (sourceResponse) in
                guard let sources = sourceResponse.sources else {
                    return []
                }
                _ = sources.map({ (source) -> SourceMO? in
                    source.createOrFetchManagedObjectInCoreData(with: self.managedObjectContext)
                })
                
                return sources

            })
        
    }
}
//extension ApplicationMangerImplementation {
//}
