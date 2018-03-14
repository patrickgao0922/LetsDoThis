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
            
            return Disposables.create()
        })
    }
}
