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
                _ = newsAPIClient.getTopHeadlines(for: .us, on: nil, of: nil)
                    .subscribe({ (single) in
                        switch single {
                        case .success(let response):
                            expect(response.totalResults!).to(equal(20))
                        case .error(let error):
                            fail(error.localizedDescription)
                        }
                        done()
                    })
            })
        }
        
        it("test obtain favicon:") {
            waitUntil(timeout: 10.0, action: { (done) in
                _ = newsAPIClient.obtainSourceFavicon(byURL: "https://cnn.com")
                    .subscribe({ (single) in
                        switch single {
                        case .success(let imagePath):
                            print(imagePath)
                            _ = succeed()
                        case .error(let error):
                            fail(error.localizedDescription)
                        }
                        done()
                    })
            })
        }
    }
}
