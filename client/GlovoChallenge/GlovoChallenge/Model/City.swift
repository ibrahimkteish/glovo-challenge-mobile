//
//  City.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxDataSources

typealias Cities = [City]

struct City: Codable, Equatable, IdentifiableType {
  
  typealias Identity = Code

  var identity: City.Code {
    return code
  }
  
  typealias Code = Tagged<City, String>
  let code: Code
  let countryCode: Country.Code
  let name: String
  let workingArea: [String]
  
  enum CodingKeys: String, CodingKey {
    case workingArea = "working_area"
    case code, name
    case countryCode = "country_code"
  }
}
