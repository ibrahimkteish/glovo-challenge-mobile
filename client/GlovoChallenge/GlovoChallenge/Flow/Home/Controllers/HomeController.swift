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

protocol HomeViewInput: BaseView {
  var onUserDidSelectCity: PublishSubject<City> { get }
}

protocol HomeViewOutput: BaseView {
  var onLocationNotGranted: PublishSubject<Void> { get }
}

protocol HomeViewType: HomeViewInput, HomeViewOutput {
  var input: HomeViewInput { get }
  var output: HomeViewOutput { get }
}

final class HomeController: UIViewController, HomeViewType {
  var input: HomeViewInput { return self }
  var output: HomeViewOutput { return self }
  
  let onUserDidSelectCity: PublishSubject<City> = .init()
  
  private let disposeBag = DisposeBag()
  private let viewModel: HomeViewModelType = HomeViewModel()
  
  let onLocationNotGranted: PublishSubject<Void> = .init()
  var cityCoords: [String: CLLocationCoordinate2D] = [:]
  
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var showList: UIButton!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var countryCode: UILabel!
  @IBOutlet weak var code: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.mapView.delegate = self // can be reactive too
    
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
    
    self.input.onUserDidSelectCity.subscribe(onNext: { [weak self] (selectedCity) in
      self?.fillCityData(selectedCity)
      
      if let coords = self?.cityCoords[selectedCity.name] {
        self?.mapView?.camera = GMSCameraPosition(target: coords,
                                                 zoom: 15,
                                                 bearing: 0,
                                                 viewingAngle: 0)
      }
      
    }).disposed(by: self.disposeBag)
  
    geolocationService
      .location
      .asObservable()
      .takeUntil(self.onUserDidSelectCity)
      .subscribe(onNext: { [weak self] (coordinates) in
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 15)
        self?.mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude,
                                                 longitude: coordinates.longitude)
        marker.title = "Me"
        marker.icon = #imageLiteral(resourceName: "me")
        marker.map = self?.mapView
        
        //Check if outside working area

    }).disposed(by: self.disposeBag)

    self.showList.rx.tap.bind(to: self.onLocationNotGranted).disposed(by: self.disposeBag)
    
    self.viewModel.output.data.drive(onNext: { [weak self] (cities) in
      
      for city in cities {
        
        var polygon: GMSPolygon = GMSPolygon()
        for workingArea in city.workingArea {
          let path = GMSPath(fromEncodedPath: workingArea)
          
          polygon = GMSPolygon(path: path)
          polygon.userData = city
          polygon.map = self?.mapView
          polygon.fillColor = UIColor.blue.withAlphaComponent(0.5)
        }
        self?.getTheCenterOfPolygonAndDrawAMarker(polygon: polygon, city: city)
      }
    }).disposed(by: self.disposeBag)
  }
  
  private func getTheCenterOfPolygonAndDrawAMarker(polygon: GMSPolygon, city: City) {
    
    let count = polygon.path?.count() ?? 0
    var pathCoords: [CLLocationCoordinate2D] = []
    if count >= 3 {
      let countMinusTwo =  Int(count - 2)
      for i in UInt(0)...(polygon.path?.count() ?? 0) {
        if let coordinates = polygon.path?.coordinate(at: i) {
          pathCoords.append(coordinates)
        }
      }
      
      pathCoords = pathCoords.sorted(by: { (locCoord1, locCoord2) -> Bool in
        return locCoord1.latitude < locCoord2.latitude && locCoord1.longitude < locCoord2.longitude
      })
      let x1 = pathCoords[1].latitude
      let y1 = pathCoords[1].longitude
      let x2 = pathCoords[countMinusTwo].latitude
      let y2 = pathCoords[countMinusTwo].longitude
      
      let center = CLLocationCoordinate2D(latitude: x1 + ((x2 - x1) / 2.0), longitude: y1 + ((y2 - y1) / 2.0))
      let marker = GMSMarker()
      
      marker.position = center
      marker.title = city.name
      marker.icon = #imageLiteral(resourceName: "marker")
      marker.map = self.mapView
      marker.userData = city
      
      self.cityCoords[city.name] = center
      
    }
  }
  fileprivate func fillCityData(_ city: City) {
    self.countryCode.text = city.countryCode.rawValue
    self.name.text = city.name
    self.code.text = city.code.rawValue
  }
}

extension HomeController: GMSMapViewDelegate {
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    self.mapView?.camera = GMSCameraPosition(target: marker.position,
                                             zoom: 15,
                                             bearing: 0,
                                             viewingAngle: 0)
    let city = marker.userData as! City
    self.fillCityData(city)
    return true
  }
}
