//
//  TopHeadlineVCPresenter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 16/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift

protocol TopHeadlineVCPresenter {
    var news:Variable<[Article]> {get}
    func loadLatestTopHeadline() -> Single<[Article]>
}

class TopHeadlineVCPresenterImplementation:TopHeadlineVCPresenter {
    var page:Int
    var pageSize:Int
    var newsAPIClient:NewsAPIClient
    var news:Variable<[Article]>
    
    init(with newsAPIClient:NewsAPIClient) {
        self .newsAPIClient = newsAPIClient
        page = 1
        pageSize = 20
        news = Variable<[Article]>([])
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
}

// MARK: - Setup Observables
extension TopHeadlineVCPresenterImplementation {}
