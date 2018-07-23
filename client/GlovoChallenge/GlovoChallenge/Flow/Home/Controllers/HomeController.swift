//
//  HomeController.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import GoogleMaps

protocol HomeViewOutput: BaseView {
  var onLocationNotGranted: PublishSubject<Void> { get }
}

final class HomeController: UIViewController, HomeViewOutput {
  private let disposeBag = DisposeBag()
  let onLocationNotGranted: PublishSubject<Void> = .init()
  
  @IBOutlet weak var mapView: GMSMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let geolocationService = GeolocationService.instance
    
    geolocationService
      .authorized
      .distinctUntilChanged()
      .drive(onNext: { [weak self] (value) in
        switch value {
        case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
          break
        case .restricted, .denied:
            self?.onLocationNotGranted.onNext(())
        }
    }).disposed(by: self.disposeBag)
  }
}
