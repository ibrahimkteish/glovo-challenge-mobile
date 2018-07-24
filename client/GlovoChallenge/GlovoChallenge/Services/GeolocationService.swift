//
//  GeolocationService.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

class GeolocationService {
  
  static let instance = GeolocationService()
  private (set) var authorized: Driver<CLAuthorizationStatus>
  private (set) var location: Driver<CLLocationCoordinate2D>
  
  private let locationManager = CLLocationManager()
  
  private init() {
    
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    
    authorized = Observable.deferred { [weak locationManager] in
      let status = CLLocationManager.authorizationStatus()
      guard let locationManager = locationManager else {
        return Observable.just(status)
      }
      return locationManager
        .rx.didChangeAuthorizationStatus
        .startWith(status)
      }
      .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
    
    location = locationManager.rx.didUpdateLocations
      .asDriver(onErrorJustReturn: [])
      .flatMap {
        return $0.last.map(Driver.just) ?? Driver.empty()
      }
      .map { $0.coordinate }
    
    
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }
  
}
