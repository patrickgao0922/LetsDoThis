//
//  ActivityTypeDTO.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 27/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation

struct ActivityTypeDTO {
    var name:String
    var icon:String
    var background:String
    init() {
        name = ""
        icon = ""
        background = ""
    }
    init(withName name: String, icon:String, background:String) {
        self.name = name
        self.icon = icon
        self.background = background
    }
}
