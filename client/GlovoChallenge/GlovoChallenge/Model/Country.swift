//
//  Country.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

typealias Countries = [Country]

struct Country: Codable {
  typealias Code = Tagged<Country, String>
  let code: Code
  let name: String
}
