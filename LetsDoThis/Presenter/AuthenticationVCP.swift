//
//  AuthenticationVCP.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 15/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthenticationVCP {
    var user:Variable<UserDTO>? {get set}
}

class AuthenticationVCPImplementation:AuthenticationVCP {
    var user:Variable<UserDTO>?
    var loginManager:LoginManager?
    
    init(loginManager:LoginManager) {
        self.loginManager = loginManager
    }
    
    func authenticateUser(with email:String, password: String) {
        
    }
}
