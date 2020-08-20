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

class FriendListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var friendListTableView = FriendListTableView()
    let friendListViewModel = FriendListViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    let addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - attribute
    
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
    
    // MARK: - Layout
    
    func layout() {
        view.addSubview(friendListTableView)
        
        friendListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    func bind() {
        //테이블뷰 세팅
        FriendListViewModel.self.myFriendList
            .bind(to: friendListTableView.baseTableView.rx.items(cellIdentifier: FriendListCell.identifier, cellType: FriendListCell.self)) { (_: Int, element: User, cell: FriendListCell) in
                cell.friendIdLabel.text = element.name
                cell.friendImageView.image = UIImage(named: "\(element.profileImage)")
                cell.checkBoxImageView.isHidden = true
        }.disposed(by: disposeBag)
        
        //searchBar 위에 text로 teableView 실시간 필터링
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: friendListViewModel.inputs.searchedFriendID)
            .disposed(by: disposeBag)
        
        //addFriendButton 클릭 시
        self.addFriendButton.rx.tap
            .subscribe(onNext: {
                let addUserViewController = AddUserViewController()
                addUserViewController.do {
                    $0.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController($0, animated: true)
                }
            }).disposed(by: disposeBag)
        
        //tableView 위 item 클릭 시
        friendListTableView.baseTableView.rx.modelSelected(User.self)
            .subscribe(onNext: { item in
                let detailUserViewController = FriendDetailViewController()
                detailUserViewController.do {
                    detailUserViewController.selectedFriend = item
                    self.definesPresentationContext = true
                    $0.modalPresentationStyle = .overFullScreen
                    $0.modalTransitionStyle = .crossDissolve
                    self.present($0, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        //tableView 위 item 삭제 시
        friendListTableView.baseTableView.rx.itemDeleted
            .map { FriendListViewModel.self.myFriendList.value[$0[1]] }
            .bind(to: friendListViewModel.inputs.deletedFriend)
            .disposed(by: disposeBag)
        
    }
}
