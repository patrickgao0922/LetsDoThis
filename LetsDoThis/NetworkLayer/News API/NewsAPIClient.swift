//
//  NewsAPIClient.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 15/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

enum Directory:String {
    case websiteFaveicons
    case featuredImage
}

protocol NewsAPIClient {
    func getTopHeadlines(for country:NewsAPIRouter.Country?, on category:NewsAPIRouter.Category?, of page:Int?) -> Single<NewsResponse>
    func getSources(inCountry country:NewsAPIRouter.Country?, onCategory category:NewsAPIRouter.Category?, inLanguage language:NewsAPIRouter.Language?) -> Single<SourceResponse>
    func obtainSourceFavicon(byURL urlString:String) -> Single<String>
    func fetchFeaturedImage(from urlString:String, title:String) -> Single<String>
    func getEverything(page:Int?,from:Date?, to:Date?) -> Single<NewsResponse>
}
enum HTTPError:Error {
    case noResponseData
    case responseParsingError
    case invalidURL
}
class NewsAPIClientImplementation:NewsAPIClient {
    
    
    /// get top headlines
    ///
    /// - Parameters:
    ///   - country: country of the news
    ///   - category: categories
    ///   - page: page num of the result
    /// - Returns: Single Observable with NewsResponse data type
    func getTopHeadlines(for country:NewsAPIRouter.Country?, on category:NewsAPIRouter.Category?, of page:Int?) -> Single<NewsResponse> {
        return Single<NewsResponse>.create(subscribe: { (single) -> Disposable in
            
            //            Alamofire Request
            request(NewsAPIRouter.topHeadlines(country: country, category: category, page: page))
                .response(completionHandler: { (response) in
                    if let error = response.error {
                        single(.error(error))
                    }
                    guard let data = response.data else {
                        return single(.error(HTTPError.noResponseData))
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                        single(.success(newsResponse))
                    }
                    catch {
                        single(.error(error))
                    }
                    
                })
            return Disposables.create()
        })
    }
    
    func getEverything(page:Int? = nil,from:Date? = nil, to:Date? = nil) -> Single<NewsResponse>{
        return Single<NewsResponse>.create(subscribe: { (single) -> Disposable in
            request(NewsAPIRouter.everything(language: .us, page: page, from: from, to: to))
                .response(completionHandler: { (response) in
                    if let error = response.error {
                        single(.error(error))
                    }
                    guard let data = response.data else {
                        return single(.error(HTTPError.noResponseData))
                    }
                    do {
                        let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                        single(.success(newsResponse))
                    }
                    catch {
                        single(.error(error))
                    }
                })
            return Disposables.create()
        })
    }
    
    func getSources(inCountry country:NewsAPIRouter.Country? = nil, onCategory category:NewsAPIRouter.Category? = nil, inLanguage language:NewsAPIRouter.Language? = nil) -> Single<SourceResponse>{
        return Single<SourceResponse>.create(subscribe: { (single) -> Disposable in
            request(NewsAPIRouter.sources(country: country, category: category, language: language))
                .response(completionHandler: { (response) in
                    if let error = response.error {
                        single(.error(error))
                    }
                    guard let data = response.data else {
                        return single(.error(HTTPError.noResponseData))
                    }
                    do {
                        let sourcesResponse = try JSONDecoder().decode(SourceResponse.self, from: data)
                        single(.success(sourcesResponse))
                    }
                    catch {
                        single(.error(error))
                    }
                })
            return Disposables.create()
        })
    }
    
    func obtainSourceFavicon(byURL urlString:String) -> Single<String>{
        guard let url = URL(string: urlString) else {
            return Single.error(HTTPError.invalidURL)
        }
        guard let host = url.host else {
            return Single.error(HTTPError.invalidURL)
        }
        let filename = "\(host)-favicon.ico"
        return downloadImagesToDestination(from: url.appendingPathComponent("/favicon.ico"), inDirectory: .websiteFaveicons, filename: filename, useExistingFile: true)
    }
    
    func downloadImagesToDestination(from url:URL, inDirectory: Directory, filename:String, useExistingFile:Bool) -> Single<String>{
        return Single<String>.create(subscribe: { (single) -> Disposable in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(inDirectory.rawValue).appendingPathComponent(filename)
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            if useExistingFile && self.imageExists(fileURL: fileURL){
                single(.success(fileURL.absoluteString))
            }else {
                download(url, method: .get, to:destination)
                    .responseData(completionHandler: { (response) in
                        if let error = response.error {
                            single(.error(error))
                        }
                        guard let imagePath = response.destinationURL?.path else {
                            return single(.error(HTTPError.noResponseData))
                        }
                        single(.success(imagePath))
                    })
            }
            
            return Disposables.create()
        })
    }
    func imageExists(fileURL:URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileURL.absoluteString)
    }
    
    func fetchFeaturedImage(from urlString:String, title:String) -> Single<String>{
        guard let url = URL(string: urlString) else {
            return Single.error(HTTPError.invalidURL)
        }
        let filename = "\(title.trimmingCharacters(in: CharacterSet.whitespaces))"
        return downloadImagesToDestination(from: url, inDirectory: .featuredImage, filename: filename, useExistingFile: true)
    }
}
