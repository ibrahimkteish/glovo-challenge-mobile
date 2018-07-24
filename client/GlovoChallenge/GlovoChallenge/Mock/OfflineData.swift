//
//  OfflineData.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/24/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

final class OfflineData {
  static func cities() -> Cities {
    let filePath = Bundle.main.path(forResource: "cities", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
    let cities = try! JSONDecoder().decode(Cities.self, from: data)
    return cities
  }
  
  static func countries() -> Countries {
    let filePath = Bundle.main.path(forResource: "countries", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
    let cities = try! JSONDecoder().decode(Countries.self, from: data)
    return cities
  }
}
