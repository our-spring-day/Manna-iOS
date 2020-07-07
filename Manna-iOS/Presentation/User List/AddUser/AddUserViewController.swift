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
    let imageView = UIImageView()
    var textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    var profileView = UIView()
    var newView = UIView()
    let resultStackView = UIStackView()
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
            $0.searchBar.placeholder = "친구 검색"
            navigationItem.searchController = $0
            definesPresentationContext = true
            navigationItem.searchController = searchController
        }
    }
    func bind() {
//        var test: Observable<Void> =searchController.searchBar.rx.searchButtonClicked.withLatestFrom(searchController.searchBar.rx.text, resultSelector: { (lastLeft, lastRight) in
//        "\(lastLeft) \(lastRight)"
//        })
        searchController.searchBar.rx.searchButtonClicked
        .withLatestFrom(searchController.searchBar.rx.text) { "\($1)"}
            .bind(to: self.viewModel.searchValue)
            .disposed(by: disposeBag)
        viewModel.filteredUser
            .filterEmpty()
            .map { $0[0].name}
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
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
        textLabel.do {
            profileView.addSubview($0)
            $0.textAlignment = NSTextAlignment.center
//            $0.text = "사용자 아이디가 들어갈 자리"
        }
        textLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.center)
            $0.bottom.equalTo(profileView).offset(-50)
        }
        imageView.do {
            profileView.addSubview($0)
//            $0.image = UIImage(named: "soma")
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 300).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 300).isActive = true
            $0.centerXAnchor.constraint(equalTo: profileView.centerXAnchor, constant: 0).isActive = true
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(profileView).offset(50)
        }
    }
}
