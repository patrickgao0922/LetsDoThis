//
//  GooglePlacesAPIManager.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 29/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import GooglePlaces
import RxSwift
import SwiftyJSON
import Alamofire

protocol GooglePlacesAPIManager{
    
}
enum LocationServiceErrors:Error {
    case locationServicesUnavailable
    case denied
}
class GooglePlacesAPIManagerImplementation:GooglePlacesAPIManager {
    
//    Necessary information
    let httpProtocol = "https://"
    let host = "maps.googleapis.com"
    
    enum GoogleURLBasePath:String {
        case place = "/maps/api/place"
    }
    let outputType = "json"
    
    enum GoogleEndURI:String {
        case nearbySearch = "/nearbysearch/json"
    }
    
//    Properties
    var placesCient:GMSPlacesClient!
    var locationManager:CLLocationManager!
    
    init() {
        self.placesCient = GMSPlacesClient.shared()
        self.locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
    }
    
    func getCurrentPlace() -> Single<GMSPlaceLikelihoodList?> {
        
        return Single<GMSPlaceLikelihoodList?>.create(subscribe: { (observer) -> Disposable in
            
            do {
                try self.checkLocationServicesEnabled()
                self.placesCient.currentPlace { (likelyhoodPlaceList, error) in
                    if error != nil {
                        return observer(.error(error!))
                    }
                    return observer(.success(likelyhoodPlaceList))
                }
            }
            catch {
                observer(.error(error))
            }
            
            
            return Disposables.create()
        }).observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
        
    }
    
    func searchNearbyPlaces(by type:String) -> Single<JSON> {
        return Single<JSON>.create(subscribe: { (single) -> Disposable in
//            let headers = self.getOAuthHeaders()
            let parameters:Parameters = [
                "key":"",
                "location":[],
                "radius":5000,
                "rankby":"distance"
                
            ]
            let url = "\(self.httpProtocol)\(self.host)\(GoogleURLBasePath.place)\(GoogleEndURI.nearbySearch)"
            Alamofire.request(url, method:.get, parameters: parameters,encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .response {response in
                    if let error = response.error {
                        return single(.error(error))
                    }
                    let json = JSON(response.data!)
                    guard let _ = json["access_token"].string else {
                        return single(.error(json["access_token"].error!))
                    }
                    guard let _ = json["refresh_token"].string  else {
                        return single(.error(json["refresh_token"].error!))
                    }
                    
                    single(.success(json))
            }
            return Disposables.create()
        })
    }
}

// MARK: - CLLocation Supports
extension GooglePlacesAPIManager {
    fileprivate func checkLocationServicesEnabled() throws {
        if !CLLocationManager.locationServicesEnabled() {
            throw LocationServiceErrors.locationServicesUnavailable
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            throw LocationServiceErrors.denied
        }
    }
}
