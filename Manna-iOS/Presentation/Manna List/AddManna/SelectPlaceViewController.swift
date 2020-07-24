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
    
    let viewModel: AddMannaViewModelType
    
    let backButton = UIButton()
    let resultButton = UIButton()
    let searchText = UITextField()
    let searchResult = UITableView()

    
    // MARK: - Life Cycle
    
    init(viewModel: AddMannaViewModelType = AddMannaViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = AddMannaViewModel()
        super.init(coder: aDecoder)
    }

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
//            $0.addTarget(self, action: #selector(result), for: .touchUpInside)
        }
        resultButton.do {
            $0.setTitle("검색", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.layer.borderWidth = 1.0
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
        view.addSubview(resultButton)
        view.addSubview(searchText)
        view.addSubview(searchResult)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(10)
        }
        resultButton.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(20)
            $0.leading.equalTo(searchText.snp.trailing).offset(10)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        searchText.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(240)
            $0.height.equalTo(40)
        }
        searchResult.snp.makeConstraints {
            $0.top.equalTo(searchText.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func bind() {
        let result = searchText.rx.text.orEmpty
            .take(1)

        let result2 = resultButton.rx.tap
            .map({ [weak self] _ in
                (self?.searchText.text)!
            })

        Observable.merge(result, result2)
            .bind(to: viewModel.inputs.address)
            .disposed(by: disposeBag)
        
        viewModel.outputs.addressOut
            .debug()
            .bind(to: searchResult.rx.items(cellIdentifier: AddressListCell.identifier, cellType: AddressListCell.self)) { _, item, cell in
                cell.address.text = item.address
                cell.jibunAddress.text = item.roadAddress
            }
            .disposed(by: disposeBag)
        
        searchResult.rx.itemSelected
            .map {$0}
            .subscribe {
                print("indexPath : \($0)")
            }
            .disposed(by: disposeBag)
    }
    
    @objc func result() {
//        guard let text = searchText.text else { return }
//        print("text : \(text)")
//        viewModel.inputs.address.onNext(text)
    }
}
