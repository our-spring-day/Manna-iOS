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
   
    
    let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    var disposeBag = DisposeBag()
    let items = ["1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
        let items = Observable.just(
            (1...5).map { "\($0)" }
        )

        // 각 셀을 구성한다.
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element)"
            }
            .disposed(by: disposeBag)

        // 셀을 클릭했을 때 데이터 값을 출력한다.
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { item in
                print("\(item)")
            })
            .disposed(by: disposeBag)
    }
    func setConstraint() {
        self.view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "UserListTableViewCell")
    }
    
//        var disposeBag = DisposeBag()
//        let searchController = UISearchController(searchResultsController: nil)
//            override func viewDidLoad() {
//            super.viewDidLoad()
//            bind()
//            createSearchBar()
//        }
//        func createSearchBar() {
//            navigationItem.title = "아이디로 친구 추가"
//            view.addSubview(searchController.searchBar)
//            searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
//            searchController.searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//            searchController.searchBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
//            searchController.searchBar.sizeThatFits(CGSize(width: 100, height: 50))
//            //searchbar고정
//            self.definesPresentationContext = true
//        }
//        func bind() {
//            searchController.searchBar.rx.text.orEmpty
//                .subscribe(onNext: {text in
//                    print(text)
//                })
//                .disposed(by: disposeBag)
//        }
//    }
//    extension AddUserViewController: UISearchResultsUpdating{
//        func updateSearchResults(for searchController: UISearchController) {
//            //이부분에는 곧 추가가 되어야 합니다.
//        }

}
