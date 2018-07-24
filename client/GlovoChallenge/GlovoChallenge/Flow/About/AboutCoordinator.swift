//
//  AboutCoordinator.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

final class AboutCoordinator: BaseCoordinator {
  
  private let factory: AboutModulesFactory
  private let router: Router
  
  init(router: Router, factory: AboutModulesFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showAbout()
  }
  
  // MARK: - Run current flow's controllers
  
  private func showAbout() {
    let activeUsersFlowOutput = factory.makeAboutOutput()
    self.router.setRootModule(activeUsersFlowOutput)
  }
}
