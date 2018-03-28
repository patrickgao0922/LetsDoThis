//
//  ActivityTypeVCPresenterImplementationTests.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 28/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Swinject
import RxSwift
@testable import LetsDoThis

class ActivityTypeVCPresenterImplementationTests:QuickSpec {
    override func spec() {
        describe("Test loadActivityTypes") {
            let container = Container()
            let dependencyRegistry = DependencyRegistry(container: container)
            let activityTypeVCPresenter = dependencyRegistry.container.resolve(ActivityTypeVCPresenter.self)!
            let disposeableBag = DisposeBag()
            it("Test loadActivityTypes:"){
                waitUntil(timeout: 5, action: { (done) in
                    _ = activityTypeVCPresenter.loadActivityTypes().subscribe({ (single) in
                        switch single {
                        case .success(_):
                            _ = activityTypeVCPresenter.activityTypes.asObservable().subscribe(onNext: { (values) in
                                expect(values.count).to(equal(2))
                                done()
                            })
                        case .error(let error):
                            fail(error.localizedDescription)
                            done()
                        }
                    })
                })
                
                
            }
        }
    }
}
