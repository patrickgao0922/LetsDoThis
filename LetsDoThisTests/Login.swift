//
//  OAuth.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 14/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Nimble
import Quick
@testable import LetsDoThis
import RxSwift
import Swinject

class TestLoginManagerImplementation:QuickSpec {
    override func spec() {
        var loginManager:LoginManager!
        var disposeBag = DisposeBag()
        let container = Container()
        describe("OAuth Login Networking Layer") {
            func setup() {
                let dependencyRegistry = DependencyRegistry(container: container)
                loginManager = dependencyRegistry.container.resolve(LoginManager.self)
            }
            
            func cleanUp() {
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "accessToken")
                defaults.removeObject(forKey: "refreshToken")
            }
            beforeSuite {
                setup()
            }
            afterSuite {
                cleanUp()
            }
            it("Login in with username(email) and password") {
                let username = "test@test.com"
                let password = "test"
                waitUntil(timeout: 5, action: { (done) in
                    loginManager.login(with: username, password: password).subscribe({ (single) in
                        switch single {
                        case .success(let result):
                            let accessToken = result["accessToken"]
                            let refreshToken = result["refreshToken"]
                            expect(accessToken).toNot(beNil())
                            expect(refreshToken).toNot(beNil())
                            done()
                        case .error(let error):
                            fail(error.localizedDescription)
                            break
                        }
                        
                    }).disposed(by: disposeBag)
                })
            }
            
            it("Test saving access token and refresh token into user defaults") {
                let accessToken = "test access token"
                let refreshToken = "Test refresh token"
                loginManager.updateUserTokensInUserDefaults(accessToken: accessToken,refreshToken: refreshToken)
                let defaults = UserDefaults.standard
                let retrievedAccessToken = defaults.string(forKey: "accessToken")
                let retrievedRefreshToken = defaults.string(forKey: "refreshToken")
                
                expect(retrievedAccessToken).to(equal(accessToken))
                expect(retrievedRefreshToken).to(equal(refreshToken))
                
            }
            
            it("Test retrieving user tokens from UserDefaults") {
                let accessToken = "Test access token"
                let refreshToken = "Test refresh token"
                let defaults = UserDefaults.standard
                defaults.set(accessToken, forKey: "accessToken")
                defaults.set(refreshToken, forKey: "refreshToken")
                
                let tokens = loginManager.retrieveUserTokensInUserDefaults()
                expect(tokens.accessToken).to(equal(accessToken))
                expect(tokens.refreshToken).to(equal(refreshToken))
            }
            
            it("Retrieve User Profile") {
                
            }
        }
    }
}

