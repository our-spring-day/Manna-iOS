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
class AddUserViewController: UIViewController{
    var disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
        override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        createSearchBar()
    }
    func createSearchBar() {
        navigationItem.title = "아이디로 친구 추가"
        view.addSubview(searchController.searchBar)
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        searchController.searchBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        searchController.searchBar.sizeThatFits(CGSize(width: 100, height: 50))
        //searchbar고정
        self.definesPresentationContext = true
    }
    func bind() {
        searchController.searchBar.rx.text.orEmpty
            .subscribe(onNext: {text in
                print(text)
            })
            .disposed(by: disposeBag)
    }
}
extension AddUserViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //이부분에는 곧 추가가 되어야 합니다.
    }
}
