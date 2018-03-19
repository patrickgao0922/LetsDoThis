//
//  DependencyRegistry.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 15/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Swinject

class DependencyRegistry {
    var container:Container
    
    init(container: Container) {
        Container.loggingFunction = nil
        self.container = container
        registerDependencies()
        registerPresenters()
        registerViewControllers()
    }
    
    func registerDependencies() {
        container.register(CoreDataContainer.self) { (r) in
            CoreDataContainerImplementation(completionClosure: {
            })
        }.inObjectScope(.container)

        container.register(LoginManager.self) { _ in
            LoginManagerImplementation()
        }
        .inObjectScope(.container)
    }
    func registerPresenters() {
        container.register(AuthenticationVCP.self) { (r) in
            AuthenticationVCPImplementation(loginManager: self.container.resolve(LoginManager.self)!)
        }
    }
    func registerViewControllers() {}
    
}
