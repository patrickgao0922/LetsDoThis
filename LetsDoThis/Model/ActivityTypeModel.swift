//
//  ActivityTypeModel.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 27/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol ActivityTypeModel {
    func loadActivityType() -> Single<[ActivityTypeDTO]>
}

class ActivityTypeModelImplementation:ActivityTypeModel {
    fileprivate var translationLayer:ActivityTypeTranslationLayer
    init(withTranslationLayer translationLayer:ActivityTypeTranslationLayer){
        self.translationLayer = translationLayer
    }
    enum ActivityTypeError:Error {
        case notFoundFilePath
        case unableLoadingJSONData
    }
    func loadActivityType() -> Single<[ActivityTypeDTO]>{
        return Single<[ActivityTypeDTO]>.create(subscribe: { (single) -> Disposable in
            if let filePath = Bundle.main.url(forResource: "activity-type", withExtension: "json") {
                do  {
                    let data = try Data(contentsOf: filePath, options:.mappedRead)
                    let json = try JSON(data: data)
                    let activityTypeDTOs = json.arrayValue.flatMap({ (json) -> ActivityTypeDTO? in
                        return self.translationLayer.translateActivityTypeJsonToDTO(fromJson: json)
                    })
                    single(.success(activityTypeDTOs))
                }
                catch {
                    single(.error(ActivityTypeError.unableLoadingJSONData))
                }
                
            } else {
                single(.error(ActivityTypeError.notFoundFilePath))
            }
            return Disposables.create()
        })
    }
}
