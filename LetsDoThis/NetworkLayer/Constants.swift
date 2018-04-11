//
//  Constants.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 11/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer{
        static let baseURL = "http://"
    }
    struct LocalServer {
        static let baseURL = "http://localhost:8080"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
    }
}

enum HTTPHeaderField:String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept_Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
