//
//  NewsWebViewModel.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 24/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation

protocol NewsWebViewModel {
    var url:String{get}
    var sourceName:String {get}
}

class NewsWebViewModelImplementation:NewsWebViewModel {
    var article:Article
    var url:String
    var sourceName:String
    init(with article:Article) {
        self.article = article
        self.url = article.url!
        self.sourceName = article.source!.name!
    }
}
