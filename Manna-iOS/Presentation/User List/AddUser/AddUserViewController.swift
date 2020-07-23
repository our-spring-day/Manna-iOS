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
    
    let viewModel = AddUserViewModel()
    
    let imageView = UIImageView()
    let profileView = UIView()
    let searchController = UISearchController(searchResultsController: nil)
    let screenSize: CGRect = UIScreen.main.bounds
    let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let addFriendButton = UIButton()
    var addFriendID: String = ""
    
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
        profileView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        textLabel.do {
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
        view.addSubview(profileView)
        profileView.addSubview(imageView)
        profileView.addSubview(textLabel)
        profileView.addSubview(addFriendButton)
        
        profileView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.center.equalTo(view.center)
            $0.top.equalTo(view).offset(130)
        }
        imageView.snp.makeConstraints {
            $0.centerX.equalTo(profileView.snp.centerX)
            $0.top.equalTo(profileView).offset(100)
            $0.width.equalTo(screenSize.width).offset(200)
            $0.height.equalTo(screenSize.height).offset(200)
        }
        textLabel.snp.makeConstraints {
            $0.centerX.equalTo(profileView.snp.centerX)
            $0.top.equalTo(imageView.safeAreaLayoutGuide.snp.bottom).offset(25)
        }
        addFriendButton.snp.makeConstraints {
            $0.centerX.equalTo(profileView.snp.centerX)
            $0.top.equalTo(textLabel.snp.bottom).offset(50)
        }
    }
    
    func bind() {
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text) { "\($1!)"}
            .bind(to: self.viewModel.searchValue)
            .disposed(by: disposeBag)
        
        viewModel.filteredUser
            .filterEmpty()
            .subscribe(onNext: { item in
                self.textLabel.text = item[0].name
                self.imageView.image = UIImage(named: item[0].profileImage)
                self.addFriendID = item[0].profileImage
                self.addFriendButton.isHidden = false
            }).disposed(by: disposeBag)
        
        addFriendButton.rx.tap
            .subscribe(onNext: {
                print(self.addFriendID)
//                UserListModel().friends.append(UserTestStruct(name: self.textLabel.text!, profileImage: self.addFriendID))
//                UserListModel().friends.removeAll()
            }).disposed(by: disposeBag)
    }
}
