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
        backgroundView.addSubview(searchController.searchBar)
        backgroundView.addSubview(newView)
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = .red
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -100).isActive = true
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(240)
        }
//        newView.backgroundColor = .blue
//        newView.translatesAutoresizingMaskIntoConstraints = false
//        newView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor, constant: 10).isActive = true
//        newView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        newView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        newView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        var v1:UIView = {
//            let testView1 = UIView()
//            testView1.backgroundColor = .blue
//            return testView1
//        }()
//        var v2:UIView = {
//            let testView2 = UIView()
//            testView2.backgroundColor = .blue
//            return testView2
//        }()
//        var stack:UIStackView = {
//            let testStack = UIStackView(frame: self.view.bounds)
//            testStack.axis = .vertical
//            testStack.distribution = .fillEqually
//            testStack.alignment = .fill
//            testStack.spacing = 5
//            testStack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            testStack.translatesAutoresizingMaskIntoConstraints = false
//            return testStack
//        }()
//        stack.addArrangedSubview(v1)
//        stack.addArrangedSubview(v2)
//        view.addSubview(stack)
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
        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: {
                self.searchController.searchBar.rx.text
                    .orEmpty
                    .distinctUntilChanged()
                    .debug()
                    .bind(to: self.viewModel.searchValue)
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        viewModel.filteredUser
            .subscribe(onNext: {str in
                print(str)}
        ).disposed(by: disposeBag)
    }
}
