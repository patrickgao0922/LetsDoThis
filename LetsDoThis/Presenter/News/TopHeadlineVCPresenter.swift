//
//  TopHeadlineVCPresenter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 16/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift
import Swinject
import SwinjectStoryboard

protocol TopHeadlineVCPresenter {
    var featuredNews:Variable<Article?> {get}
    var featuredNewsPresenter:Variable<NewsTVCPresenter?> {get}
    var news:Variable<[Article]> {get}
    var cellPresenters:[NewsTVCPresenter]{get}
    func loadLatestTopHeadline() -> Single<[Article]>
    func addCellPresenter(cellPresenter:NewsTVCPresenter)
}

class TopHeadlineVCPresenterImplementation:TopHeadlineVCPresenter {
    var page:Int
    var pageSize:Int
    var newsAPIClient:NewsAPIClient
    var news:Variable<[Article]>
    var featuredNews:Variable<Article?>
    var cellPresenters:[NewsTVCPresenter]
    var featuredNewsPresenter:Variable<NewsTVCPresenter?>
    
    init(with newsAPIClient:NewsAPIClient) {
        self .newsAPIClient = newsAPIClient
        page = 1
        pageSize = 20
        news = Variable<[Article]>([])
        cellPresenters = []
        featuredNews = Variable<Article?>(nil)
        featuredNewsPresenter = Variable<NewsTVCPresenter?>(nil)
        setUpObservables()
    }
    
//    News loading functions
    func loadLatestTopHeadline() -> Single<[Article]> {
        return newsAPIClient.getTopHeadlines(for: .us, on: nil, of: 1)
            .map({ (newsResponse) -> [Article] in
                guard let articles = newsResponse.articles else {
                    return []
                }
                self.news.value = articles
                return articles
            })
    }
    
    func addCellPresenter(cellPresenter:NewsTVCPresenter) {
        self.cellPresenters.append(cellPresenter)
    }
}

// MARK: - Setup Observables
extension TopHeadlineVCPresenterImplementation {
    func setUpObservables() {
        _ = news.asObservable().subscribe(onNext: { (articles) in
            if articles.count != 0 {
                self.featuredNews.value = articles[0]
            }
        })
        _ = featuredNews.asObservable().subscribe(onNext: { (article) in
            if let article = article {
                self.featuredNewsPresenter.value =
                AppDelegate.dependencyRegistry?.container.resolve(NewsTVCPresenter.self, argument: article)
            }
            
        })
        
    }
}
