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
  private var viewModel: CountryListViewModelType!
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewModel = CountryListViewModel(with: self.searchBar.rx.text.orEmpty.asDriver())
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
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
    self.tableView.rx.modelSelected(City.self).bind(to: self.onDidSelectCity).disposed(by: self.disposeBag)
    
    //Search Bar
    self.searchBar.placeholder = "Search by country"
  }
}

