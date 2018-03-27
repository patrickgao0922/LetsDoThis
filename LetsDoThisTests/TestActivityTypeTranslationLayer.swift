//
//  TestActivityTypeDTO.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 27/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Swinject
@testable import LetsDoThis

class TestActivityTypeTranslationLayerImplementation:QuickSpec {
    override func spec() {
        var container = Container()
        var dependencyRegistry = DependencyRegistry(container: container)
        var Utilities = TestUtilities()
        var activityTypeTranslationLayer = dependencyRegistry.container.resolve(activityTypeTranslationLayer.self)
        describe("Test ActivityTypeTranslationLayerImplementation"){
            it("Test translateActivityTypeJsonToDTO") {
                
            }
        }
    }
}
