//
//  ApplicationManagerTests.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 18/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Swinject
@testable import LetsDoThis


class ApplicationManagerTests:QuickSpec {
    override func spec() {
        let container = Container()
        let dependeyRegistry = DependencyRegistry(container: container)
        let applicationManager = dependeyRegistry.container.resolve(ApplicationManger.self)!
        
        it("Test update sources") {
            
            waitUntil(timeout: 50, action: { (done) in
                applicationManager.updateSources()
                    .subscribe({ (single) in
                        switch single {
                        case .success(let paths):
                            print("Elements Num: \(paths.count)")
                            print(paths[100])
                            expect(paths.count).notTo(equal(0))
                        case .error(let error):
                            fail(error.localizedDescription)
                        }
                        done()
                    })
            })
            
        }
    }
}
