//
//  HomeCoordinator.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation


final class HomeCoordinator: BaseCoordinator {
  
  private let factory: HomeModulesFactory
  private let router: Router
  
  init(router: Router, factory: HomeModulesFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showHome()
  }
  
  // MARK: - Run current flow's controllers
  
  private func showHome() {
    let activeUsersFlowOutput = factory.makeHomeOutput()
    self.router.setRootModule(activeUsersFlowOutput)
  }
}
