//
//  NewsTVCPresenter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 16/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import RxSwift
import CoreData

protocol NewsTVCPresenter {
    var article:Article {get}
    var featuredImagePath:Variable<String?> {get}
    var title:String? {get}
    var mediaName:String? {get}
    var mediaIconPath:Variable<String?> {get}
}

class NewsTVCPresenterImplementation:NewsTVCPresenter{
    var newsAPIClient:NewsAPIClient
    var coreDataContainer:CoreDataContainer
    fileprivate var managedObjectContext:NSManagedObjectContext
    var article:Article
    var featuredImagePath:Variable<String?>
    var title:String? {
        return article.title
    }
    var mediaName:String? {
        return article.source?.name
    }
    var mediaIconPath:Variable<String?>
    
    init(with article:Article, newsAPIClient:NewsAPIClient, coreDataContainer:CoreDataContainer) {
        self.article = article
        self.coreDataContainer = coreDataContainer
        featuredImagePath = Variable<String?>(nil)
        mediaIconPath = Variable<String?>(nil)
        self.newsAPIClient = newsAPIClient
        self.managedObjectContext = coreDataContainer.persistentContainer.newBackgroundContext()
    }
    
    
    func loadfeaturedImage() {
        guard let source = article.source else {
            return
        }
        
        guard let sourceMO = source.createOrFetchManagedObjectInCoreData(with: managedObjectContext) else {
            return
        }
        guard let url = sourceMO.url else {
            return
        }
        _ = newsAPIClient.obtainSourceFavicon(byURL: url)
            .subscribe({ (single) in
                switch single {
                case .success(let imagePath):
                    self.mediaIconPath.value = imagePath
                case .error (_):
                    return
                }
            })
    }
    func loadMediaIcon() {
        
    }
}
