//
//  SelectPlaceViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/07/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import SwiftyJSON

class SelectPlaceViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = AddMannaViewModel()
    
    let backButton = UIButton()
    let resultButton = UIButton()
    let searchText = UITextField()
    let searchResult = UITableView()
    
    var resultList: [Address] = []
    
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
        backButton.do {
            $0.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
            $0.addTarget(self, action: #selector(result), for: .touchUpInside)
        }
        resultButton.do {
            $0.setImage(#imageLiteral(resourceName: "Image"), for: .normal)
            $0.addTarget(self, action: #selector(result), for: .touchUpInside)
        }
        searchText.do {
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.layer.borderWidth = 1.0
        }
        searchResult.do {
            $0.rowHeight = 90
            $0.backgroundView?.isHidden = true
            $0.register(AddressListCell.self, forCellReuseIdentifier: AddressListCell.identifier)
        }
    }
    
    func layout() {
        view.addSubview(backButton)
        view.addSubview(searchText)
        view.addSubview(searchResult)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(10)
        }
        searchText.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
        searchResult.snp.makeConstraints {
            $0.top.equalTo(searchText.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func bind() {
        viewModel.output.addressRoad
            .debug()
            .subscribe(onNext: { [weak self] str in
                self?.searchText.text = str
            })
            .disposed(by: disposeBag)
        
        viewModel.output.addressResult
            .bind(to: searchResult.rx.items(cellIdentifier: AddressListCell.identifier, cellType: AddressListCell.self)) { _, item, cell in
                cell.address.text = item.address
                cell.jibunAddress.text = item.roadAddress
            }
            .disposed(by: disposeBag)
    }
    
    @objc func result() {
        let input: String = searchText.text!
        
        AddressAPI.getAddress(input).asObservable()
            .bind(to: self.viewModel.output.addressResult)
            .disposed(by: disposeBag)
    }
}
