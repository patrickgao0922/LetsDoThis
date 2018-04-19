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
    var featuredImagePath:Variable<String?> {get}
    var title:String? {get}
    var mediaName:String? {get}
    var mediaIconPath:Variable<String?> {get}
    func loadFeaturedImage()
    func loadMediaIcon()
}

class NewsTVCPresenterImplementation:NewsTVCPresenter{
    fileprivate var newsAPIClient:NewsAPIClient
    fileprivate var managedObjectContext:NSManagedObjectContext
    fileprivate var article:Article
    
    var coreDataContainer:CoreDataContainer
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
    
    
    func loadMediaIcon() {
        guard let source = article.source else {
            return
        }
        
        guard let sourceMO = source.createOrFetchManagedObjectInCoreData(with: managedObjectContext) else {
            return
        }
        
        if let iconPath = sourceMO.iconPath {
            mediaIconPath.value = iconPath
        } else {
            guard let url = sourceMO.url else {
                return
            }
            _ = newsAPIClient.obtainSourceFavicon(byURL: url)
                .subscribe({ (single) in
                    switch single {
                    case .success(let imagePath):
                        self.mediaIconPath.value = imagePath
                        sourceMO.iconPath = imagePath
                        try? self.managedObjectContext.save()
                    case .error (_):
                        return
                    }
                })
        }
        
    }
    func loadFeaturedImage() {
        guard let featuredImageURL = article.urlToImage else {
            return
        }
        guard let title = self.title else{
            return
        }
        _ = newsAPIClient.fetchFeaturedImage(from: featuredImageURL, title: title)
            .subscribe { (single) in
                switch single {
                case .success(let imagePath):
                    self.featuredImagePath.value = imagePath
                case .error (_):
                    return
                }
        }
    }
}
