//
//  ActivityTypeTranslationLayer.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 27/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ActivityTypeTranslationLayer{
    func translateActivityTypeJsonToDTO(fromJson json:JSON) -> ActivityTypeDTO?
}

class ActivityTypeTranslationLayerImplementation:ActivityTypeTranslationLayer{
    func translateActivityTypeJsonToDTO(fromJson json:JSON) -> ActivityTypeDTO? {
        guard let name = json["name"].string else {
            return nil
        }
        guard let icon = json["icon"].string else {
            return nil
        }
        guard let background = json["background"].string else {
            return nil
        }
        let activityTypeDTO = ActivityTypeDTO(withName: name, icon: icon, background: background)
        return activityTypeDTO
    }
}
