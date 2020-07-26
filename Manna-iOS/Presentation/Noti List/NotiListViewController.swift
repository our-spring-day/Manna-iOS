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

class NotiListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = UserListViewModel()
    var checkedMemberArray: BehaviorRelay<[UserTestStruct]> = BehaviorRelay(value: [])
    let screenSize: CGRect = UIScreen.main.bounds
    var collectionView: UICollectionView!
    let layoutValue = UICollectionViewFlowLayout()
    lazy var itemObservable = BehaviorRelay(value: [UserTestStruct]())
    var tableView = FriendsListTableView(frame: CGRect(x: 5,
                                                       y: 266,
                                                       width: UIScreen.main.bounds.width-10,
                                                       height: UIScreen.main.bounds.height - 266)
    )
    
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
            $0.register(BottomMenuCell.self, forCellWithReuseIdentifier: BottomMenuCell.identifier)
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
        layoutValue.do {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
            $0.itemSize = CGSize(width: 40, height: 40)
            $0.scrollDirection = .horizontal
        }
    }
    
    func layout() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(100)
            $0.width.equalTo(400)
            $0.height.equalTo(40)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    func bind() {
        //tableView set
        viewModel.filteredFriendsList
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
            .bind(to: self.collectionView.rx.items(cellIdentifier: BottomMenuCell.identifier, cellType: BottomMenuCell.self)){
                (index: Int, element: UserTestStruct, cell: BottomMenuCell) in
                cell.bottomImageView?.image = UIImage(named: "\(element.profileImage)")
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
                    checkedValue.append(item)
                    self.checkedMemberArray.accept(checkedValue)
                }
                //flag set
                var flagValue = self.viewModel.filteredFriendsList.value
                if flagValue[index[1]].checkedFlag == 0 {
                    flagValue[index[1]].checkedFlag = 1
                } else {
                    flagValue[index[1]].checkedFlag = 0
                }
                self.viewModel.filteredFriendsList.accept(flagValue)
        }
        //checkedMemberArray set with collectionView
        Observable
        .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(UserTestStruct.self))
        .bind { [unowned self] index, item in
            //flag set
            var flagValue = self.viewModel.filteredFriendsList.value
            flagValue[flagValue.firstIndex(where: {$0.name == item.name})!].checkedFlag = 0
            self.viewModel.filteredFriendsList.accept(flagValue)
            //remove from checkList
            var checkedValue = self.checkedMemberArray.value
            checkedValue.remove(at: index[1])
            self.checkedMemberArray.accept(checkedValue)
        }.disposed(by: disposeBag)
    }
}
