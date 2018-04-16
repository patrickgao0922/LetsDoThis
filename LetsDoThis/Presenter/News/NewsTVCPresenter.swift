//
//  NewsTVCPresenter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 16/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import RxSwift

protocol NewsTVCPresenter {
    var article:Article {get}
    var featuredImage:UIImage? {get}
    var title:String? {get}
    var mediaName:String? {get}
    var mediaIcon:UIImage? {get}
}

class NewsTVCPresenterImplementation:NewsTVCPresenter{
    
    var article:Article
    var featuredImage:UIImage?
    var title:String?
    var mediaName:String?
    var mediaIcon:UIImage?
    
    init(with article:Article) {
        self.article = article
    }
}
