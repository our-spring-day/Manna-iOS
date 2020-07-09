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
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = UserListViewModel()
    let detailView = DetailUserViewController()
    var selectedFriends = BehaviorRelay(value: UserTestStruct(name: "", profileImage: ""))
    let addFriendButton = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self, action: nil
    )
    var testValue: BehaviorRelay<UserTestStruct> = BehaviorRelay(value: UserTestStruct(name: "", profileImage: ""))
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
        bind()
        clickedCell()
        clickedAddFriendButton()
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
    func bind() {
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.searchValue)
            .disposed(by: disposeBag)
        viewModel.filteredFriendsList
            .bind(to: tableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self)) {(_: Int, element: UserTestStruct, cell: UserListCell) in
                cell.idLabel.text = element.name
                cell.imageView?.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: disposeBag)
    }
    func clickedAddFriendButton() {
        addFriendButton.rx.tap
            .subscribe(onNext: {
                let addUserViewController = AddUserViewController()
                addUserViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(addUserViewController, animated: true)
            }).disposed(by: disposeBag)
    }
    func clickedCell() {
        tableView.rx.modelSelected(UserTestStruct.self)
            .debug()
            .bind(to: self.detailView.userDetailInfo)
            //            .subscribe(onNext: { str in
            //                print(type(of: str))
            ////                self.testValue = str.
            //                print(type(of: self.testValue))
            //            })
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: { _ in
                let detailUserViewController = DetailUserViewController()
                self.definesPresentationContext = true
                detailUserViewController.modalPresentationStyle = .overFullScreen
                detailUserViewController.modalTransitionStyle = .crossDissolve
                self.present(detailUserViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
