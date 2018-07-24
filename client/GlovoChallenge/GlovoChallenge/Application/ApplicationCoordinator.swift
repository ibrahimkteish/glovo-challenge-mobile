//
//  ApplicationCoordinator.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxSwift
import GoogleMaps

final class ApplicationCoordinator: BaseCoordinator {
  // MARK: Properties
  private let disposeBag = DisposeBag()
  private let coordinatorFactory: CoordinatorFactory
  private let router: Router
  
  // MARK: init
  init(coordinatorFactory: CoordinatorFactory, router: Router) {
    self.coordinatorFactory = coordinatorFactory
    self.router = router
    GMSServices.provideAPIKey("AIzaSyABaf9jHQn6I1j-cBgrPoXAsmSQBotSu6c")
  }
  
  // MARK: Override
  override func start() {
      self.runMainFlow()
  }
  
  // MARK: Methods
  func runMainFlow() {
    let (coordinator, module) = coordinatorFactory.makeTabBarCoordinator()
    addDependency(coordinator)
    router.setRootModule(module, hideBar: true)
    coordinator.start()
  }
}
