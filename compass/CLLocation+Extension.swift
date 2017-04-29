//
//  CLLocation+Extension.swift
//  compass
//
//  Created by Federico Zanetello on 05/04/2017.
//  Copyright © 2017 Kimchi Media. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

public extension CLLocation {
  func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
    
    let lat1 = self.coordinate.latitude.degreesToRadians
    let lon1 = self.coordinate.longitude.degreesToRadians
    
    let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
    let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
    
    let dLon = lon2 - lon1
    
    let y = sin(dLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
    let radiansBearing = atan2(y, x)
    
    return CGFloat(radiansBearing)
  }
  
  func bearingToLocationDegrees(destinationLocation: CLLocation) -> CGFloat {
    return bearingToLocationRadian(destinationLocation).radiansToDegrees
  }
}

extension CGFloat {
  var degreesToRadians: CGFloat { return self * .pi / 180 }
  var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

private extension Double {
  var degreesToRadians: Double { return Double(CGFloat(self).degreesToRadians) }
  var radiansToDegrees: Double { return Double(CGFloat(self).radiansToDegrees) }
}
