//
//  APIRouter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 11/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift

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
            return [K.APIParameterKey.username:email, K.APIParameterKey.password:password, K.APIParameterKey.grantType:"password"]
        }
    }
    
    fileprivate var headers:Headers? {
        var header:Headers = [String:String]()
        header[HTTPHeaderField.contentType.rawValue] = ContentType.json.rawValue
        switch self {
        case .login:
            guard let authorizationString = buildOAuthPasswordAuthorization() else {
                return nil
            }
            header[HTTPHeaderField.authentication.rawValue] = authorizationString
        }
        return header
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try K.LocalServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
//        HTTP Method
        urlRequest.httpMethod = method.rawValue
        
//        HTTP Headers
        if let headers = self.headers {
            for (key,value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
    
    func buildOAuthPasswordAuthorization() -> String? {
        let config = Config.shared
        guard let id = config.OAuth?.clientID else {
            return nil
        }
        guard let secret = config.OAuth?.clientSecret else {
            return nil
        }
        guard let data = "\(id):\(secret)".data(using: .utf8) else {
            return nil
        }
//        guard let token = String(data: data.sha256(), encoding: String.Encoding.utf8) else {
//            return nil
//        }
        let token = data.base64EncodedString()
        return "Basic \(token)"
    }
}
