//
//  ApplicationManger.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 17/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift

protocol ApplicationManger {
    func updateSources() -> Single<[String]>
}

class ApplicationMangerImplementation:ApplicationManger {
    var newsAPIClient:NewsAPIClient!
    
    init(with newsAPIClient:NewsAPIClient) {
        self.newsAPIClient = newsAPIClient
    }
    func updateSources() -> Single<[String]> {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        return newsAPIClient.getSources(inCountry: nil, onCategory: nil, inLanguage: nil)
                .observeOn(scheduler)
            .flatMap({ (sourceResponse) -> Single<[String]> in
                let sources = sourceResponse.sources
                
                var requestArray = [Observable<String>] ()
                
                if sources != nil {
                    for source in sources! {
                        if source.url != nil {
                            requestArray.append(self.newsAPIClient.obtainSourceFavicon(byURL: source.url!).asObservable())
                        }
                        
                    }
                }
                return Observable.zip(requestArray).asSingle()
            })
        
    }
}
