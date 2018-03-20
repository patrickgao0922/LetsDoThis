//
//  AuthenticationVCP.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 15/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol UserModel {
    var user:Variable<UserDTO>? {get set}
}

class UserModelImplementation:UserModel {
    var user:Variable<UserDTO>?
    var loginManager:LoginManager?
    var translationLayer:UserTranslationLayer?
    
    init(loginManager:LoginManager, translationLayer:UserTranslationLayer) {
        self.loginManager = loginManager
        self.translationLayer = translationLayer
    }
    
    /// Authenticate user from server using email and password
    ///
    /// - Parameters:
    ///   - email: user email address
    ///   - password: user password
    func authenticateUser(with email:String, password: String) {
        guard self.loginManager != nil else {
            return
        }
        loginManager!.login(with: email, password: password)
            .flatMap({ (result:JSON) -> Single<JSON> in
                
                // Save Token in UserDefaults
                guard let accessToken = result["access_token"].string else {
                    throw result["access_token"].error!
                }
                guard let refreshToken = result["refresh_token"].string else {
                    throw result["refresh_token"].error!
                }
                // Save tokens into  User Default
                self.loginManager!.updateUserTokensInUserDefaults(accessToken: accessToken, refreshToken: refreshToken)
                
                // Retrieve user profile from server
                return self.loginManager!.retrieveUserProfile(with: accessToken)
            }).flatMap { (JSON) -> PrimitiveSequence<SingleTrait, UserDTO> in
                
        }
        
        }
        //            .subscribe({ (single) in
        //                switch single {
        //                case .success(let result):
        //
        //                    guard self.loginManager != nil else {
        //                        return
        //                    }
        //                    // Save Token in UserDefaults
        //                    guard let accessToken = result["access_token"].string else {
        //                        return
        //                    }
        //                    guard let refreshToken = result["refresh_token"].string else {
        //                        return
        //                    }
        //                    // Save tokens into  User Default
        //                    self.loginManager!.updateUserTokensInUserDefaults(accessToken: accessToken, refreshToken: refreshToken)
        //
        //                    // Retrieve user profile from server
        ////                    _ = self.loginManager!.retrieveUserProfile(with: accessToken)
        ////                        .subscribe({ (single) in
        ////                            switch single {
        ////
        ////                            }
        ////                        })
        ////                    guard let user = self.translationLayer?.translateUserJsonToUserModalAndSave(from: userJson) else {
        ////                        return
        ////                    }
        //                    //
        //
        //                case .error(let error): print(error)
        //                }
        //            })
//    }
}
