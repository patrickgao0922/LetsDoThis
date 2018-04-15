//
//  NewsAPIClient.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 15/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol NewsAPIClient {
    func getTopHeadlines(for country:NewsAPIRouter.Country?, on category:NewsAPIRouter.Category?, of page:Int?) -> Single<NewsResponse>
}
enum HTTPError:Error {
    case noResponseData
    case responseParsingError
}
class NewsAPIClientImplementation:NewsAPIClient {
    func getTopHeadlines(for country:NewsAPIRouter.Country?, on category:NewsAPIRouter.Category?, of page:Int?) -> Single<NewsResponse> {
        return Single<NewsResponse>.create(subscribe: { (single) -> Disposable in
            
//            Alamofire Request
            request(NewsAPIRouter.topHeadlines(country: country, category: category, page: page))
                .response(completionHandler: { (response) in
                    if let error = response.error {
                        single(.error(error))
                    }
                    guard let data = response.data else {
                        return single(.error(HTTPError.noResponseData))
                    }
                    
                    do {
                        let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                            single(.success(newsResponse))
                    }
                    catch {
                        single(.error(error))
                    }
                    
                })
            return Disposables.create()
        })
    }
}
