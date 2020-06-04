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
class AddUserViewController: UIViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //이부분에는 곧 추가가 되어야 합니다.
    }
    var disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = searchController.searchBar
        navigationItem.title = "아이디로 친구 추가"
        view.addSubview(searchBar)
        //searchbar고정
        self.definesPresentationContext = true
        searchBar.rx.text.orEmpty
            .subscribe(onNext: {text in
                print(text)
            })
    }
}
