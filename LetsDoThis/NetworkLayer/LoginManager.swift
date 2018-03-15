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

protocol LoginManager {
    func login(with username:String, password: String) -> Single<JSON>
}

class LoginManagerImplementation:LoginManager {
//    static let sharedInstance = LoginManagerImplementation()
    
    /// Login and obtain accessToken and refreshToken using username and password
    ///
    /// - Parameters:
    ///   - username: Email
    ///   - password: Password
    /// - Returns: Single Observable with results of token dictionary
    func login(with username:String, password: String) -> Single<JSON>{
        return Single<JSON>.create(subscribe: { (single) -> Disposable in
            let headers = self.getOAuthHeaders()
            let parameters = [
                "grant_type":"password",
                "username":username,
                "password":password
            ]
            Alamofire.request("http://localhost:8080/token", method:.post, parameters: parameters,encoding: JSONEncoding.default,headers:headers)
                .validate(statusCode: 200..<300)
                .response {response in
                if let error = response.error {
                    return single(.error(error))
                }
                let json = JSON(response.data!)
                guard let _ = json["access_token"].string else {
                    return single(.error(json["access_token"].error!))
                }
                guard let _ = json["refresh_token"].string  else {
                    return single(.error(json["refresh_token"].error!))
                }
                
                single(.success(json))
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
