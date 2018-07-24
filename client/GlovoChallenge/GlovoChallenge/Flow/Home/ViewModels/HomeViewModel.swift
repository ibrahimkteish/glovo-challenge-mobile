//
//  HomeViewModel.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInputType {
  var onViewDidLoad: PublishSubject<Void> { get }
}

protocol HomeViewModelOutputType {
  var data: Driver<Cities> { get }
}

protocol HomeViewModelType: HomeViewModelInputType, HomeViewModelOutputType {
  var input: HomeViewModelInputType { get }
  var output: HomeViewModelOutputType { get }
}

final class HomeViewModel: HomeViewModelType {
  
  var input: HomeViewModelInputType { return self }
  var output: HomeViewModelOutputType { return self }
  
  private let disposeBag = DisposeBag()
  
  //MARK: Input
  let onViewDidLoad: PublishSubject<Void> = .init()
  
  //MARK: Output
  let data: Driver<Cities>
  
  init() {

    self.data = Current.apiService.citiesNetworkOperation()
      .execute(in: NetworkDispatcherFactory.development)
      .startWith(OfflineData.cities())
      .observeOn(MainScheduler.instance)
      .asDriver { (error) -> SharedSequence<DriverSharingStrategy, Cities> in
        return Driver.just(OfflineData.cities())
    }
  }
}
