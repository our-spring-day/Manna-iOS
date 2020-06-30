//
//  AddUserViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/03.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

//새로운 친구를 찾으려 검색할 때 view
class AddUserViewController: UIViewController {
    let viewModel = AddUserViewModel()
    let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBarSet()
        bind()
    }
    func navigationBarSet() {
        navigationItem.title = "ID로 친구 추가"
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 검색"
            navigationItem.searchController = $0
            definesPresentationContext = true
        }
    }
    func bind() {
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debug()
            .bind(to: viewModel.searchValue)
            .disposed(by: disposeBag)
    }
}
