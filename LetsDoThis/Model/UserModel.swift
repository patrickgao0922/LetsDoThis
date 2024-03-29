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
    func authenticateUser(with email:String, password: String) -> Single<UserDTO>
    func retrieveUserProfile() -> Single<UserDTO>
    func retrieveTokensFromUserDefaults() -> (accessToken:String, refreshToken:String)?
}

class UserModelImplementation:UserModel {
    var loginManager:LoginManager?
    var translationLayer:UserTranslationLayer?
    
    init(loginManager:LoginManager, translationLayer:UserTranslationLayer) {
        self.loginManager = loginManager
        self.translationLayer = translationLayer
    }
    
    enum AuthError:Error {
        case noLoginManager
        case translationError
    }
    /// Authenticate user from server using email and password
    ///
    /// - Parameters:
    ///   - email: user email address
    ///   - password: user password
    func authenticateUser(with email:String, password: String) -> Single<UserDTO> {
        
        guard self.loginManager != nil else {
            return Single<UserDTO>.error(AuthError.noLoginManager)
        }
        return loginManager!.login(with: email, password: password)
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
            }).flatMap { (userJson) -> Single<UserDTO> in
                self.translationLayer?.translateUserJsonToUserModalAndSave(from: userJson)
                do {
                    let userDOT = try self.translationLayer!.translateUserJsonToUserDTO(fromUserJson: userJson)
                    return Single<UserDTO>.just(userDOT)
                }
                catch {
                    throw error
                }
        }
        
    }
    
    func retrieveTokensFromUserDefaults() -> (accessToken:String, refreshToken:String)? {
        guard self.loginManager != nil else {
            return nil
        }
        let tokens = loginManager!.retrieveUserTokensInUserDefaults()
        guard let accessToken = tokens.accessToken else {
            return nil
        }
        guard let refreshToken = tokens.refreshToken else {
            return nil
        }
        
        return (accessToken:accessToken,refreshToken:refreshToken)
    }
    func retrieveUserProfile() -> Single<UserDTO> {
        guard self.loginManager != nil else {
            return Single<UserDTO>.error(AuthError.noLoginManager)
        }
        let tokens = loginManager!.retrieveUserTokensInUserDefaults()
        let accessToken = tokens.accessToken!
        
        return loginManager!.retrieveUserProfile(with: accessToken)
            .map({ (json) -> UserDTO in
                do {
                    let userDTO = try self.translationLayer!.translateUserJsonToUserDTO(fromUserJson: json)
                    return userDTO
                }
                catch {
                    throw error
                }
                
            })
    }
}
