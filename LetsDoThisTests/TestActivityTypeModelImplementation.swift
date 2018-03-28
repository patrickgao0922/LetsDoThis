//
//  TestActivityTypeModelImplementation.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 27/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift
import Quick
import Nimble
import Swinject
@testable import LetsDoThis

class TestActivityTypeModelImplementation:QuickSpec{
    override func spec() {
        var disposeBag:DisposeBag = DisposeBag()
        var container:Container = Container()
        var utilities:TestUtilities = TestUtilities()
        var dependencyRegistry:DependencyRegistry = DependencyRegistry(container: container)
        var activityTypeModel = dependencyRegistry.container.resolve(ActivityTypeModel.self)
        func setUp() {
            
        }
        describe("TestActivityModel") {
            it("Test ") {
                
                waitUntil(timeout: 5, action: { (done) in
                    _ = activityTypeModel?.loadActivityType().subscribe({ (single) in
                        switch single {
                        case .success(let activityDTOs):
                            expect(activityDTOs[0].name).to(equal("Party"))
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
