//
//  HomeCoordinator.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxSwift


final class HomeCoordinator: BaseCoordinator {
  
  private let factory: HomeModulesFactory
  private let router: Router
  private let disposeBag = DisposeBag()
  
  init(router: Router, factory: HomeModulesFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showHome()
  }
  
  // MARK: - Run current flow's controllers
  
  private func showHome() {
    let homeOutput = factory.makeHomeOutput()
    
    homeOutput.onLocationNotGranted.subscribe(onNext: { [weak self] () in
      self?.showCountriesList(with: homeOutput)
    }).disposed(by: self.disposeBag)
    
    self.router.setRootModule(homeOutput)
  }
  
  private func showCountriesList(with homeInput: HomeViewInput) {
    let countryListOutput = factory.makeCountryListOutput()
    countryListOutput.onDidSelectCity.subscribe(onNext: { [weak self] (city) in
      homeInput.onUserDidSelectCity.onNext(city)
      self?.router.dismissModule()
    }).disposed(by: self.disposeBag)
    self.router.present(countryListOutput)
  }
}
