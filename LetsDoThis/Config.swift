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
    
    fileprivate func infoForKey(_ key: String) -> Any? {
        return (Bundle.main.infoDictionary?[key])
    }
}
