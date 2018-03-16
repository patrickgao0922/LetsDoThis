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

class OAuthTests:QuickSpec {
    override func spec() {
        var loginManager:LoginManager!
        var disposeBag = DisposeBag()
        let container = Container()
        describe("OAuth Login Networking Layer") {
            func setup() {
                let dependencyRegistry = DependencyRegistry(container: container)
                loginManager = dependencyRegistry.container.resolve(LoginManager.self)
            }
            beforeEach {
                setup()
            }
            it("Login in with username(email) and password") {
                let username = "test@test.com"
                let password = "test"
                waitUntil(timeout: 5, action: { (done) in
                    loginManager.login(with: username, password: password).subscribe({ (single) in
                        switch single {
                        case .success(let result):
                            let accessToken = result["access_token"]
                            let refreshToken = result["refresh_token"]
                            expect(accessToken).toNot(beNil())
                            expect(refreshToken).toNot(beNil())
                            done()
                        case .error(let error):
                            fail(error.localizedDescription)
                            break
                        }
                        
                    }).disposed(by: disposeBag)
                })
                
//                self.waitForExpectations(timeout: 4.0, handler: nil)
            }
        }
    }
}

