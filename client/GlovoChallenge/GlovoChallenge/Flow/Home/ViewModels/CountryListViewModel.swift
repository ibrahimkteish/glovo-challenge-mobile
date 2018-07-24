//
//  CountryListViewModel.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CountryListViewModelInputType {
  var onViewDidLoad: PublishSubject<Void> { get }
  var search: Driver<String> { get }
}

protocol CountryListViewModelOutputType {
  var filteredData: Driver<[CountriesSection]> { get }
}

protocol CountryListViewModelType: CountryListViewModelInputType, CountryListViewModelOutputType {
  var input: CountryListViewModelInputType { get }
  var output: CountryListViewModelOutputType { get }
}

final class CountryListViewModel: CountryListViewModelType {
  
  var input: CountryListViewModelInputType { return self }
  var output: CountryListViewModelOutputType { return self }
  
  private let disposeBag = DisposeBag()
  
  //MARK: Input
  let onViewDidLoad: PublishSubject<Void> = .init()
  let search: Driver<String>
  
  //MARK: Output
  let filteredData: Driver<[CountriesSection]>
  
  init(with searchDriver: Driver<String>) {
    self.search = searchDriver
    
    let countries = Current.apiService.countriesNetworkOperation()
      .execute(in: NetworkDispatcherFactory.development)
      .observeOn(MainScheduler.instance)
      .startWith(OfflineData.countries())
      .asDriver { (error) -> SharedSequence<DriverSharingStrategy, Countries> in
        return Driver.just(OfflineData.countries())
    }
    
    let cities = Current.apiService.citiesNetworkOperation()
      .execute(in: NetworkDispatcherFactory.development)
      .observeOn(MainScheduler.instance)
      .startWith(OfflineData.cities())
      .asDriver { (error) -> SharedSequence<DriverSharingStrategy, Cities> in
        
        return Driver.just(OfflineData.cities())
    }
    
    let combined = Driver.combineLatest(countries, cities) { (countries, cities) -> [CountriesSection] in

      var finalSections = countries.map { CountriesSection(name: $0.name, code:$0.code, items: []) }
      
      //Sorry: probably we need better than this
      cities.forEach({ (city) in
        countries.forEach({ (country) in
          if city.countryCode == country.code {
            let index = finalSections.index(where: { $0.code == country.code })!
            let section = finalSections[index.advanced(by: 0)]
            let newItems = section.items + [city]
            let newObj = CountriesSection(name: section.name, code: section.code, items: newItems)
            finalSections = (finalSections |> set(Genereic<CountriesSection>.map(index.advanced(by: 0)), newObj)) // preserve immutability
          }
        })
      })
      return finalSections
      }
  
    self.filteredData = Driver.combineLatest(combined, search, resultSelector: { (countries, filterInput) -> [CountriesSection] in
      if filterInput.isEmpty { return countries }
      return countries.filter { $0.name.contains(filterInput) }

    })
  }
}


import RxDataSources

struct CountriesSection: Equatable {
  static func == (lhs: CountriesSection, rhs: CountriesSection) -> Bool {
    return lhs.name == rhs.name
  }
  
  let name: String
  let code: Country.Code
  var items: Cities
}

extension CountriesSection : AnimatableSectionModelType {
  typealias Item = City
  
  var identity: String {
    return name
  }
  
  init(original: CountriesSection, items: Cities) {
    self = original
    self.items = items
  }
}
