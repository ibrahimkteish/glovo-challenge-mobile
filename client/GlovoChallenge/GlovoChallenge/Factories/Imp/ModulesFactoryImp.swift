//
//  ModulesFactoryImp.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

final class ModulesFactory: HomeModulesFactory, AboutModulesFactory {
  func makeHomeOutput() -> HomeViewOutput {
    return HomeController.controllerFromStoryboard(.home)
  }
  
  func makeAboutOutput() -> AboutViewOutput {
    return AboutController.controllerFromStoryboard(.about)
  }
}
