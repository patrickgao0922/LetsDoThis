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
    fileprivate var disposeBag:DisposeBag

    var activityTypes:Variable<[ActivityTypeDTO]>
    init(with activityTypeModel: ActivityTypeModel) {
        self.activityTypes = Variable<[ActivityTypeDTO]>([])
        self.activityTypeModel = activityTypeModel
        self.disposeBag = DisposeBag()
    }
    
    func loadActivityTypes() -> Completable {
        return Completable.create(subscribe: { (completable) -> Disposable in
            activityTypeModel.
                .flatMap({ (json) -> Completable in
                    for
                })
            Disposables.create()
        })
    }
    
}
