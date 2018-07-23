//
//  Router.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

protocol Router: Presentable {
  
  ///Add a presentable module as child presentable with animation.
  ///
  ///- Parameter module: a presentable object with animation to add over the current view presentable’s content.
  func display(_ module: Presentable?)
  
  ///Present a presentable module modally with animation.
  ///
  ///- Parameter module: a presentable object with animation to display over the current view presentable’s content.
  func present(_ module: Presentable?)
  
  ///Present a presentable module modally.
  ///
  ///- Parameter module: a presentable object to display over the current view presentable’s content.
  ///- Parameter animated: Pass true to animate the presentation; otherwise, pass false.
  func present(_ module: Presentable?, animated: Bool)
  
  ///Pushes a presentable module with animation onto the receiver’s stack and updates the display.
  ///
  ///- Parameter module: a presentable object to push onto the stack. This object cannot be a tab bar controller. If the presentable object is already on the navigation stack, this underlying system method throws an exception.
  func push(_ module: Presentable?)
  
  ///Pushes a presentable module onto the receiver’s stack and updates the display.
  ///
  ///- Parameter module: a presentable object to push onto the stack. This object cannot be a tab bar controller. If the presentable object is already on the navigation stack, this underlying system method throws an exception.
  ///- Parameter animated: Pass true to animate the transition; otherwise, pass false.
  func push(_ module: Presentable?, animated: Bool)
  
  ///Pushes a presentable module onto the receiver’s stack and updates the display.
  ///
  ///- Parameter module: a presentable object to push onto the stack. This object cannot be a tab bar controller. If the presentable object is already on the navigation stack, this underlying system method throws an exception.
  ///- Parameter animated: Pass true to animate the transition; otherwise, pass false.
  ///- Parameter completion: The block to execute after the transition finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
  
  ///Pops the top module from the navigation stack and updates the display with animation.
  func popModule()
  
  ///Pops the top module from the navigation stack and updates the display.
  ///
  ///- Parameter animated: Pass true to animate the transition; otherwise, pass false.
  func popModule(animated: Bool)
  
  ///Dismisses the module that was presented modally by the presenter with animation.
  func dismissModule()
  ///Dismisses the module that was presented modally by the presenter.
  ///- Parameter animated: Pass true to animate the transition; otherwise, pass false.
  func dismissModule(animated: Bool, completion: (() -> Void)?)
  ///Sets the root module in a navigation stack.
  ///
  ///- Parameter module: a presentable object to push onto the stack. This object cannot be a tab bar controller. If the presentable object is already on the navigation stack, this underlying system method throws an exception.
  func setRootModule(_ module: Presentable?)
  func setRootModule(_ module: Presentable?, hideBar: Bool)
  
  ///Pops all the Presentables on the stack except the root one and updates the display..
  ///
  ///- Parameter animated: Pass true to animate the transition; otherwise, pass false.
  func popToRootModule(animated: Bool)
  
}
