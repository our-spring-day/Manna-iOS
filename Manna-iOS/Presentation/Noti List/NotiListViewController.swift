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
    
    var checkedMemberArray: BehaviorRelay<[UserTestStruct]> = BehaviorRelay(value: [])
    let userListViewModel = FriendListViewModel()
    var collectionView: UICollectionView!
    let layoutValue = UICollectionViewFlowLayout()
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
        FriendListViewModel.myFriendList
            .bind(to: tableView.baseTableView.rx.items(cellIdentifier: FriendListCell.identifier, cellType: FriendListCell.self))
            {(_: Int, element: UserTestStruct, cell: FriendListCell) in
                cell.friendIdLabel.text = element.name
                cell.friendImageView.image = UIImage(named: "\(element.profileImage)")
                if element.checkedFlag == 1 {
                    cell.checkBoxImageView.image = UIImage(named: "checked")
                } else {
                    cell.checkBoxImageView.image = UIImage(named: "unchecked")
                }
        }.disposed(by: disposeBag)
        
        //collectionView set
        checkedMemberArray
            .bind(to: self.collectionView.rx.items(cellIdentifier: CheckedFriendCell.identifier, cellType: CheckedFriendCell.self)) {
                (index: Int, element: UserTestStruct, cell: CheckedFriendCell) in
                cell.profileImage.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: self.disposeBag)
        
        //bind checkedMemberArray with filteredFriendsList checkedFlag Value
        FriendListViewModel.myFriendList
            .map { $0.filter({ $0.checkedFlag == 1 }) }
            .bind(to: checkedMemberArray)
            .disposed(by: disposeBag)
        
        //checkedMemberArray update with tableView
        tableView.baseTableView.rx.itemSelected
            .subscribe(onNext: { index in
                var flagValue = FriendListViewModel.self.myFriendList.value
                if flagValue[index[1]].checkedFlag == 0 {
                    flagValue[index[1]].checkedFlag = 1
                } else {
                    flagValue[index[1]].checkedFlag = 0
                }
                FriendListViewModel.self.myFriendList.accept(flagValue)
            }).disposed(by: disposeBag)
        
        //checkedMemberArray update with collectionView
        collectionView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: { item in
                //flag set
                var flagValue = FriendListViewModel.self.myFriendList.value
                flagValue[flagValue.firstIndex(where: {$0.name == item.name})!].checkedFlag = 0
                FriendListViewModel.self.myFriendList.accept(flagValue)
            }).disposed(by: disposeBag)
        
        //Reflected tableView height with checkedFriends are exist
        checkedMemberArray
            .skip(1)
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
