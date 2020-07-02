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

//새로운 친구를 찾으려 검색할 때 view
class AddUserViewController: UIViewController {
    let resultStackView = UIStackView()
    let viewModel = AddUserViewModel()
    let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBarSet()
        bind()
        var v1: UIView = {
            let v1 = UIView()
            v1.backgroundColor = .blue
            v1.heightAnchor.constraint(equalToConstant: 100).isActive = true
            return v1
        }()
        v1.translatesAutoresizingMaskIntoConstraints = false
        v1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        var v2:UIView = {
            let v2 = UIView()
            v2.backgroundColor = .red
            return v2
        }()
        var stack:UIStackView = {
            let stack = UIStackView(frame: self.view.bounds)
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.alignment = .fill
            stack.spacing = 5
            stack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            stack.addArrangedSubview(v1)
            stack.addArrangedSubview(v2)
            
            return stack
        }()
        view.addSubview(stack)
        
        stack.heightAnchor.constraint(equalToConstant: 200)
            .isActive = true // ---- 3
        stack.widthAnchor.constraint(equalToConstant: 200)
            .isActive = true // ---- 4
        stack.centerXAnchor.constraint(equalTo:view.centerXAnchor)
            .isActive = true // ---- 1
        stack.centerYAnchor.constraint(equalTo:view.centerYAnchor)
            .isActive = true // ---- 2
    }
    
    func navigationBarSet() {
        navigationItem.title = "ID로 친구 추가"
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 검색"
            navigationItem.searchController = $0
            definesPresentationContext = true
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
