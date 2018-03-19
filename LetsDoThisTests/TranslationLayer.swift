//
//  TranslationLayer.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 17/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import CoreData
import Swinject
import SwiftyJSON
import Quick
import Nimble
@testable import LetsDoThis

class TestTranslationlayer:QuickSpec {
    override func spec() {
        describe("Translation Layer Tests") {
            describe("User Translation Layer") {
                var dependencyRegistry:DependencyRegistry?
                var userTranslationLayer:UserTranslationLayer?
                var dependencyContainer:Container?
                var utilities:TestUtilities?
                
                func setup() {
                    dependencyContainer = Container()
                    dependencyRegistry = DependencyRegistry(container: dependencyContainer!)
                    userTranslationLayer = dependencyRegistry?.container.resolve(UserTranslationLayer.self)
                    utilities = TestUtilities()
                }
                func cleanUp() {
                    utilities?.cleanUpTestUserMoObject()
                }
                beforeSuite {
                    setup()
                }
                afterSuite {
                    cleanUp()
                }
                
                it("Translate UserJson To UserMO And Save:") {
                    let userJson:JSON = ["_id":"test","email":"test@gmail.com","firstname":"firstname","lastname":"lastname"]
                    userTranslationLayer?.translateUserJsonToUserModalAndSave(from: userJson)
                    let userMO:UserMO? = utilities?.fetchTestUserMOObect()
                    expect(userMO).toNot(beNil())
                    expect(userMO!.email).to(equal("test@gmail.com"))
                }
            }
        }
    }
}

