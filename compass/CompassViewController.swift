//
//  CompassViewController.swift
//  compass
//
//  Created by Federico Zanetello on 05/04/2017.
//  Copyright © 2017 Kimchi Media. All rights reserved.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  let locationDelegate = LocationDelegate()
  var latestLocation: CLLocation? = nil
  var yourLocationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0 }
  var yourLocation: CLLocation {
    get { return UserDefaults.standard.currentLocation }
    set { UserDefaults.standard.currentLocation = newValue }
  }
  
  let locationManager: CLLocationManager = {
    $0.requestWhenInUseAuthorization()
    $0.desiredAccuracy = kCLLocationAccuracyBest
    $0.startUpdatingLocation()
    $0.startUpdatingHeading()
    return $0
  }(CLLocationManager())
  
  private func orientationAdjustment() -> CGFloat {
    let isFaceDown: Bool = {
      switch UIDevice.current.orientation {
      case .faceDown: return true
      default: return false
      }
    }()
    
    let adjAngle: CGFloat = {
      switch UIApplication.shared.statusBarOrientation {
      case .landscapeLeft:  return 90
      case .landscapeRight: return -90
      case .portrait, .unknown: return 0
      case .portraitUpsideDown: return isFaceDown ? 180 : -180
      }
    }()
    return adjAngle
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = locationDelegate
    
    locationDelegate.locationCallback = { location in
      self.latestLocation = location
    }
    
    locationDelegate.headingCallback = { newHeading in
      
      func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
        let heading: CGFloat = {
          let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
          switch UIDevice.current.orientation {
          case .faceDown: return -originalHeading
          default: return originalHeading
          }
        }()
        
        return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
      }
      
      UIView.animate(withDuration: 0.5) {
        let angle = computeNewAngle(with: CGFloat(newHeading))
        self.imageView.transform = CGAffineTransform(rotationAngle: angle)
      }
    }
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CompassViewController.showMap))
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func showMap() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController")
    ((mapViewController as? UINavigationController)?.viewControllers.first as? MapViewController)?.delegate = self
    self.present(mapViewController, animated: true, completion: nil)
  }
}

extension CompassViewController: MapViewControllerDelegate {
  func update(location: CLLocation) {
    yourLocation = location
  }
}
