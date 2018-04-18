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
import CoreData
@testable import LetsDoThis


class ApplicationManagerTests:QuickSpec {
    override func spec() {
        let container = Container()
        let dependeyRegistry = DependencyRegistry(container: container)
        let applicationManager = dependeyRegistry.container.resolve(ApplicationManger.self)!
        
        it("Test update sources") {
            
            waitUntil(timeout: 50, action: { (done) in
                _ = applicationManager.updateSources()
                    .subscribe({ (single) in
                        switch single {
                        case .success(let sources):
                            print("Elements Num: \(sources.count)")
                            
                            let managedObjectContext = dependeyRegistry.container.resolve(CoreDataContainer.self)!.persistentContainer.newBackgroundContext()
                            let fetchRequest:NSFetchRequest<SourceMO> = SourceMO.fetchRequest()
                            let sourceMOs = try? managedObjectContext.fetch(fetchRequest)
                            expect(sourceMOs!.count).to(equal(sources.count))
                        case .error(let error):
                            fail(error.localizedDescription)
                        }
                        done()
                    })
            })
            
        }
    }
}
