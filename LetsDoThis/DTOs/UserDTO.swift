//
//  UserDTO.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 17/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation

struct UserDTO {
    var id:String
    var email:String
    var firstname:String
    var lastname:String
    init(with id:String, email:String, firstname:String, lastname:String) {
        self.id = id
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
    }
    init() {
        self.id = ""
        self.email = ""
        self.firstname = ""
        self.lastname = ""
    }
}
