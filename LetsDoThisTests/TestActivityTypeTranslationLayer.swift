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
import SwiftyJSON
@testable import LetsDoThis

class ActivityTypeTranslationLayerImplementationTests:QuickSpec {
    override func spec() {
        var container = Container()
        var dependencyRegistry = DependencyRegistry(container: container)
        var Utilities = TestUtilities()
        var activityTypeTranslationLayer = dependencyRegistry.container.resolve(ActivityTypeTranslationLayer.self)
        describe("Test ActivityTypeTranslationLayerImplementation"){
            it("Test translateActivityTypeJsonToDTO") {
                let json:JSON = ["name":"Party",
                                 "icon":"icon-party",
                                 "background":"background-party"]
                var activityTypeDTO = activityTypeTranslationLayer?.translateActivityTypeJsonToDTO(fromJson: json)
                
                expect(activityTypeDTO).toNot(beNil())
            }
        }
    }
}
