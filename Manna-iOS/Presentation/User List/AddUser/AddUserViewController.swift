//
//  AddUserViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/03.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class AddUserViewController: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    let imageView = UIImageView()
    var textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    var profileView = UIView()
    let viewModel = AddUserViewModel()
    let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBarSet()
        bind()
        profileViewSet()
    }
    func navigationBarSet() {
        navigationItem.title = "ID로 친구 추가"
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 ID"
            definesPresentationContext = true
            navigationItem.searchController = $0
        }
    }
    func bind() {
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text) { "\($1!)"}
            .bind(to: self.viewModel.searchValue)
            .disposed(by: disposeBag)
        viewModel.filteredUser
            .filterEmpty()
            .map { $0[0].name}
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.filteredUser
            .filterEmpty()
            .map { $0[0].profileImage}
            .subscribe(onNext: {str in
                self.imageView.image = UIImage(named: "\(str)")
            }).disposed(by: disposeBag)
    }
    func profileViewSet() {
        profileView.do {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        profileView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.center.equalTo(view.center)
            $0.top.equalTo(view).offset(200)
        }
        imageView.do {
            profileView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageView.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.top.equalTo(view).offset(300)
            $0.width.equalTo(screenSize.width).offset(300)
            $0.height.equalTo(screenSize.height).offset(300)
        }
        textLabel.do {
            profileView.addSubview($0)
            $0.textAlignment = NSTextAlignment.center
        }
        textLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.center)
            $0.top.equalTo(imageView.safeAreaLayoutGuide.snp.bottom).offset(50)
        }
    }
}
