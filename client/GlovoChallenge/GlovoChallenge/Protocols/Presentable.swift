//
//  Presentable.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import UIKit

/// This protocol will be responsible for presenting any module later on,
/// so we dont deal with UIViewController directly
protocol Presentable {
  func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
  func toPresent() -> UIViewController? {
    return self
  }
}
