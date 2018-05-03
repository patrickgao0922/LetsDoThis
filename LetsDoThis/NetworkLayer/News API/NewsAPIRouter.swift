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
        case ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de, eg, fr, gb, gr, hk, hu, id, ie, il
        case inu = "in"
        case it, jp, kr, lt, lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs, ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za
    }
    enum Category:String {
        case business
        case entertainment
        case general
        case health
        case science
        case sports
        case technology
    }
    
    enum Language:String {
        case ar, de, en, es, fr, he, it, nl, no, pt, ru, se, ud, zh
    }
    
    fileprivate var baseURL:String{
        return "https://newsapi.org/v2"
    }
    fileprivate var apiVersion:String {
        return "/v2"
        
    }
    
    case topHeadlines(country:Country?,category:Category?,page:Int?)
    case everything(q: String, language:Language?,page:Int?, from:Date?, to:Date?)
    case sources(country:Country?,category:Category?,language:Language?)
    
    
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
        case .everything(let q, let language,let page,let from, let to):
            parameters[NewsAPIHTTPParameterKey.q.rawValue] = q
            if let language = language {
                parameters[NewsAPIHTTPParameterKey.language.rawValue] = language.rawValue
            }
            if let page = page {
                parameters[NewsAPIHTTPParameterKey.page.rawValue] = page
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let from = from {
                parameters[NewsAPIHTTPParameterKey.from.rawValue] = dateFormatter.string(from: from)
            }
            if let to = to {
                parameters[NewsAPIHTTPParameterKey.to.rawValue] = dateFormatter.string(from: to)
            }
            
        case .sources(let country, let category, let language):
            if let country = country {
                parameters[NewsAPIHTTPParameterKey.country.rawValue] = country.rawValue
            }
            if let category = category {
                parameters[NewsAPIHTTPParameterKey.category.rawValue] = category.rawValue
            }
            if let language = language {
                parameters[NewsAPIHTTPParameterKey.language.rawValue] = language.rawValue
            }
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

enum NewsAPIHTTPParameterKey:String {
    case country = "country"
    case category = "category"
    case language = "language"
    case page = "page"
    case pageSize = "pageSize"
    case from = "from"
    case to = "to"
    case q = "q"
}
