//
//  NotiListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NotiListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let inviteFriendsViewModel = InviteFriendsViewModel()
    let checkedMemberArray: BehaviorRelay<[UserTestStruct]> = BehaviorRelay(value: [])
    let userListViewModel = FriendListViewModel()
    let layoutValue = UICollectionViewFlowLayout()
    var tableView = FriendListTableView()
    var collectionView = FriendsListCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    func attribute() {
        view.do {
            $0.backgroundColor = .white
        }
    }
    
    func layout() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func bind() {
        //tableView set
        inviteFriendsViewModel.outputs.friendList
            .bind(to: tableView.baseTableView.rx.items(cellIdentifier: FriendListCell.identifier, cellType: FriendListCell.self)) { (_: Int, element: UserTestStruct, cell: FriendListCell) in
                cell.friendIdLabel.text = element.name
                cell.friendImageView.image = UIImage(named: "\(element.profileImage)")
                if element.checkedFlag == 1 {
                    cell.checkBoxImageView.image = UIImage(named: "checked")
                } else {
                    cell.checkBoxImageView.image = UIImage(named: "unchecked")
                }
        }.disposed(by: disposeBag)
        
        //collectionView set
        inviteFriendsViewModel.outputs.checkedFriendList
            .bind(to: self.collectionView.baseCollectionView.rx.items(cellIdentifier: CheckedFriendCell.identifier, cellType: CheckedFriendCell.self)) { (_: Int, element: UserTestStruct, cell: CheckedFriendCell) in
                cell.profileImage.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: self.disposeBag)
        
        //checked Friend at tableView
        tableView.baseTableView.rx.itemSelected
            .bind(to: inviteFriendsViewModel.inputs.indexFromTableView)
            .disposed(by: disposeBag)
        
        //selected Friend at collectionView
        collectionView.baseCollectionView.rx.modelSelected(UserTestStruct.self)
        .debug()
            .bind(to: inviteFriendsViewModel.inputs.itemFromCollectionView)
            .disposed(by: disposeBag)
        
        //dynamic tableView's height by checkedFriend exist
        inviteFriendsViewModel.outputs.checkedFriendList
            .map { $0.count }
            .filter { $0 <= 1 }
            .subscribe(onNext: { count in
                if count == 0 {
                    self.tableView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    }
                } else { self.tableView.snp.updateConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
                    }
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
    }
}
