//
//  Operation.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxSwift

///this is what View Controllers and other objects of the app will call when they need something from the network.
///
///it is up to the Operation to execute a Request and transform received Response in something the app can understand. (Output associatedtype)
public protocol NetworkOperation {
  
  associatedtype Output
  
  /// Request to execute
  var request: Request { get }
  
  /// Execute request in passed dispatcher
  ///
  /// - Parameter dispatcher: dispatcher
  /// - Parameter completion: Outupt or Error
  func execute(in dispatcher: Dispatcher) -> Observable<Output>
}
