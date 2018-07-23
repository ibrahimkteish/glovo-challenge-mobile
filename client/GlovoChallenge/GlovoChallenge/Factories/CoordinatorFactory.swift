//
//  CoordinatorFactory.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import UIKit
 
protocol CoordinatorFactory {
  func makeTabBarCoordinator() -> (configurator: Coordinator, toPreesent: Presentable)
  func makeAboutCoordinator(navigationController: UINavigationController) -> Coordinator
  func makeHomeCoordinator(navigationController: UINavigationController) -> Coordinator

}
