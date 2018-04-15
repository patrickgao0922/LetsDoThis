//
//  NewsAPIClientTests.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 15/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Swinject

@testable import LetsDoThis

class NewsAPIClientTests:QuickSpec {
    override func spec() {
        let container: Container = Container()
        let dependencyRegistry: DependencyRegistry = DependencyRegistry(container: container)
        let newsAPIClient = dependencyRegistry.container.resolve(NewsAPIClient.self)!
        it("test get top headlines") {
            waitUntil(timeout: 5.0, action: { (done) in
                _ = newsAPIClient.getTopHeadlines(for: .usa, on: nil, of: nil)
                    .subscribe({ (single) in
                        switch single {
                        case .success(let response):
                            expect(response.totalResults!).to(equal(19))
                        case .error(let error):
                            fail(error.localizedDescription)
                        }
                        done()
                    })
            })
        }
    }
}
