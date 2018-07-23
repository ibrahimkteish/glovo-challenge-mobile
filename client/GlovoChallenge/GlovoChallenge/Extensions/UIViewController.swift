//
//  UIViewController.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import UIKit

extension UIViewController {
  
  /// Add child view controller to the self controller
  ///
  /// - Parameter child: the child view controller
  /// - Parameter metrics: Autolayout metrics for top margin only
  func GCAddChildViewController(_ child: UIViewController, metrics: [String:Any] = ["topMargin": 0]) {
    
    child.willMove(toParentViewController: self)
    addChildViewController(child)
    child.beginAppearanceTransition(true, animated: true)
    view.addSubview(child.view)
    child.endAppearanceTransition()
    child.view.translatesAutoresizingMaskIntoConstraints = false
    
    child.view.fillSafeInSuperview()
    child.didMove(toParentViewController: self)
    
  }
  
  /// Remove child view controller from the self controller
  ///
  /// - Parameter child: the child view controller
  func GCRemoveChildViewController(_ child: UIViewController) {
    
    child.willMove(toParentViewController: nil)
    child.beginAppearanceTransition(false, animated: true)
    child.view.removeFromSuperview()
    child.endAppearanceTransition()
    child.removeFromParentViewController()
    child.didMove(toParentViewController: nil)
  }
}
