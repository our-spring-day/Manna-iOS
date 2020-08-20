//
//  AddUserViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/03.
//  Copyright © 2020 정재인. All rights reserved.
//


import RxCocoa
import RxSwift
import SnapKit
import UIKit

class AddUserViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let addUserViewModel = AddUserViewModel()
    let friendListViewModel = FriendListViewModel()
    
    let screenSize: CGRect = UIScreen.main.bounds
    let searchController = UISearchController(searchResultsController: nil)
    let backgroundView = UIView()
    let searchedUserImageView = UIImageView()
    let searchedUserIdLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let addFriendButton = UIButton()
    var newFriend =  BehaviorRelay(value: User(name: "", profileImage: "", checkedFlag: 0))
    lazy var newFriendObservable = Observable.just(self.newFriend)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layouts()
        bind()
    }
    
    func attribute() {
        
        view.do {
            $0.backgroundColor = .white
        }
        navigationController?.do {
            $0.navigationItem.do { item in
                item.title = "ID로 친구 추가"
            }
            $0.navigationBar.do { bar  in
                bar.tintColor = UIColor(named: "default")
            }
        }
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 ID"
            $0.searchBar.tintColor = UIColor(named: "default")
            navigationItem.searchController = $0
        }
        backgroundView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        searchedUserImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        searchedUserIdLabel.do {
            $0.textAlignment = NSTextAlignment.center
            $0.font = UIFont.systemFont(ofSize: 20.0)
        }
        addFriendButton.do {
            $0.setImage(UIImage(named: "addfriendbuttonimage"), for: .normal)
            $0.frame = CGRect(x: 0, y: 0, width: 100, height: 65)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
            $0.isHidden = true
        }
    }
    
    func layouts() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(searchedUserImageView)
        backgroundView.addSubview(searchedUserIdLabel)
        backgroundView.addSubview(addFriendButton)
        
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.center.equalTo(view.center)
            $0.top.equalTo(view).offset(130)
        }
        searchedUserImageView.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(backgroundView).offset(100)
            $0.width.equalTo(screenSize.width).offset(200)
            $0.height.equalTo(screenSize.height).offset(200)
        }
        searchedUserIdLabel.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(searchedUserImageView.safeAreaLayoutGuide.snp.bottom).offset(25)
        }
        addFriendButton.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(searchedUserIdLabel.snp.bottom).offset(50)
        }
    }
    
    func bind() {
        //text 가 비어있을 때 return 버튼 disabled 필요
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text) { "\($1!)"}
            .bind(to: self.addUserViewModel.inputs.searchedUserID)
            .disposed(by: disposeBag)
        
        addUserViewModel.outputs.filteredUser
            .bind(to: self.newFriend)
            .disposed(by: disposeBag)
        
        newFriend
            .skip(1)
            .subscribe(onNext: { item in
                self.searchedUserIdLabel.text = item.name
                self.searchedUserImageView.image = UIImage(named: item.profileImage)
                self.addFriendButton.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
        
        //pop 시켜주고 새로 들어온 친구로 포커스 맞춰주면 좋을듯
        addFriendButton.rx.tap
            .map({ self.newFriend.value })
            .bind(to: friendListViewModel.inputs.requestingFriend)
            .disposed(by: disposeBag)
    }
}
