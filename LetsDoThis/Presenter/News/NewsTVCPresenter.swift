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

protocol NewsTVCPresenter{
    var article:Article{get}
//    var featuredImagePath:Variable<String?> {get}
    var title:String? {get}
    var mediaName:String? {get}
    var mediaIconPath:Variable<String?> {get}
    var publishedAt:Date? {get}
    var mediaIcon:Variable<UIImage?> {get}
    var featuredImage:Variable<UIImage?> {get}
    func loadFeaturedImage()
    func loadMediaIcon()
}

class NewsTVCPresenterImplementation:NewsTVCPresenter{
    fileprivate var newsAPIClient:NewsAPIClient
    fileprivate var managedObjectContext:NSManagedObjectContext
    var article:Article
    var mediaIcon:Variable<UIImage?>
    var featuredImage:Variable<UIImage?>
    
    var coreDataContainer:CoreDataContainer
    var featuredImagePath:Variable<String?>
    
    
//    RxSwift Subscribtion
    var title:String? {
        return article.title
    }
    var mediaName:String? {
        return article.source?.name
    }
    var publishedAt: Date? {
        return article.publishedAt
    }
    var mediaIconPath:Variable<String?>
    
    init(with article:Article, newsAPIClient:NewsAPIClient, coreDataContainer:CoreDataContainer) {
        self.article = article
        self.coreDataContainer = coreDataContainer
        featuredImagePath = Variable<String?>(nil)
        mediaIconPath = Variable<String?>(nil)
        featuredImage = Variable<UIImage?>(nil)
        mediaIcon = Variable<UIImage?>(nil)
        self.newsAPIClient = newsAPIClient
        self.managedObjectContext = coreDataContainer.persistentContainer.newBackgroundContext()
        setupObservables()
        startDownloading()
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
        }
        
    }
    func loadFeaturedImage() {
        guard let featuredImageURL = article.urlToImage else {
            self.featuredImage.value = UIImage(named: "featured-image-placeholder")
            return
        }
        guard let title = self.title else{
            return
        }
        _ = newsAPIClient.fetchFeaturedImage(from: featuredImageURL, title: title)
            .subscribe { [weak self] (single) in
                switch single {
                case .success(let imagePath):
                    self?.featuredImage.value = UIImage(contentsOfFile: imagePath)
//                    self.featuredImagePath.value = imagePath
                case .error (_):
                    self?.featuredImage.value = UIImage(named: "featured-image-placeholder")
                    return
                }
        }
    }
}

extension NewsTVCPresenterImplementation {
    fileprivate func setupObservables() {

    }
    
    fileprivate func startDownloading() {
//        self.loadMediaIcon()
        self.loadFeaturedImage()
    }
}
