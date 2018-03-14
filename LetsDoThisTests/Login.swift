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

class OAuthTests:QuickSpec {
    override func spec() {
        var loginManager:LoginManager!
        var disposeBag = DisposeBag()
        describe("OAuth Login Networking Layer") {
            func setup() {
                loginManager = LoginManager.sharedInstance
            }
            beforeEach {
                setup()
            }
            it("Login in with username(email) and password") {
                let username = "test@test.com"
                let password = "test"
                let loginSingle = loginManager.login(with: username, password: password)
                
                loginSingle.subscribe({ (single) in
                    switch single {
                    case .success(let result):
                        var accessToken = result["access_token"]
                        var refreshToken = result["refresh_token"]
                        expect(accessToken).toNot(beNil())
                        expect(refreshToken).toNot(beNil())
                    default:
                        break
                    }
                }).disposed(by: disposeBag)
                self.waitForExpectations(timeout: 4.0, handler: nil)
            }
        }
    }
}

