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
            defaults.removeObject(forKey: "accessToken")
            defaults.removeObject(forKey: "refreshToken")
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
                    let email = "test@test.com"
                    let password = "test"
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
        }
    }
}
