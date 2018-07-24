//
//  RouterImp.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import UIKit

final class RouterImp: NSObject, Router {
  
  private weak var rootController: UINavigationController?
  private var completions: [UIViewController : () -> Void]
  
  init(rootController: UINavigationController) {
    self.rootController = rootController
    completions = [:]
  }
  
  func toPresent() -> UIViewController? {
    return rootController
  }
  
  func display(_ module: Presentable?) {
    self.rootController?.topViewController?.GCAddChildViewController((module?.toPresent())!)
  }
  
  func present(_ module: Presentable?) {
    present(module, animated: true)
  }
  
  func present(_ module: Presentable?, animated: Bool) {
    guard let controller = module?.toPresent() else { return }
    if let presented = rootController?.presentedViewController {
      presented.present(controller, animated: animated, completion: nil)
      return
    }
    rootController?.definesPresentationContext = false
    controller.modalPresentationStyle = .fullScreen
    rootController?.present(controller, animated: animated, completion: nil)
  }
  
  func presentOverCurrentContext(_ module: Presentable?, animated: Bool) {
    guard let controller = module?.toPresent() else { return }
    if let presented = rootController?.presentedViewController {
      presented.present(controller, animated: animated, completion: nil)
      return
    }
    rootController?.definesPresentationContext = true
    controller.modalPresentationStyle = .overCurrentContext
    controller.view.backgroundColor = .clear
    rootController?.present(controller, animated: animated, completion: nil)
  }
  
  func dismissModule() {
    dismissModule(animated: true, completion: nil)
  }
  
  func dismissModule(animated: Bool, completion: (() -> Void)?) {
    if let presented = rootController?.presentedViewController {
      presented.dismiss(animated: animated, completion: completion)
      return
    }
    rootController?.dismiss(animated: animated, completion: completion)
  }
  
  func push(_ module: Presentable?) {
    push(module, animated: true)
  }
  
  func push(_ module: Presentable?, animated: Bool) {
    push(module, animated: animated, completion: nil)
  }
  
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
    guard
      let controller = module?.toPresent(),
      (controller is UINavigationController == false)
      else { assertionFailure("Deprecated push UINavigationController."); return }
    
    if let completion = completion {
      completions[controller] = completion
    }
    rootController?.pushViewController(controller, animated: animated)
    completions[controller] = completion
  }
  
  func popModule() {
    popModule(animated: true)
  }
  
  func popModule(animated: Bool) {
    if let controller = rootController?.popViewController(animated: animated) {
      runCompletion(for: controller)
    }
  }
  
  func setRootModule(_ module: Presentable?) {
    setRootModule(module, hideBar: false)
  }
  
  func setRootModule(_ module: Presentable?, hideBar: Bool) {
    guard let controller = module?.toPresent() else { return }
    rootController?.setViewControllers([controller], animated: false)
    rootController?.isNavigationBarHidden = hideBar
  }
  
  func popToRootModule(animated: Bool) {
    if let controllers = rootController?.popToRootViewController(animated: animated) {
      controllers.forEach { controller in
        runCompletion(for: controller)
      }
    }
  }
  
  private func runCompletion(for controller: UIViewController) {
    guard let completion = completions[controller] else { return }
    completion()
    completions.removeValue(forKey: controller)
  }
}
