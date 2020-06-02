//
//  UserListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class UserListViewController: UIViewController {
    // MARK: - Property
    // tableView 생성
    private let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "UserListTableViewCell")
        setConstraint()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        searchController.searchBar.setImage(UIImage(named: "user.png"), for: .search, state: .normal)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        // 4. 검색 컨트롤러는 테이블의 Header에 위치시킨다
        //        self.myTableView.tableHeaderView = ""
        //여기 "" 부분에 내 프로필 넣으면 될듯
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "친구 검색"
        navigationItem.titleView = searchController.searchBar
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.title = "test"
        self.definesPresentationContext = true
    }
    // MARK: - Private
    private func setConstraint() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    //cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as? UserListTableViewCell else { return UITableViewCell() }
        return cell
    }
    //didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //프로필 디테일 뷰 띄워주면 됨
    }
}
extension UserListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        if(searchController.searchBar.text?.count)!>0{
//            searchResults.removeAll(keepingCapacity: false)
//            searchResults = items.filter { $0.name.localizedCaseInsensitiveContains(searchController.searchBar.text!) }//이건ts이런식으로 쳐도 test가 나옴
//            //searchResults = items.filter { $0.name.localizedStandardContains(searchController.searchBar.text!) }//이건 순서대로 쳐야 나옴 뭘로할지는 고민고민
//            myTableView.reloadData()
//        }else{
//            searchResults.removeAll(keepingCapacity: false)
//            searchResults = items
//            myTableView.reloadData()
//        }
    }
}
