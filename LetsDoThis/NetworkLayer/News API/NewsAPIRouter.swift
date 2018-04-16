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
    
    enum Country:String {
        case china = "cn"
        case usa = "us"
    }
    enum Category:String {
        case business = "business"
        case entertainment = "entertainment"
        case general = "general"
        case health = "health"
        case science = "science"
        case sports = "sports"
        case technology = "technology"
    }
    
    enum Language:String {
        case ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de, eg, fr, gb, gr, hk, hu, id, ie, il
        case int = "in"
        case it, jp, kr, lt, lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs, ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za
    }
    
    fileprivate var baseURL:String{
        return "https://newsapi.org/v2"
    }
    fileprivate var apiVersion:String {
        return "/v2"
        
    }
    
    case topHeadlines(country:Country?,category:Category?,page:Int?)
    case everything
    case sources
    
    
//    HTTP Componens
    /// HTTP Path
    fileprivate var path:String {
        switch self {
        case .topHeadlines(_,_,_):
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
    
    fileprivate var parameters:Parameters {
        var parameters = Parameters()
        switch self {
        case .topHeadlines(let country, let category, let page):
            
            if let country = country {
                parameters["country"] = country.rawValue
            }
            if let category = category {
                parameters["category"] = category.rawValue
            }
            if let page = page {
                parameters["page"] = page
            }
        case .everything:
            break
        case .sources:
            break
        }
        return parameters
    }
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
//        Setup headers
        for (key,value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
        
    }
    
    
}
