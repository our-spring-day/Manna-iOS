//
//  NotiListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

class NotiListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let inviteFriendsViewModel = InviteFriendsViewModel()
    let userListViewModel = FriendListViewModel()
    
    let layoutValue = UICollectionViewFlowLayout()
    var collectionView = FriendsListCollectionView()
    var textField = UITextField()
    var tableView = FriendListTableView()
    let checkedMemberArray: BehaviorRelay<[User]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    // MARK: - attribute
    
    func attribute() {
        view.do {
            $0.backgroundColor = .white
        }
        textField.do {
            $0.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            $0.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
            $0.layer.cornerRadius = 8
            $0.placeholder = " 친구 이름을 검색하세요"
        }
    }
    
    // MARK: - layout
    
    func layout() {
        view.addSubview(collectionView)
        view.addSubview(textField)
        view.addSubview(tableView)
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
            $0.width.equalTo(view.safeAreaLayoutGuide).offset(-50)
            $0.centerX.equalTo(view.snp.centerX)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - bind
    
    func bind() {
        //친구목록을 뿌려주고 이때 체크플래그를 확인하고 맞는 이미지를 할당
        inviteFriendsViewModel.outputs.friendList
            .bind(to: tableView.baseTableView.rx.items(cellIdentifier: FriendListCell.identifier, cellType: FriendListCell.self)) { (_: Int, element: User, cell: FriendListCell) in
                cell.friendIdLabel.text = element.name
                cell.friendImageView.image = UIImage(named: "\(element.profileImage)")
                if element.checkedFlag == true {
                    cell.checkBoxImageView.image = UIImage(named: "checked")
                } else {
                    cell.checkBoxImageView.image = UIImage(named: "unchecked")
                }
        }.disposed(by: disposeBag)
        
        //체크된 친구목록을 뿌려줌
        inviteFriendsViewModel.outputs.checkedFriendList
            .bind(to: self.collectionView.baseCollectionView.rx.items(cellIdentifier: CheckedFriendCell.identifier, cellType: CheckedFriendCell.self)) { (_: Int, element: User, cell: CheckedFriendCell) in
                cell.profileImage.image = UIImage(named: "\(element.profileImage)")
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
        }.disposed(by: self.disposeBag)
        
        //테이블 뷰에서 선택한 친구를 뷰모델에 바인딩
        tableView.baseTableView.rx.modelSelected(User.self)
            .bind(to: inviteFriendsViewModel.inputs.itemFromTableView)
            .disposed(by: disposeBag)
        
        //콜렉션 뷰에서 선택한 친구를 뷰모델에 바인딩
        collectionView.baseCollectionView.rx.modelSelected(User.self)
            .bind(to: inviteFriendsViewModel.inputs.itemFromCollectionView)
            .disposed(by: disposeBag)
        
        //텍스트필드에 입력된 텍스트를 뷰모델에 바인딩
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: inviteFriendsViewModel.inputs.searchedFriendID)
            .disposed(by: disposeBag)
        
        //체크리스트에 따른 테이블 뷰와 검색창의 움직임
        inviteFriendsViewModel.outputs.checkedFriendList
            .skip(1)
            .map { $0.count }
            .scan([0, 0], accumulator: {
                return [$0[1], $1]
            })
            .filter { ($0[1] <= 1) && ($0[0] != 2) }
//            .map { $0[1] }
            .subscribe(onNext: { count in
                if count[1] == 0 {
                    self.textField.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    }
                    self.tableView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
                    }
                } else if count[1] == 1 {
                    self.textField.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
                    }
                    self.tableView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(150)
                    }
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
//        inviteFriendsViewModel.outputs.checkedFriendList
//            .skip(1)
//            .scan([], accumulator: {
//                print("$0 == ",$0)
//                print("$1 == ",$1)
//                return $1
//            })
//            .subscribe(onNext: { count in
////                print(count)
//            }).disposed(by: disposeBag)
        //keyboard hide when tableView,collectionView scrolling
        Observable.of(tableView.baseTableView.rx.didScroll.asObservable(), collectionView.baseCollectionView.rx.didScroll.asObservable()).merge()
            .subscribe(onNext: {
                self.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
}
