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
    func retrieveUserProfile(with accessToken:String) -> Single<JSON>
    // for testing
    func updateUserTokensInUserDefaults(accessToken:String,refreshToken:String)
    func retrieveUserTokensInUserDefaults() -> (accessToken:String?,refreshToken:String?)
    func getToken(with username:String, password:String) -> Single<UserToken>
}

class LoginManagerImplementation:LoginManager {
    //    static let sharedInstance = LoginManagerImplementation()
    
    enum AuthenticationError:Error {
        case noResponseData
    }
    
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
    
    func getToken(with username:String, password:String) -> Single<UserToken> {
        return Single<UserToken>.create(subscribe: { single -> Disposable in
            Alamofire.request(APIRouter.login(email: username, passwrod: password))
                .validate(statusCode: 200..<300)
                .response(completionHandler: { (response) in
                    
                    // Handle errors
                    if let error = response.error {
                        single(.error(error))
                    }
                    if let data = response.data {

                        if let token = try? JSONDecoder().decode(UserToken.self, from: data)
                        {
                            
                            single(.success(token))
                        }
                        else {
                            single(.error(AuthenticationError.noResponseData))
                        }
                    }
                    else {
                        single(.error(AuthenticationError.noResponseData))
                    
                    }
                })
            return Disposables.create()
        })
    }
    
    /// Retrieve profile for server using access token
    ///
    /// - Parameter accessToken: access token string
    /// - Returns: Single Observabe with JSON result
    func retrieveUserProfile(with accessToken:String) -> Single<JSON>{
        return Single<JSON>.create(subscribe: { (single) -> Disposable in
            let headers:HTTPHeaders = self.getAuthenticationHeaders(accessToken: accessToken)
            Alamofire.request("http://localhost:8080/v1/users/profile", method:.get, headers:headers)
                .validate(statusCode: 200 ..< 300)
                .response(completionHandler: { (response) in
                    if let error = response.error {
                        return single(.error(error))
                        
                    }
                    guard let data = response.data else {
                        fatalError("Response data is nil.")
                    }
                    
                    
                    let json = JSON(data)
                    single(.success(json))
                })
            return Disposables.create()
        })
    }
    
    
    /// get HTTP Headers for OAuth
    ///
    /// - Returns: HTTPHeaders
    func getOAuthHeaders() -> HTTPHeaders {
        let headers:HTTPHeaders = [
            "Content-Type":"application/json",
            "Authorization":"Basic NWFhMzU0MjkwZGQyYzUwNTA3ZWNlODNlOmI2YjkwOGM0LWJiZTQtNDMyYi05Nzg5LTAxNGNiMjA3M2M4Yg=="
        ]
        return headers
    }
    
    /// Generate HTTP headers with access token
    ///
    /// - Parameter accessToken: Access Token
    /// - Returns: HTTP Headers
    fileprivate func getAuthenticationHeaders(accessToken:String) -> HTTPHeaders{
        let headers:HTTPHeaders = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(accessToken)"
        ]
        return headers
    }
    
    /// Retrieve access token and refresh token from user defaults
    ///
    /// - Returns: Tokens tuple (accessToken, RefreshToken)
    func retrieveUserTokensInUserDefaults() -> (accessToken:String?,refreshToken:String?) {
        let defaults = UserDefaults.standard
        let retrievedAccessToken = defaults.string(forKey: "accessToken")
        let retrievedRefreshToken = defaults.string(forKey: "refreshToken")
        return (retrievedAccessToken,retrievedRefreshToken)
    }
    
    /// Update user access token and refresh token in standard user defaults
    ///
    /// - Parameters:
    ///   - accessToken: Access token string retrieved from authentication server
    ///   - refreshToken: Refresh token string retrieved from authentication server
    func updateUserTokensInUserDefaults(accessToken:String,refreshToken:String){
        let defaults = UserDefaults.standard
        defaults.set(accessToken, forKey: "accessToken")
        defaults.set(refreshToken, forKey: "refreshToken")
    }
    
}

extension LoginManager {
    
}
