//
//  ModulesFactoryImp.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

final class ModulesFactoryImp: HomeModulesFactory, AboutModulesFactory {
  
  func makeAboutOutput() -> AboutViewOutput {
    return AboutController.controllerFromStoryboard(.about)
  }

  func makeCountryListOutput() -> CountriesListViewOutput {
      return CountriesListContrioller.controllerFromStoryboard(.home)
  }

  func makeHomeOutput() -> HomeViewOutput {
    return HomeController.controllerFromStoryboard(.home)
  }
}
