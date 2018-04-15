//
//  DependencyRegistry.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 15/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import SwinjectStoryboard
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
            ActivityTypeModelImplementation(withTranslationLayer: r.resolve(ActivityTypeTranslationLayer.self)!)
        }.inObjectScope(.container)
        
        container.register(ActivityTypeTranslationLayer.self) { (r) in
            ActivityTypeTranslationLayerImplementation()
        }.inObjectScope(.container)
        
        container.register(NewsAPIClient.self) { (r) in
            NewsAPIClientImplementation()
        }.inObjectScope(.container)
    }
    func registerPresenters() {
        container.register(UserModel.self) { (r) in
            UserModelImplementation(loginManager: r.resolve(LoginManager.self)!, translationLayer: r.resolve(UserTranslationLayer.self)!)
            }.inObjectScope(.container)
        container.register(ActivityTypeVCPresenter.self) { (r) in
            ActivityTypeVCPresenterImplementation(with: r.resolve(ActivityTypeModel.self)!)
            }.inObjectScope(.container)
        
        container.register(TopHeadlineVCPresenter.self) { (r) in
            TopHeadlineVCPresenterImplementation(with: r.resolve(NewsAPIClient.self)!)
        }
    }
    func registerViewControllers() {
    }
}

// MARK: - Cell Makers
extension DependencyRegistry {
    typealias ActivityTypeCVCellMaker = (UICollectionView, IndexPath, ActivityTypeDTO) -> UICollectionViewCell
    func makeActivityTypeCollectionViewCell(forCollectionView collectionView:UICollectionView,at indexPath:IndexPath, for activityTypeDTO:ActivityTypeDTO) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityTypeCVCell", for: indexPath) as! ActivityTypeCVCell
        cell.activityNameLabel.text = activityTypeDTO.name
        cell.activityIconImageView.image = UIImage(named: activityTypeDTO.icon)
        cell.backgroundImageView.image = UIImage(named: activityTypeDTO.background)
        return cell
    }
}
