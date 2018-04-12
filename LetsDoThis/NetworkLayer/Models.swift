//
//  Models.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 11/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation

struct UserToken: Codable {
    let accessToken: String
    let refreshToken:String
    
    enum CodingKeys:String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
