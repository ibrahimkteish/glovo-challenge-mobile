//
//  BaseCoordinator.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
/// Base coornator class to which every coordinator is going to
/// inherit form it. it has the minimum fuctionality that any coordinator should have.
class BaseCoordinator: Coordinator {
  // MARK: Properties
  var childCoordinators: [Coordinator] = []
  // MARK: Coordinator protocol implemantation
  func start() {
    fatalError("the class \(self) should override the start func")
  }
  
  // MARK: Methods
  
  // Add only unique object
  func addDependency(_ coordinator: Coordinator) {
    for element in childCoordinators {
      if element === coordinator { return } // swiftlint:disable:this for_where
    }
    childCoordinators.append(coordinator)
  }
  
  func removeDependency(_ coordinator: Coordinator?) {
    guard childCoordinators.isEmpty == false, let coordinator = coordinator else {
      return
    }
    
    for (index, element) in childCoordinators.enumerated() {
      if element === coordinator { // swiftlint:disable:this for_where
        childCoordinators.remove(at: index)
        break
      }
    }
  }
}

