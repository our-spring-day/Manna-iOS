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
    var disposeBag = DisposeBag()
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var addFriendButton: UIBarButtonItem?
    var viewModel = UserListViewModel()
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
        view.addSubview(tableView)
        tableView.do {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
            $0.separatorStyle = .singleLine
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 160
        }
    }
    func navigationBarSet() {
        navigationItem.title = "친구"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 검색"
            navigationItem.searchController = $0
            definesPresentationContext = true
        }
        self.addFriendButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self, action: nil)
        navigationItem.rightBarButtonItem = addFriendButton
    }
    func bind() {
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debug()
            .bind(to: viewModel.searchValue)
            .disposed(by: disposeBag)
        // 급해서 기본 cell을 사용했네요 추후에 커스텀 셀로 적용 해야합니다.
        viewModel.filteredFriendsList
            .bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) {(_: Int, element: String, cell: UITableViewCell) in
                cell.textLabel!.text = element
        }.disposed(by: disposeBag)
    }
    func clickedAddFriendButton() {
        addFriendButton?.rx.tap
            .subscribe(onNext: {
                let addUserViewController = AddUserViewController()
                addUserViewController.modalPresentationStyle = .overFullScreen
                self.navigationController?.pushViewController(addUserViewController, animated: true)
            }).disposed(by: disposeBag)
    }
    func clickedCell() {
        tableView.rx.modelSelected(String.self)
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
