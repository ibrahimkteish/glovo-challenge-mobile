//
//  CoordinatorFactoryImp.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import UIKit

final class CoordinatorFactoryImp : CoordinatorFactory {
  
  private func router(_ navController: UINavigationController?) -> Router {
    return RouterImp(rootController: navigationController(navController))
  }
  
  private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
    if let navController = navController { return navController } else { return UINavigationController.controllerFromStoryboard(.main) }
  }
  
  func makeTabBarCoordinator() -> (configurator: Coordinator, toPreesent: Presentable) {
    let controller = TabbarController.controllerFromStoryboard(.main)
    let coordinator = TabbarCoordinator(tabbarView: controller, coordinatorFactory: CoordinatorFactoryImp())
    return (coordinator, controller)
  }
  
  func makeAboutCoordinator(navigationController: UINavigationController) -> Coordinator {
    return AboutCoordinator.init(router: self.router(navigationController), factory: ModulesFactoryImp())
  }
  
  func makeHomeCoordinator(navigationController: UINavigationController) -> Coordinator {
    return HomeCoordinator.init(router: self.router(navigationController), factory: ModulesFactoryImp())
  }
}
