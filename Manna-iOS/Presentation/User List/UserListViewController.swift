//
//  UserListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import Toaster
import UIKit

class UserListViewController: UIViewController {
    var delegate: SendDataDelegate?
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = UserListViewModel()
    var selectedFriends = BehaviorRelay(value: UserTestStruct(name: "", profileImage: ""))
    let addFriendButton = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self, action: nil
    )
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSet()
        navigationBarSet()
        searchBind()
        tableBind()
        clickedAddFriendButton()
        selectedCell()
    }
    func tableViewSet() {
        tableView.do {
            view.addSubview($0)
            $0.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
            $0.rowHeight = 55
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    func navigationBarSet() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.do {
            $0.title = "친구"
            $0.hidesSearchBarWhenScrolling = true
            $0.searchController = searchController
            $0.rightBarButtonItem = addFriendButton
        }
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 검색"
            definesPresentationContext = true
        }
    }
    func searchBind() {
        searchController.searchBar.rx.text
        .orEmpty
        .distinctUntilChanged()
        .bind(to: viewModel.searchValue)
        .disposed(by: disposeBag)
    }
    func tableBind() {
        viewModel.filteredFriendsList
            .bind(to: tableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self)) {(_: Int, element: UserTestStruct, cell: UserListCell) in
                cell.idLabel.text = element.name
                cell.userImageView.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: disposeBag)
    }
    func clickedAddFriendButton() {
        addFriendButton.rx.tap
            .subscribe(onNext: {
                let addUserViewController = AddUserViewController()
                addUserViewController.do {
                    $0.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController($0, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    func selectedCell() {
        tableView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: { item in
                let detailUserViewController = DetailUserViewController()
                detailUserViewController.do {
                    $0.sendData(data: item)
                    self.definesPresentationContext = true
                    $0.modalPresentationStyle = .overFullScreen
                    $0.modalTransitionStyle = .crossDissolve
                    self.present($0, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
    }
}
