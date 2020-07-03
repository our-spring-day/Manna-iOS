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
    var backgroundView = UIView()
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
        backgroundViewSet()
    }
    func navigationBarSet() {
        navigationItem.title = "ID로 친구 추가"
        navigationController?.navigationBar.prefersLargeTitles = false
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 검색"
            navigationItem.searchController = $0
            definesPresentationContext = true
            navigationItem.searchController = searchController
        }
    }
    func bind() {
        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: {
                self.searchController.searchBar.rx.text
                    .orEmpty
                    .distinctUntilChanged()
                    .debug()
                    .bind(to: self.viewModel.searchValue)
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
//        viewModel.filteredUser.bind(to: textLabel.rx.text)
    }
    func backgroundViewSet() {
        backgroundView.do {
            view.addSubview($0)
            $0.backgroundColor = .lightGray
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.center.equalTo(view.center)
            $0.top.equalTo(view).offset(200)
        }
        textLabel.do {
            backgroundView.addSubview($0)
            $0.textAlignment = NSTextAlignment.center
            $0.text = "사용자 아이디가 들어갈 자리"
        }
        textLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.center)
            $0.bottom.equalTo(backgroundView).offset(-50)
        }
    }
}
