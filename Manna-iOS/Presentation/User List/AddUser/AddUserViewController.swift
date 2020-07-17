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
    var profileView = UIView()
    let searchController = UISearchController(searchResultsController: nil)
    let screenSize: CGRect = UIScreen.main.bounds
    var textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
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
        navigationItem.do {
            $0.title = "ID로 친구 추가"
        }
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 ID"
            $0.searchBar.tintColor = UIColor(named: "default")
            definesPresentationContext = true
            navigationItem.searchController = $0
        }
        profileView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        textLabel.do {
            $0.textAlignment = NSTextAlignment.center
        }
    }
    
    func layouts() {
        view.addSubview(profileView)
        view.addSubview(imageView)
        view.addSubview(textLabel)
        profileView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.center.equalTo(view.center)
            $0.top.equalTo(view).offset(200)
        }
        imageView.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.top.equalTo(view).offset(300)
            $0.width.equalTo(screenSize.width).offset(300)
            $0.height.equalTo(screenSize.height).offset(300)
        }
        textLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.center)
            $0.top.equalTo(imageView.safeAreaLayoutGuide.snp.bottom).offset(50)
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
            }).disposed(by: disposeBag)
    }
}
