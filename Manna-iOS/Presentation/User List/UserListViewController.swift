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
    let searchController = UISearchController(searchResultsController: nil)
    let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    var disposBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
        createSearchBar()
        setNavigationBar()
        searchController.searchBar.rx.text.orEmpty
            .subscribe(onNext: {text in
                print(text)
            })
        .disposed(by: disposBag)
    }
    func setConstraint() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "UserListTableViewCell")
    }
    func createSearchBar() {
        view.addSubview(searchController.searchBar)
        searchController.searchBar.setImage(UIImage(named: "user.png"), for: .search, state: .normal)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "친구 검색"
    }
    func setNavigationBar(){
        let userListNavigationTitleLabel = UILabel()
        userListNavigationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userListNavigationTitleLabel.text = "친구"
        userListNavigationTitleLabel.textAlignment = .left
        navigationItem.titleView = userListNavigationTitleLabel
        if let navigationBar = navigationController?.navigationBar {
            userListNavigationTitleLabel.widthAnchor.constraint(equalTo: navigationBar.widthAnchor, constant: -100).isActive = true
        }
        let addFriendButtonItem = UIBarButtonItem(image: UIImage(named: "searchimage"), style: .plain, target: self, action: #selector(done))
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = addFriendButtonItem
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.hidesBarsOnSwipe = true//이거 검색창까지 완벽하게 안없어짐 해결 해야됨
    }
    @objc func done() {
        let addUserViewController = AddUserViewController()
        self.navigationController?.pushViewController(addUserViewController, animated: true)
    }
}
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    //set cell height(다른 메신져 앱을 참고했습니다.)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screensize.height/13
    }
    //numberOfRowsInSection(현재는 예시로 30명만 후에 수정될 부분)
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
    //trailingSwipeActions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
        })
        //            return UISwipeActionsConfiguration(actions:[deleteAction,shareAction])
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
