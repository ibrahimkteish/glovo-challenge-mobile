//
//  TabbarController.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol TabBarViewOutput: BaseView {
  var onViewDidLoad: PublishSubject<UINavigationController> { get }
  var onHome: PublishSubject<UINavigationController> { get }
  var onAbout: PublishSubject<UINavigationController> { get }
}

final class TabbarController: UITabBarController, UITabBarControllerDelegate, TabBarViewOutput {
  let onViewDidLoad: PublishSubject<UINavigationController> = .init()
  let onHome: PublishSubject<UINavigationController> = .init()
  let onAbout: PublishSubject<UINavigationController> = .init()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    if let controller = customizableViewControllers?.first as? UINavigationController {
      self.onViewDidLoad.onNext(controller)
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
    
    if selectedIndex == 0 {
      self.onHome.onNext(controller)
    } else if selectedIndex == 1 {
      self.onAbout.onNext(controller)
    }
  }
}

