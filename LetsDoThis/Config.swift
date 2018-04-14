//
//  Config.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 4/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation

class Config {
    static let shared = Config()
    var googleAPIKey:String? {
        guard let google = infoForKey("Google") as? Dictionary<String,String> else {
            return nil
        }
        return google["API Key"]
    }
    
    var newsAPIKey:String {
        guard let apiKey = infoForKey("News API Key") as? String else {
            return ""
        }
        return apiKey
    }

    var OAuth:(clientID:String,clientSecret:String)? {
        guard let oauth = infoForKey("OAuth") as? Dictionary<String,String> else {
            return nil
        }
        guard let clientID = oauth["Client ID"] else {
            return nil
        }
        
        guard let clientSecret = oauth["Client Secret"] else {
            return nil
        }
        
        return (clientID,clientSecret)
    }
    
    fileprivate func infoForKey(_ key: String) -> Any? {
        return (Bundle.main.infoDictionary?[key])
    }
}
