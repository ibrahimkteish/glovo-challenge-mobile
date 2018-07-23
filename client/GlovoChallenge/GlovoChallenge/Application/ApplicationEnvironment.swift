//
//  ApplicationEnvironment.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

struct ApplicationEnvironment {
  var apiService: APIService
}

extension ApplicationEnvironment {
  static let mock = ApplicationEnvironment(apiService: APIService(
    countriesNetworkOperation: {  CountriesNetworkOperation(response: { (request, dispatcher) in ResponseHandler<Countries>.execute(request, in: dispatcher) })},
    citiesNetworkOperation: {  CitiesNetworkOperation(response: { (request, dispatcher) in ResponseHandler<Cities>.execute(request, in: dispatcher) })},
    cityNetworkOperation: { cityCode in CityNetworkOperation(code: cityCode, response: { (request, dispatcher) in ResponseHandler<City>.execute(request, in: dispatcher) })}
    )
  )
}

var Current = ApplicationEnvironment(apiService: APIService(
  countriesNetworkOperation: {  CountriesNetworkOperation(response: { (request, dispatcher) in ResponseHandler<Countries>.execute(request, in: dispatcher) })},
  citiesNetworkOperation: {  CitiesNetworkOperation(response: { (request, dispatcher) in ResponseHandler<Cities>.execute(request, in: dispatcher) })},
  cityNetworkOperation: { cityCode in CityNetworkOperation(code: cityCode, response: { (request, dispatcher) in ResponseHandler<City>.execute(request, in: dispatcher) })}
))
