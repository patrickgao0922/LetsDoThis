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
import Mockingjay

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

            it("getToken in with username(email) and password") {
//                Stubbing HTTP Request
                let body:[String:String] = [
                    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1YWE4N2E0NDNlNzcwMTIxZTQ0MGY2MmMiLCJjbGllbnRJZCI6IjVhYTM1NDI5MGRkMmM1MDUwN2VjZTgzZSIsImlhdCI6MTUyMzY3MDA0MCwiaXNzIjoicGF0cmlja2dhby5jb20uYXUifQ.M_goxEvFUQhF83VpluyHouV42_4wEF8Jg_TMCedMh3g",
                    "token_type": "bearer",
                    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YWE4N2E0NDNlNzcwMTIxZTQ0MGY2MmMiLCJlbWFpbCI6InRlc3RAdGVzdC5jb20iLCJwYXNzd29yZCI6IjlmODZkMDgxODg0YzdkNjU5YTJmZWFhMGM1NWFkMDE1YTNiZjRmMWIyYjBiODIyY2QxNWQ2YzE1YjBmMDBhMDgiLCJmaXJzdG5hbWUiOiJUZXN0IiwibGFzdG5hbWUiOiJUZXN0IiwiX192IjowLCJpYXQiOjE1MjM2NzAwNDAsImV4cCI6MTUyMzY3NzI0MCwiaXNzIjoicGF0cmlja2dhby5jb20uYXUifQ.bZqK6EHbvxEWoQ4F5Qr4Ywg6vPzIyKeB5evkwIqFR90"
                ]
                let status = 200
                let headers:[String:String] = [
                    "Content-Type":"application/json; charset=utf-8"
                ]
                
                let builder = json(body, status: status, headers: headers)
                self.stub(everything, builder)
//                Test
                let username = "test@test.com"
                let password = "test"
                waitUntil(timeout: 5, action: { (done) in
                    loginManager.getToken(with: username, password: password).subscribe({ (single) in
                        switch single {
                        case .success(let result):
                            let accessToken = result.accessToken
                            expect(accessToken).to(equal("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YWE4N2E0NDNlNzcwMTIxZTQ0MGY2MmMiLCJlbWFpbCI6InRlc3RAdGVzdC5jb20iLCJwYXNzd29yZCI6IjlmODZkMDgxODg0YzdkNjU5YTJmZWFhMGM1NWFkMDE1YTNiZjRmMWIyYjBiODIyY2QxNWQ2YzE1YjBmMDBhMDgiLCJmaXJzdG5hbWUiOiJUZXN0IiwibGFzdG5hbWUiOiJUZXN0IiwiX192IjowLCJpYXQiOjE1MjM2NzAwNDAsImV4cCI6MTUyMzY3NzI0MCwiaXNzIjoicGF0cmlja2dhby5jb20uYXUifQ.bZqK6EHbvxEWoQ4F5Qr4Ywg6vPzIyKeB5evkwIqFR90"))
                            print(accessToken)
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
                
//                Stubbing HTTP Request
                
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
//                Stubbing Profile HTTP Request
                let body:[String:String] = [
                    "_id": "5aa87a443e770121e440f62c",
                    "email": "test@test.com",
                    "firstname": "Test",
                    "lastname": "Test"
                ]
                let status = 200
                let headers:[String:String] = [
                    "Content-Type":"application/json; charset=utf-8",
                    "Connection":"keep-alive",
                    "Content-Length":"95",
                    "Date":"Sat, 14 Apr 2018 01:49:04 GMT",
                    "ETag":"W/\"5f-mVyIN+sSFmji2/dk1Pvf1lrpvqo\"",
                    "X-Powered-By":"Express"
                ]
                let builder = json(body, status: status, headers: headers)
                self.stub(everything, builder)
                
                let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YWE4N2E0NDNlNzcwMTIxZTQ0MGY2MmMiLCJlbWFpbCI6InRlc3RAdGVzdC5jb20iLCJwYXNzd29yZCI6IjlmODZkMDgxODg0YzdkNjU5YTJmZWFhMGM1NWFkMDE1YTNiZjRmMWIyYjBiODIyY2QxNWQ2YzE1YjBmMDBhMDgiLCJmaXJzdG5hbWUiOiJUZXN0IiwibGFzdG5hbWUiOiJUZXN0IiwiX192IjowLCJpYXQiOjE1MjE1OTQ0NTEsImlzcyI6InBhdHJpY2tnYW8uY29tLmF1In0.sBb7nDErZ2B6TR4K2Zc7CYNXolHFlfVTuDva1XzwT8E"
                waitUntil(timeout: 5.0, action: { (done) in
                    _ = loginManager.retrieveUserProfile(with: accessToken).subscribe({ (single) in
                        switch single {
                        case .success(let json):
                            guard let email = json["email"].string else {
                                fail("No email field")
                                return
                            }
                            expect(email).to(equal("test@test.com"))
                            done()
                        case .error(let error):
                            fail(error.localizedDescription)
                        }
                    })
                })
                
            }
        }
    }
}

