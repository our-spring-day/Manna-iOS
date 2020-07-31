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
    
    // MARK: - UI Attribute
    
    func attribute() {
        view.do {
            $0.backgroundColor = .white
        }
        backButton.do {
            $0.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
            $0.addTarget(self, action: #selector(back), for: .touchUpInside)
        }
        resultButton.do {
            $0.setTitle("검색", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.layer.borderWidth = 1.0
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
    
    // MARK: - UI Layout
    
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
    
    // MARK: - UI Bind
    
    func bind() {
        let firstAddress = searchText.rx.text.orEmpty
            .take(1)

        let elseAddress = resultButton.rx.tap
            .map({ [weak self] _ in
                (self?.searchText.text)!
            })

        Observable.merge(firstAddress, elseAddress)
            .bind(to: viewModel.inputs.address)
            .disposed(by: disposeBag)
        
        viewModel.outputs.addressArr
            .bind(to: searchResult.rx.items(cellIdentifier: AddressListCell.identifier, cellType: AddressListCell.self)) { _, item, cell in
                cell.address.text = item.address
                cell.jibunAddress.text = item.roadAddress
            }
            .disposed(by: disposeBag)
        
        searchResult.rx.modelSelected(Address.self)
            .map({ $0 })
            .do(onNext: { [weak self] address in
                let view = SelectPlacePinViewController()
                view.modalPresentationStyle = .overFullScreen
                view.lng = Double(address.lng)
                view.lat = Double(address.lat)
                view.addressLable.text = address.address
                view.roadAddressLable.text = address.roadAddress
                self?.present(view, animated: true, completion: nil)
            })
            .subscribe {
                print("test")
            }
            .disposed(by: disposeBag)
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}
