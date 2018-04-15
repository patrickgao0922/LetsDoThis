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
    var activityTypes:Variable<[ActivityTypeDTO]> {get}
    func loadActivityTypes() -> Single<[ActivityTypeDTO]>
}

class ActivityTypeVCPresenterImplementation:ActivityTypeVCPresenter {
    fileprivate var activityTypeModel: ActivityTypeModel
    
    var activityTypes:Variable<[ActivityTypeDTO]>
    init(with activityTypeModel: ActivityTypeModel) {
        self.activityTypes = Variable<[ActivityTypeDTO]>([])
        self.activityTypeModel = activityTypeModel
    }
    
    func loadActivityTypes() -> Single<[ActivityTypeDTO]>{
        return activityTypeModel.loadActivityType()
            .map { (activityTypeDTOs) -> [ActivityTypeDTO] in
                self.activityTypes.value = activityTypeDTOs
                return activityTypeDTOs
        }
        
    }
}

// MARK: - Setup Observables

