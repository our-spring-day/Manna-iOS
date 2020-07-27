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
    
    let userListViewModel = UserListViewModel()
    var checkedMemberArray: BehaviorRelay<[UserTestStruct]> = BehaviorRelay(value: [])
    let screenSize: CGRect = UIScreen.main.bounds
    var collectionView: UICollectionView!
    let layoutValue = UICollectionViewFlowLayout()
    lazy var itemObservable = BehaviorRelay(value: [UserTestStruct]())
    var tableView = FriendsListTableView()
    
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
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutValue)
        collectionView.do {
            $0.backgroundColor = .white
            $0.register(CheckedFriendCell.self, forCellWithReuseIdentifier: CheckedFriendCell.identifier)
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
        layoutValue.do {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
            $0.itemSize = CGSize(width: 50, height: 50)
            $0.scrollDirection = .horizontal
        }
    }
    
    func layout() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
//            $0.top.equalTo(collectionView.snp.bottom)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(70)
            $0.width.equalTo(400)
            $0.height.equalTo(100)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    func bind() {
        //tableView set
        userListViewModel.filteredFriendsList
            .bind(to: tableView.baseTableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self))
            {(_: Int, element: UserTestStruct, cell: UserListCell) in
                cell.idLabel.text = element.name
                cell.userImageView.image = UIImage(named: "\(element.profileImage)")
                if element.checkedFlag == 1 {
                    cell.checkBox.image = UIImage(named: "checked")
                } else {
                    cell.checkBox.image = UIImage(named: "unchecked")
                }
        }.disposed(by: disposeBag)
        
        //collectionView set
        checkedMemberArray
            .bind(to: self.collectionView.rx.items(cellIdentifier: CheckedFriendCell.identifier, cellType: CheckedFriendCell.self)){
                (index: Int, element: UserTestStruct, cell: CheckedFriendCell) in
                cell.profileImage.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: self.disposeBag)
        
        //checkedMemberArray set with tableView
        Observable
            .zip(tableView.baseTableView.rx.itemSelected,tableView.baseTableView.rx.modelSelected(UserTestStruct.self))
            .bind{ [unowned self] index, item in
                //append,remove from checkList
                var checkedValue = self.checkedMemberArray.value
                if checkedValue.contains(where: { $0.name == item.name }) {
                    let MMIndex = checkedValue.firstIndex(where: {$0.name == item.name})!
                    checkedValue.remove(at: MMIndex)
                    self.checkedMemberArray.accept(checkedValue)
                } else {
                    checkedValue.insert(item, at: 0)
                    self.checkedMemberArray.accept(checkedValue)
                }
                //flag set
                var flagValue = self.userListViewModel.filteredFriendsList.value
                if flagValue[index[1]].checkedFlag == 0 {
                    flagValue[index[1]].checkedFlag = 1
                } else {
                    flagValue[index[1]].checkedFlag = 0
                }
                self.userListViewModel.filteredFriendsList.accept(flagValue)
        }
        
        //checkedMemberArray set with collectionView
        Observable
        .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(UserTestStruct.self))
        .bind { [unowned self] index, item in
            //flag set
            var flagValue = self.userListViewModel.filteredFriendsList.value
            flagValue[flagValue.firstIndex(where: {$0.name == item.name})!].checkedFlag = 0
            self.userListViewModel.filteredFriendsList.accept(flagValue)
            //remove from checkList
            var checkedValue = self.checkedMemberArray.value
            checkedValue.remove(at: index[1])
            self.checkedMemberArray.accept(checkedValue)
        }.disposed(by: disposeBag)
        
        //Reflected tableView height with collectionView exist
        checkedMemberArray
            .skip(1)
            .map { $0.count }
            .filter { $0 <= 1 }
            .subscribe(onNext: { count in
                if count == 0 {
                    self.tableView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    }
                } else {
                    self.tableView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
                    }
                }
                UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
    }
}
