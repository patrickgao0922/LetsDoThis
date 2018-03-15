//
//  OAuth.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 14/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class LoginManager {
    static let sharedInstance = LoginManager()
    
    /// Login and obtain accessToken and refreshToken using username and password
    ///
    /// - Parameters:
    ///   - username: Email
    ///   - password: Password
    /// - Returns: Single Observable with results of token dictionary
    func login(with username:String, password: String) -> Single<[String:String]>{
        return Single<[String:String]>.create(subscribe: { (single) -> Disposable in
            let headers = self.getOAuthHeaders()
            let parameters = [
                "grant_type":"password",
                "username":username,
                "password":password
            ]
//            Alamofire.request
            Alamofire.request("http://localhost:8080/token", method:.post, parameters: parameters,encoding: JSONEncoding.default,headers:headers)
                .validate(statusCode: 200..<300)
                .response {response in
                if let error = response.error {
                    return single(.error(error))
                }
                let json = JSON(response.data!)
                var result = [String:String]()
                if let accessToken = json["access_token"].string {
                    result["access_token"] = accessToken
                } else {
                    return single(.error(json["access_token"].error!))
                }
                if let refreshToken = json["refresh_token"].string {
                    result["refresh_token"] = refreshToken
                } else {
                    return single(.error(json["refresh_token"].error!))
                }
                
                single(.success(result))
            }
            return Disposables.create()
        })
    }
    
    /// get HTTP Headers for OAuth
    ///
    /// - Returns: HTTPHeaders
    fileprivate func getOAuthHeaders() -> HTTPHeaders {
        let headers:HTTPHeaders = [
            "Content-Type":"application/json",
            "Authorization":"Basic NWFhMzU0MjkwZGQyYzUwNTA3ZWNlODNlOmI2YjkwOGM0LWJiZTQtNDMyYi05Nzg5LTAxNGNiMjA3M2M4Yg=="
        ]
        return headers
    }
}
