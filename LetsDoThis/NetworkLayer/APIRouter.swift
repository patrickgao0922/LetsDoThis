//
//  APIRouter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 11/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    typealias Headers = [String:String]
    
    case login(email:String,passwrod:String)
    
    private var method:HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    fileprivate var path:String {
        switch self {
        case .login:
            return "/token"
        }
    }
    
    fileprivate var parameters:Parameters? {
        switch self {
        case .login(let email, let password):
            return [K.APIParameterKey.email:email, K.APIParameterKey.password:password]
        }
    }
    
    fileprivate var headers:Headers? {
        var header:Headers?
        switch self {
        case .login:
            return [HTTPHeaderField.authentication.rawValue:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try K.LocalServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
//        HTTP Method
        urlRequest.httpMethod = method.rawValue
        
//        HTTP Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        
        
    }
    
    func buildOAuthPasswordAuthorization() -> String? {
        return "Basic"
    }
}
