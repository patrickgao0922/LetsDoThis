//
//  UserModel.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 21/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import Swinject
import CoreData
@testable import LetsDoThis

class TestUserModelImplementation:QuickSpec {
    override func spec() {
        var userModel:UserModel?
        var disposeBag = DisposeBag()
        let container = Container()
        var utilities:TestUtilities?
        func setup() {
            let dependencyRegistry = DependencyRegistry(container: container)
            userModel = dependencyRegistry.container.resolve(UserModel.self)
            utilities = TestUtilities()
        }
        
        func cleanUp() {
            utilities?.cleanUpTestUserMoObject()
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: USERDEFAULTS_ACCESS_TOKEN_KEY)
            defaults.removeObject(forKey: USERDEFAULTS_REFRESH_TOKEN_KEY)
        }
        beforeSuite {
            setup()
        }
        afterSuite {
            cleanUp()
        }
        describe("User Model") {
            it("test authenticateUser:") {
                waitUntil(timeout: 5.0, action: { (done) in
                    let email = USER_EMAIL
                    let password = USER_PASSWORD
                    _ = userModel!.authenticateUser(with: email, password: password)
                        .subscribe({ (single) in
                            switch single {
                            case .success(let userDTO):
                                expect(userDTO.email).to(equal(email))
                                done()
                            case .error(let error):
                                fail(error.localizedDescription)
                            }
                        })
                })
            }
            
            it("test retrieveTokensFromUserDefaults:") {
                
                let defaults = UserDefaults.standard
                defaults.set("accessToken", forKey: USERDEFAULTS_ACCESS_TOKEN_KEY)
                defaults.set("refreshToken", forKey: USERDEFAULTS_REFRESH_TOKEN_KEY)
                
                var tokens = userModel!.retrieveTokensFromUserDefaults()
                //                    tokens = nil
                expect(tokens).toNot(beNil())
                
            }
        }
    }
}
