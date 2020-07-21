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
    var meetingMemberArray: BehaviorRelay<[UserTestStruct]> = BehaviorRelay(value: [])
    lazy var itemsObservable: Observable<[UserTestStruct]> = Observable.of([UserTestStruct]())
    
    let screenSize: CGRect = UIScreen.main.bounds
    var tableView = FriendsListTableView(frame: CGRect(x: 5, y: 266, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.height - 266))
    var collectionView: UICollectionView!
    let layoutValue: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
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
        //        viewModel.filteredFriendsList
        //            .bind(to: collectionView.rx.items(cellIdentifier: BottomMenuCell.identifier, cellType: BottomMenuCell.self)) {
        //                (index: Int, element: UserTestStruct, cell: BottomMenuCell) in
        //                cell.backgroundColor = .lightGray
        //                cell.bottomImageView?.image = UIImage(named: "\(element.profileImage)")
        //        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: { str in
                print(str)
            }).disposed(by: disposeBag)
        
        viewModel.filteredFriendsList
            .bind(to: tableView.tableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self)) {(_: Int, element: UserTestStruct, cell: UserListCell) in
                cell.idLabel.text = element.name
                cell.userImageView.image = UIImage(named: "\(element.profileImage)")
                cell.checkBox.userInfo = element
                cell.checkBox.rx.tap
                    .subscribe(onNext : { tap in
                        self.itemsObservable.map({$0.filter({
                            return  ($0.name.lowercased().contains(element.name.lowercased()))
                        })
                        }).bind(to: self.collectionView.rx.items(cellIdentifier: BottomMenuCell.identifier, cellType: BottomMenuCell.self)) {
                            (index: Int, element: UserTestStruct, cell: BottomMenuCell) in
                            cell.backgroundColor = .lightGray
                            cell.bottomImageView?.image = UIImage(named: "\(element.profileImage)")
                        }.disposed(by: self.disposeBag)
                    }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        //        searchValueObservable
        //        .subscribe(onNext: { value in
        //            self.itemsObservable.map({ $0.filter({
        //                if value.isEmpty { return true }
        //                return  ($0.name.lowercased().contains(value.lowercased()))
        //            })
        //            }).bind( to: self.meetingMemberArray )
        //        }).disposed(by: disposeBag)
    }
}
