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
        
        container.register(UserTranslationLayer.self) { _ in
            UserTranslationLayerImplementation()
            }
            .inObjectScope(.container)
        container.register(ActivityTypeModel.self) { (r) in
            ActivityTypeModelImplementation()
        }.inObjectScope(.container)
        
        container.register(ActivityTypeTranslationLayer.self) { (r) in
            ActivityTypeTranslationLayerImplementation()
        }.inObjectScope(.container)
    }
    func registerPresenters() {
        container.register(UserModel.self) { (r) in
            UserModelImplementation(loginManager: r.resolve(LoginManager.self)!, translationLayer: r.resolve(UserTranslationLayer.self)!)
            }.inObjectScope(.container)
    }
    func registerViewControllers() {}
    
}
