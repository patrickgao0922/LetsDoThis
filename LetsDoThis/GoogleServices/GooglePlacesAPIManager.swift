//
//  GooglePlacesAPIManager.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 29/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import GooglePlaces
import RxSwift

protocol GooglePlacesAPIManager{
    
}

class GooglePlacesAPIManagerImplementation:GooglePlacesAPIManager {
    var placesCient:GMSPlacesClient!
    init() {
        self.placesCient = GMSPlacesClient.shared()
    }
    
    func getCurrentPlace() -> Single<GMSPlaceLikelihoodList?> {
        return Single<GMSPlaceLikelihoodList?>.create(subscribe: { (observer) -> Disposable in
            self.placesCient.currentPlace { (likelyhoodPlaceList, error) in
                if error != nil {
                    return observer(.error(error!))
                }
                return observer(.success(likelyhoodPlaceList))
            }
            return Disposables.create()
        })
        
    }
    
    func searchNearbyPlacesByType
}
