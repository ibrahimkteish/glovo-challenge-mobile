//
//  UIView.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import UIKit

extension UIView {
  func fillSafeInSuperview() {
    guard let superview = self.superview else { return }
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
      trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
      topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
      bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
      ])
  }
}
