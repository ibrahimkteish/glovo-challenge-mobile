//
//  MapRequests.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

//MARK: Map Requests
enum MapRequests: Request {
  
  case countries
  case cities
  case city(code: String)

  var path: String {
    switch self {
    case .countries:
      return "countries"
    case .cities:
      return "cities"
    case let .city(code):
      return "cities" + "/" + code
    }
  }
}
