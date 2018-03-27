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
    func loadActivityType() -> Single<JSON>
}

class ActivityTypeModelImplementation:ActivityTypeModel {
    init(){}
    enum ActivityTypeError:Error {
        case notFoundFilePath
        case unableLoadingJSONData
    }
    func loadActivityType() -> Single<JSON>{
        return Single<JSON>.create(subscribe: { (single) -> Disposable in
            if let filePath = Bundle.main.url(forResource: "activity-type", withExtension: "json") {
                do  {
                    let data = try Data(contentsOf: filePath, options:.mappedRead)
                    let json = try JSON(data: data)
                    single(.success(json))
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
