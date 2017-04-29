//
//  LocationDelegate.swift
//  compass
//
//  Created by Federico Zanetello on 05/04/2017.
//  Copyright © 2017 Kimchi Media. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate {
  var locationCallback: ((CLLocation) -> ())? = nil
  var headingCallback: ((CLLocationDirection) -> ())? = nil
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else { return }
    locationCallback?(currentLocation)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    headingCallback?(newHeading.trueHeading)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("⚠️ Error while updating location " + error.localizedDescription)
  }
}
