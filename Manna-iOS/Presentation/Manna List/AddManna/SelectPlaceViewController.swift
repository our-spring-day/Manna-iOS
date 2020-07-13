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
    var resultList: [Address] = []
    let backButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        $0.addTarget(self, action: #selector(result), for: .touchUpInside)
    }
    let resultButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "Image"), for: .normal)
        $0.addTarget(self, action: #selector(result), for: .touchUpInside)
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

    func searchAddress(_ keyword: String) {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK ec74a28d28177a706155cb8af1fb7ec8"
        ]
        
        let parameters: [String: Any] = [
            "query": keyword
        ]

        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get, parameters: parameters, headers: headers)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    self.resultList.removeAll()
                    if let addressList = JSON(value)["documents"].array {
                        for item in addressList {
                            print(item["address_name"])
                            print(item["road_address_name"])
                            self.resultList.append(Address(address: item["address_name"].string!, jibunAddress: item["road_address_name"].string!))
                        }
                        print(self.resultList)
                        self.viewModel.output.address.accept(self.resultList)
                    }
                case .failure(let error):
                    print(error)
                }
                
            })
    }
    
    @objc func result() {
        let input: String = searchText.text!
        searchAddress(input)
    }
}
