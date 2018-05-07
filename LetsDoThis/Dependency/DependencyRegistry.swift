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
        
        container.register(ApplicationManger.self) { r in
            ApplicationMangerImplementation(with: r.resolve(NewsAPIClient.self)!, using: r.resolve(CoreDataContainer.self)!)
        }
        
        container.register(NewsWebViewModel.self) { r, article in
            NewsWebViewModelImplementation(with: article)
        }
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
        }.inObjectScope(.transient)
        
        container.register(NewsTVCPresenter.self) { r,article in
            NewsTVCPresenterImplementation(with: article, newsAPIClient: r.resolve(NewsAPIClient.self)!, coreDataContainer: r.resolve(CoreDataContainer.self)!)
        }
        
        container.register(CategoryListViewModel.self) { (r) in
            CategoryListViewModelImplementation(wihtNewsClient: r.resolve(NewsAPIClient.self)!)
        }.inObjectScope(.container)
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
    
    typealias NewsTVCMaker = (UITableView,IndexPath,Article,NewsTVCPresenter?) -> NewsTVC
    func makeNewsTVC(forTableView tableView:UITableView, at indexPath:IndexPath, with article:Article, cellPresenter:NewsTVCPresenter? = nil) -> NewsTVC{
        let cellIdentifier = "NewsTVC"
        let cellRight = "NewsTVCRight"
        var presenter: NewsTVCPresenter? = cellPresenter
        if cellPresenter == nil {
            presenter = container.resolve(NewsTVCPresenter.self,argument:article)
        }
        
        var cell:NewsTVC!
        if indexPath.row%2 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsTVC
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellRight, for: indexPath) as! NewsTVC
        }
        cell.config(with: presenter!)
        return cell
    }
    
    typealias NewsCollectionViewCellMaker = (UICollectionView, IndexPath, Article, NewsTVCPresenter?) -> NewsCollectionViewCell
    func makeNewsCollectionViewCell(forCollectionView collectionView:UICollectionView, at indexPath:IndexPath, with article:Article,cellViewModel:NewsTVCPresenter? = nil) -> NewsCollectionViewCell {
        let cellIdentifier = "newsCollectionViewCell"
        var vm = cellViewModel
        if vm == nil {
            vm = container.resolve(NewsTVCPresenter.self,argument:article)!
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NewsCollectionViewCell
        cell.config(with: vm!)
        
        return cell
    }
}

