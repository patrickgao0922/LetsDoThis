//
//  ActivityTypeVCPresenter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 27/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift

protocol ActivityTypeVCPresenter {
    
}

class ActivityTypeVCPresenterImplementation:ActivityTypeVCPresenter {
    fileprivate var activityTypeModel: ActivityTypeModel

    var activityTypes:Variable<[ActivityTypeDTO]>
    init(with activityTypeModel: ActivityTypeModel) {
        self.activityTypes = Variable<[ActivityTypeDTO]>([])
        self.activityTypeModel = activityTypeModel
    }
    
}
