//
//  LocationManager.swift
//  ChallengeTecnico
//
//  Created by Juan Tocino on 08/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager{
    var currentLocation: CLLocation!
    var locManager = CLLocationManager()
    
    public init(){
        locManager.requestWhenInUseAuthorization()
    }
    
    public func getLocation() -> (String, String){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() ==  .authorizedAlways{
                self.currentLocation = self.locManager.location
                return (String(currentLocation.coordinate.latitude), String(currentLocation.coordinate.longitude))
            }
        return ("","")
    }
}
