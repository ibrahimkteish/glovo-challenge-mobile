//
//  Tagged.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
/// All-purpose struct to wrap raw values.
/// The tag parameter that doesn’t appear to be used anywhere in this type. This is sometimes called a “phantom type”.
struct Tagged<Tag, RawValue> {
  let rawValue: RawValue
}
//Conditional conformance: swift version >= 4.1
extension Tagged: Equatable where RawValue: Equatable {
  static func == (lhs: Tagged, rhs: Tagged) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}

extension Tagged: Decodable where RawValue: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.init(rawValue: try container.decode(RawValue.self))
  }
}

extension Tagged: Encodable where RawValue: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension Tagged: Hashable where RawValue: Hashable {
  var hashValue: Int {
    return self.rawValue.hashValue
  }
}

//A type that can be initialized with an integer literal.
extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
  typealias IntegerLiteralType = RawValue.IntegerLiteralType
  
  init(integerLiteral value: IntegerLiteralType) {
    self.init(rawValue: RawValue(integerLiteral: value))
  }
}
