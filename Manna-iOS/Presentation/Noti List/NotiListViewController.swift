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
    
    var checkedFriendsList: [UserTestStruct] = []
    let viewModel = UserListViewModel()
    var meetingMemberArray: BehaviorRelay<[UserTestStruct]> = BehaviorRelay(value: [])
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
        viewModel.filteredFriendsList
            .bind(to: tableView.tableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self))
            {(_: Int, element: UserTestStruct, cell: UserListCell) in
                //tableview set
                cell.idLabel.text = element.name
                cell.userImageView.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: disposeBag)
        
        tableView.tableView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: {item in
                var newValue = self.meetingMemberArray.value
                if newValue.contains(where: { $0.name == item.name }) {
                    print("들어가있음이미")
                    newValue.remove(at: newValue.firstIndex(where: {$0.name == item.name})!)
                    self.meetingMemberArray.accept(newValue)
                } else {
                    print("추가함")
                    newValue.append(item)
                    self.meetingMemberArray.accept(newValue)
                }
                print(self.meetingMemberArray.value)
            }).disposed(by: disposeBag)
        
        meetingMemberArray
            .bind(to: self.collectionView.rx.items(cellIdentifier: BottomMenuCell.identifier, cellType: BottomMenuCell.self)){
                (index: Int, element: UserTestStruct, cell: BottomMenuCell) in
                cell.backgroundColor = .lightGray
                cell.bottomImageView?.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: {item in
                var newValue = self.meetingMemberArray.value
                newValue.remove(at: newValue.firstIndex(where: {$0.name == item.name})!)
                self.meetingMemberArray.accept(newValue)
            }).disposed(by: self.disposeBag)
    }
}
