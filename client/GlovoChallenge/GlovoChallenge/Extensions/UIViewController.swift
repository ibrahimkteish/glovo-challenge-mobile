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


extension UIViewController {
  
  private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
    return storyboard.instantiateViewController(withIdentifier: identifier) as! T // swiftlint:disable:this force_cast
  }
  
  class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
    return self.instantiateControllerInStoryboard(storyboard, identifier: identifier)
  }
  
  class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
    return self.controllerInStoryboard(storyboard, identifier: self.nameOfClass)
  }
  
  class func controllerFromStoryboard(_ storyboard: Storyboards) -> Self {
    return self.controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: self.nameOfClass)
  }
}
