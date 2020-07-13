//
//  SelectPlaceViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/07/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectPlaceViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = AddMannaViewModel()
    
    let backButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        $0.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    let searchText = UITextField().then {
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.layer.borderWidth = 1.0
    }
    
    let searchResult = UITableView().then {
        $0.rowHeight = 90
        $0.backgroundView?.isHidden = true
        $0.register(AddressListCell.self, forCellReuseIdentifier: AddressListCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        bind()
    }
    
    func bind() {
        viewModel.output.address
            .bind(to: searchResult.rx.items(cellIdentifier: AddressListCell.identifier, cellType: AddressListCell.self)) { _, item, cell in
                cell.address.text = item.address
                cell.jibunAddress.text = item.jibunAddress
            }
            .disposed(by: disposeBag)
    }
    
    func layout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(10)
        }
        
        view.addSubview(searchText)
        searchText.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(400)
            $0.height.equalTo(50)
        }
        
        view.addSubview(searchResult)
        searchResult.snp.makeConstraints {
            $0.top.equalTo(searchText.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
