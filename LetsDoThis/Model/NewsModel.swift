//
//  NewsModel.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 19/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation

protocol NewsModel {}

class NewsModelImplementation {
    fileprivate var newsAPIClient:NewsAPIClient
    init(with newsAPIClient:NewsAPIClient) {
        self.newsAPIClient = newsAPIClient
    }
    
//    func loadFeaturedB
}
