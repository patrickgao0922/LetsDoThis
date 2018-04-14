//
//  NewsAPIRouter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 14/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//
//  This is API router class for defining V2 News HTTP API: https://newsapi.org/

import Foundation
import Alamofire


enum NewsAPIRouter:URLRequestConvertible {
    fileprivate let baseURL = "https://newsapi.org"
    fileprivate let apiVersion = "/v2"
    case topHeadlines
    case everything
    case sources
    
    
//    HTTP Componens
    /// HTTP Path
    fileprivate var path:String {
        switch self {
        case .topHeadlines:
            return "/top-headlines"
        case .everything:
            return "/everything"
        case .sources:
            return "/sources"
        }
    }
    
    fileprivate var headers:HTTPHeaders {
        let apiKey = Config.shared.newsAPIKey
        return ["Authorization":"Bearer \(apiKey)"]
    }
    func asURLRequest() throws -> URLRequest {
        
        
//        Placeholder
        return URLRequest(url: URL(fileURLWithPath: ""))
    }
    
    
}
