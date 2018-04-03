//
//  GooglePlacesAPIManagerImplementationTests.swift
//  LetsDoThisTests
//
//  Created by Patrick Gao on 29/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreLocation
@testable import LetsDoThis

class GooglePlacesAPIManagerImplementationTests:QuickSpec {
    override func spec() {
        describe("Test Google Places API Manager:") {
            let googlePlacesAPIManager:GooglePlacesAPIManagerImplementation = GooglePlacesAPIManagerImplementation()
            let locationManager = CLLocationManager()
            beforeSuite {
                locationManager.requestAlwaysAuthorization()
            }
            it("Test get current locationns:"){
                waitUntil(timeout: 5.0, action: { (done) in
                    googlePlacesAPIManager.getCurrentPlace().subscribe({ (single) in
                        switch single {
                        case .success(let placeList):
                            expect(placeList).notTo(beNil())
                        case .error(let error):
                            fail(error.localizedDescription)
                        }
                    })
                })
            }
        }
    }
}
