//
//  NSObject.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

extension NSObject {
  class var nameOfClass: String {
    return NSStringFromClass(self).components(separatedBy: ".").last!
  }
}
