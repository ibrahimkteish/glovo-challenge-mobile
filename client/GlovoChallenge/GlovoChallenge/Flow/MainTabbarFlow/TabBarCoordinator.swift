//
//  TabBarCoordinator.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxSwift

final class TabbarCoordinator: BaseCoordinator {
  
  private let disposeBag = DisposeBag()
  
  private let tabbarView: TabBarViewOutput
  private let coordinatorFactory: CoordinatorFactory
  
  init(tabbarView: TabBarViewOutput, coordinatorFactory: CoordinatorFactory) {
    self.tabbarView = tabbarView
    self.coordinatorFactory = coordinatorFactory
  }
  
  override func start() {
    tabbarView
      .onViewDidLoad
      .subscribe(onNext: { [weak self] (navController) in
        if navController.viewControllers.isEmpty == true {
          guard let activeUsersCoordinator = self?.coordinatorFactory.makeHomeCoordinator(navigationController: navController) else { return }
          activeUsersCoordinator.start()
          self?.addDependency(activeUsersCoordinator)
        }
      }).disposed(by: disposeBag)
    
    tabbarView
      .onHome
      .subscribe(onNext: { [weak self] (navController) in
        if navController.viewControllers.isEmpty == true {
          guard let activeUsersCoordinator = self?.coordinatorFactory.makeHomeCoordinator(navigationController: navController) else { return }
          activeUsersCoordinator.start()
          self?.addDependency(activeUsersCoordinator)
        }
      }).disposed(by: disposeBag)
    
    tabbarView
      .onViewDidLoad
      .subscribe(onNext: { [weak self] (navController) in
        if navController.viewControllers.isEmpty == true {
          guard let activeUsersCoordinator = self?.coordinatorFactory.makeAboutCoordinator(navigationController: navController) else { return }
          activeUsersCoordinator.start()
          self?.addDependency(activeUsersCoordinator)
        }
      }).disposed(by: disposeBag)
  }
}
