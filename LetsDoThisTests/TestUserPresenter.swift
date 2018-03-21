//
//  TestUserPresenter.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 22/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import Swinject
@testable import LetsDoThis

class TestUserVCPresenterImplementation: QuickSpec {
    override func spec() {
        var disposeBag:DisposeBag = DisposeBag()
        var container:Container = Container()
        var utilities:TestUtilities = TestUtilities()
        var dependencyRegistry:DependencyRegistry = DependencyRegistry(container: container)
        describe("Test UserVCPPresenterImplementation") {
            func setUp() {
            }
            
        }
    }
}
