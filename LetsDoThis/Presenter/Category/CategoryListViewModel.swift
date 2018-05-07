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

protocol CategoryListViewModel {
    var currentCategory:Variable<Category> { get set }
    var cellViewModels:[NewsTVCPresenter] { get }
    var articles:Variable<[Article]>! {get}
    func addViewModel(viewModel:NewsTVCPresenter)
}

class CategoryListViewModelImplementation:CategoryListViewModel {
    
    var currentCategory:Variable<Category>
    var articles:Variable<[Article]>!
    var cellViewModels:[NewsTVCPresenter]
    var newsCellViewModels:[Category:[NewsTVCPresenter]]
    var page = 0
    var from:Date? = nil
    var to :Date? = nil
    
    fileprivate var newsAPIClient:NewsAPIClient!
    fileprivate var dependencyRegistry:DependencyRegistry
    fileprivate var disposeBag:DisposeBag
    
    init(wihtNewsClient newsAPIClient:NewsAPIClient) {
        currentCategory = Variable<Category>(.technology)
        disposeBag = DisposeBag()
        articles = Variable<[Article]>([])
        self.newsAPIClient = newsAPIClient
        newsCellViewModels = [Category:[NewsTVCPresenter]]()
        dependencyRegistry = AppDelegate.dependencyRegistry!
        cellViewModels = [NewsTVCPresenter]()
//        viewModel = dependencyRegistry.container.resolve(NewsTVCPresenter.self)!
        
        fetchLatest()
    }
}

// MARK: - Setup Observables
extension CategoryListViewModelImplementation {
    func setupObservable() {
        _ = currentCategory.asObservable()
            .subscribe(onNext: { [weak self] (category) in
            if let cellViewModels = self?.newsCellViewModels[category] {
                self?.cellViewModels = cellViewModels
            }
            else {
//                self?.viewModels = self?.dependencyRegistry.container.resolve(NewsTVCPresenter.self)!
                self?.fetchLatest()
                
            }
        }).disposed(by: disposeBag)
        
//        _ = articles.asObservable().subscribe(onNext: { (article) in
//            self
//        }).disposed(by: disposeBag)
    }
    
    func fetchLatest() {
        _ = newsAPIClient
//            .getEverything(q: currentCategory.value.rawValue, page: page+1, from: from, to: to)
            .getTopHeadlines(for: .us, on: .technology, of: 1)
            .subscribe({ (single) in
                switch single {
                case .success(let newsResponse):
                    if let articles = newsResponse.articles {
                        self.articles.value = articles+self.articles.value
                        if (articles.count != 0) {
                            self.from = self.articles.value[0].publishedAt
                            self.to = self.articles.value[self.articles.value.count-1].publishedAt
                        }
                        
                    }
                case .error(let error):
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    func addViewModel(viewModel:NewsTVCPresenter) {
        self.cellViewModels.append(viewModel)
    }
}

