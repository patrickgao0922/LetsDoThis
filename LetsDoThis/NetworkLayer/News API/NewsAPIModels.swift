//
//  NewsAPIModels.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 15/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation

struct SourceResponse:Codable {
    var status:String
    var code:String?
    var message:String?
    var sources:[Source]?
}

struct NewsResponse:Codable {
    var status:String
    var code:String?
    var message:String?
    var totalResults:Int?
    var articles:[Article]?
}

struct Article:Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage:String?
    var publishedAt:String?
}

struct Source:Codable {
    var id:String?
    var name:String?
    var description:String?
    var url: String?
    var category:String?
    var language: String?
    var country: String?
}
