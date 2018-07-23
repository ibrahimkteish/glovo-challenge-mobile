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
import RxCocoa
import RxDataSources

protocol CountriesListViewOutput: BaseView {
  var onDidSelectCity: PublishSubject<City> { get }
}

final class CountriesListContrioller: UIViewController, CountriesListViewOutput {
  let onDidSelectCity: PublishSubject<City> = .init()
  private let disposeBag = DisposeBag()
  private let viewModel: CountryListViewModelType = CountryListViewModel()
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViewAndBinding()
  }
  
  private func setupViewAndBinding() {
    
    //TableView
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    let dataSource = RxTableViewSectionedAnimatedDataSource<CountriesSection>(
      configureCell: { ds, tv, ip, item in
        let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = item.name
        
        return cell
    },
      titleForHeaderInSection: { ds, index in
        return ds.sectionModels[index].name
    })
    self.viewModel
      .output
      .filteredData
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
    self.tableView.rx.modelSelected(City.self).bind(to: self.onDidSelectCity).disposed(by: self.disposeBag)
    
    //SeacrBar
    self.searchBar.rx
      .text
      .orEmpty
      .throttle(0.3, scheduler: MainScheduler.instance)
      .debounce(0.3, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .bind(to: self.viewModel.input.search)
      .disposed(by: self.disposeBag)
    
    self.searchBar.placeholder = "Search by country"
    
  }
}

