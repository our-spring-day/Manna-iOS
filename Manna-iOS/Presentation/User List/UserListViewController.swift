//
//  UserListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class UserListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var delegate: SendDataDelegate?
    var tableView = FriendsListTableView()
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = UserListViewModel()
    var selectedFriends = BehaviorRelay(value: UserTestStruct(name: "", profileImage: "", checkedFlag: 0))
    let addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    let screenSize: CGRect = UIScreen.main.bounds
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    func attribute() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.do {
            $0.title = "친구"
            $0.hidesSearchBarWhenScrolling = true
            $0.searchController = searchController
            $0.rightBarButtonItem = addFriendButton
            $0.rightBarButtonItem?.tintColor = UIColor(named: "default")
        }
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 검색"
            $0.searchBar.tintColor = UIColor(named: "default")
            definesPresentationContext = true
        }
    }
    
    func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind() {
        viewModel.filteredFriendsList
            .bind(to: tableView.baseTableView.rx.items(cellIdentifier: UserListCell.identifier,cellType: UserListCell.self))
            {(_: Int, element: UserTestStruct, cell: UserListCell) in
                cell.idLabel.text = element.name
                cell.userImageView.image = UIImage(named: "\(element.profileImage)")
                cell.checkBox.isHidden = true
        }
        .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.searchValue)
            .disposed(by: disposeBag)
        
        self.addFriendButton.rx.tap
            .subscribe(onNext: {
                let addUserViewController = AddUserViewController()
                addUserViewController.do {
                    $0.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController($0, animated: true)
                }
            }).disposed(by: disposeBag)
        
        tableView.baseTableView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: { item in
                let detailUserViewController = DetailUserViewController()
                detailUserViewController.do {
                    detailUserViewController.userImage.image = UIImage(named: item.profileImage)
                    detailUserViewController.userID.text = item.name
                    self.definesPresentationContext = true
                    $0.modalPresentationStyle = .overFullScreen
                    $0.modalTransitionStyle = .crossDissolve
                    self.present($0, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        tableView.baseTableView.rx.itemDeleted
            .bind(to: viewModel.deletedFriends)
            .disposed(by: disposeBag)
    }
}
