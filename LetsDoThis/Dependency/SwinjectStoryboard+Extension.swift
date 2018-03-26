//
//  SwinjectStoryboard+Extension.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 24/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc public class func setup() {
        if AppDelegate.dependencyRegistry == nil {
            AppDelegate.dependencyRegistry = DependencyRegistry(container: defaultContainer)
        }
        
        let dependencyRegistry = AppDelegate.dependencyRegistry!
        
        /// Main entry of the storyboard
        func main() {
//            dependencyRegistry.container.storyboardInitCompleted(SchedulerTableViewController.self) { (r, vc) in
//                let presenter = r.resolve(SchedulerTableViewControllerPresenter.self)!
//                
//                // where the fist table view controller are injected with presenter, schedulerCellMaker
//                vc.configure(with: presenter, schedulerCellMaker: dependencyRegistry.makeSchedulerCell(for:at:with:))
//            }
//            dependencyRegistry.container.storyboardInitCompleted(ZoneCollectionViewController.self) { (r, vc) in
//                let presenter = r.resolve(ZoneCollectionViewControllerPresenter.self)!
//                vc.config(with: presenter, cellMaker: dependencyRegistry.makeZoneCell(for:at:with:))
//            }
        }
        
        
        main()
    }
}