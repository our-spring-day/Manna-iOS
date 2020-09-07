//
//  AddressAPI.swift
//  Manna-iOS
//
//  Created by once on 2020/07/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

protocol AddressFetchable {
    func getAddress(_ keyword: String) -> Observable<Result<[Address], Error>>
    func getAddress(_ lng: Double, _ lat: Double) -> Observable<Result<Address, Error>>
}

private let key2AddressURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
private let coord2AddressURL = "https://dapi.kakao.com/v2/local/geo/coord2address.json"

class AddressAPI: AddressFetchable {
    private let headers: HTTPHeaders = [
        "Authorization": "KakaoAK ec74a28d28177a706155cb8af1fb7ec8"
    ]
    
    func getAddress(_ keyword: String) -> Observable<Result<[Address], Error>> {
        let parameters: [String: String] = [
            "query": keyword
        ]
        
        return Observable.create { observer in
            AF.request(key2AddressURL, method: .get, parameters: parameters, headers: self.headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let data = "\(JSON(value)["documents"])".data(using: .utf8)
                        
                        if let data = data, let searchAddress = try? JSONDecoder().decode([Address].self, from: data) {
                            observer.onNext(.success(searchAddress))
                        }
                    case .failure(let err):
                        print("\(err)입니다.")
                    }
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getAddress(_ lng: Double, _ lat: Double) -> Observable<Result<Address, Error>> {
        let parameters: [String: Double] = [
            "x": lng, "y": lat
        ]
        return Observable.create { observer in
            AF.request(coord2AddressURL, method: .get, parameters: parameters, headers: self.headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let addressList = JSON(value)["documents"].arrayValue[0]
                        let searchAddress = Address(roadAddress: "\(addressList["road_address"]["address_name"])",
                            address: "\(addressList["address"]["address_name"])",
                            x: "\(lng)",
                            y: "\(lat)")
                        observer.onNext(.success(searchAddress))
                    case .failure(let err):
                        print(err)
                    }
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
