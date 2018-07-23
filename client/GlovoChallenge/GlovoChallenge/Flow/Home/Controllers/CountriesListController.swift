//
//  CountriesListController.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

protocol CountriesListViewOutput: BaseView {
  var onDidSelectCity: PublishSubject<City> { get }
}

final class CountriesListContrioller: UIViewController, CountriesListViewOutput {
  let onDidSelectCity: PublishSubject<City> = .init()
  private let disposeBag = DisposeBag()
}

