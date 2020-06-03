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
    let screensize: CGRect = UIScreen.main.bounds
    let addFriendButtonItem = UIBarButtonItem(image: UIImage(named: "searchimage"), style: .done, target: nil, action: #selector(done))
    let searchController = UISearchController(searchResultsController: nil)
    let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "UserListTableViewCell")
        setConstraint()
        createSearchBar()
        setNavigationBar()
    }
    func setConstraint() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    func createSearchBar() {
        view.addSubview(searchController.searchBar)
        searchController.searchBar.setImage(UIImage(named: "user.png"), for: .search, state: .normal)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        //        self.myTableView.tableHeaderView = "내 프로필 정보" 추후 추가 예정
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "친구 검색"
    }
    //navigationtitle 아래에 searchbar가 위치할 수 있게 해줌
    func setNavigationBar(){
        //네비게이션바의 타이틀이 왼쪽에 위치하게끔 String이 아닌 Label로 대체(바뀔 수 있음 계획한 디자인대로 한 것)
        let userListNavigationTitleLabel = UILabel()
        userListNavigationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userListNavigationTitleLabel.text = "친구"
        userListNavigationTitleLabel.textAlignment = .left
        navigationItem.titleView = userListNavigationTitleLabel
        if let navigationBar = navigationController?.navigationBar {

            userListNavigationTitleLabel.widthAnchor.constraint(equalTo: navigationBar.widthAnchor, constant: -100).isActive = true
        }
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = addFriendButtonItem
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.hidesBarsOnSwipe = true//이거 검색창까지 완벽하게 안없어짐 해결 해야됨
        
    }
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
}
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    //set cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screensize.height/13
    }
    //numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
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
        //이부분에 대한 코드는 일단 보류 삭제x
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
