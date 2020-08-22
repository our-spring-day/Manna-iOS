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
    let layoutValue = UICollectionViewFlowLayout()
    
//    var collectionView = FriendsListCollectionView()
    var scrollview = UIScrollView()
    var textField = UITextField()
    var tableView = FriendListTableView()
    
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
        scrollview.do {
            $0.backgroundColor = .red
        }
        textField.do {
            $0.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            $0.backgroundColor = .lightGray
        }
    }
    
    func layout() {
//        view.addSubview(collectionView)
        view.addSubview(scrollview)
        view.addSubview(textField)
        view.addSubview(tableView)
        
//        collectionView.snp.makeConstraints {
//            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
        scrollview.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        textField.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(scrollview.snp.bottom)
            $0.width.equalTo(view.safeAreaLayoutGuide).offset(-50)
            $0.height.equalTo(40)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
//        inviteFriendsViewModel.outputs.checkedFriendList
//            .bind(to: self.collectionView.baseCollectionView.rx.items(cellIdentifier: CheckedFriendCell.identifier, cellType: CheckedFriendCell.self)) { (_: Int, element: UserTestStruct, cell: CheckedFriendCell) in
//                cell.profileImage.image = UIImage(named: "\(element.profileImage)")
//                UIView.animate(withDuration: 0.3) {
//                    self.view.layoutIfNeeded()
//                }
//        }.disposed(by: self.disposeBag)
//
        //checked Friend at tableView
        tableView.baseTableView.rx.modelSelected(UserTestStruct.self)
            .bind(to: inviteFriendsViewModel.inputs.itemFromTableView)
            .disposed(by: disposeBag)
        
        //selected Friend at collectionView
//        collectionView.baseCollectionView.rx.modelSelected(UserTestStruct.self)
//            .bind(to: inviteFriendsViewModel.inputs.itemFromCollectionView)
//            .disposed(by: disposeBag)
//
        //searchID bind
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: inviteFriendsViewModel.inputs.searchedFriendID)
            .disposed(by: disposeBag)
        
        //dynamic tableView's height by checkedFriend exist
        inviteFriendsViewModel.outputs.checkedFriendList
            .skip(1)
            .map { $0.count }
            .filter { $0 <= 1 }
            .subscribe(onNext: { count in
                if count < 1 {
                    self.textField.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    }
                    self.tableView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
                    }
                } else {
                    self.textField.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(150)
                    }
                    self.tableView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(200)
                    }
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
        
        //keyboard hide when tableView,collectionView scrolling
//        Observable.of(tableView.baseTableView.rx.didScroll.asObservable(), collectionView.baseCollectionView.rx.didScroll.asObservable()).merge()
//            .subscribe(onNext: {
//                self.view.endEditing(true)
//            }).disposed(by: disposeBag)
    }
}
