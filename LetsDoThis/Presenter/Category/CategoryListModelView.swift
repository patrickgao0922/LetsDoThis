//
//  CategoryListModelView.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 1/5/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift

enum Category:String {
    case technology
    case business
}

protocol CategoryListModelView {
    var currentCategory:Variable<Category> { get set }
    var viewModel:NewsTVCPresenter! { get }
}

class CategoryListModelViewImplementation:CategoryListModelView {
    
    var currentCategory:Variable<Category>
    var viewModel:NewsTVCPresenter!
    var newsViewModels:[Category:NewsTVCPresenter]
    fileprivate var dependencyRegistry:DependencyRegistry
    fileprivate var disposeBag:DisposeBag
    
    init() {
        currentCategory = Variable<Category>(.technology)
        disposeBag = DisposeBag()
        
        newsViewModels = [Category:NewsTVCPresenter]()
        dependencyRegistry = AppDelegate.dependencyRegistry!
//        viewModel = dependencyRegistry.container.resolve(NewsTVCPresenter.self)!
        
        
    }
}

// MARK: - Setup Observables
extension CategoryListModelViewImplementation {
    func setupObservable() {
        _ = currentCategory.asObservable().subscribe(onNext: { [weak self] (category) in
            if let viewModel = self?.newsViewModels[category] {
                self?.viewModel = viewModel
            }
            else {
                self?.viewModel = self?.dependencyRegistry.container.resolve(NewsTVCPresenter.self)!
            }
        }).disposed(by: disposeBag)
    }
}
