//
//  MapViewControllerDelegate.swift
//  compass
//
//  Created by Federico Zanetello on 23/04/2017.
//  Copyright © 2017 Kimchi Media. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapViewControllerDelegate {
  func update(location: CLLocation)
}
