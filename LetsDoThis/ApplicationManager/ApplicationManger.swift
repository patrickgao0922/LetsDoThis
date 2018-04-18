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

typealias SourceFavicon = (id:Source,imagePath:String)

protocol ApplicationManger {
    func updateSources() -> Single<[SourceFavicon]>
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
            .flatMap({ (sourceResponse) -> Single<[Source]> in
                let sources = sourceResponse.sources
                
                
                let sourceMos = sources?.map({ (source) -> SourceMO? in
                    source.createOrFetchManagedObjectInCoreData(with: self.managedObjectContext)
                })
                
                
//                Setup favicon requests observables
                var requestArray = [Observable<SourceFavicon>] ()
                
                if let sourceMos = sourceMos, let sources = sources{
                    for index in 0..<sources.count {
                        let source = sources[index]
                        if source.url != nil {
                            requestArray.append(self.newsAPIClient.obtainSourceFavicon(byURL: source.url!)
                                .map({ (imagePath) -> SourceFavicon in
                                    if let sourceMo = sourceMos[index] {
                                        sourceMo.iconPath = imagePath
                                    }
                                    
                                    return (source,imagePath)
                                })
                                .asObservable())
                        }
                        
                    }
                }
                return Observable.zip(requestArray).asSingle().map({ (sourceFavicons) -> [SourceFavicon] in
                    try? self.managedObjectContext.save()
                    return sourceFavicons
                })
            })
        
    }
}
//extension ApplicationMangerImplementation {
//}
