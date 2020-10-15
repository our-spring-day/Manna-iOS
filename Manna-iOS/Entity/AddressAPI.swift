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
    static func getAddress(_ keyword: String) -> Observable<[Address]>
}
private let key2AddressURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
private let coord2AddressURL = "https://dapi.kakao.com/v2/local/geo/coord2address.json"

class AddressAPI: AddressFetchable {
    static private let headers: HTTPHeaders = [
        "Authorization": "KakaoAK ec74a28d28177a706155cb8af1fb7ec8"
    ]
    
    static func getAddress(_ keyword: String) -> Observable<[Address]> {
        let parameters: [String: String] = [
            "query": keyword
        ]
        
        return Observable.create { observer in
            AF.request(key2AddressURL, method: .get, parameters: parameters, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        var resultList: [Address] = []
                        if let addressList = JSON(value)["documents"].array {
                            for item in addressList {
                                let address = Address(address: item["address_name"].string!,
                                                      roadAddress: item["road_address_name"].string!, lng: item["x"].string!, lat: item["y"].string!)
                                resultList.append(address)
                            }
                            observer.onNext(resultList)
                        }
                    case .failure(let err):
                        print(err)
                    }
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    static func getAddress(_ lng: Double, _ lat: Double) -> Observable<Address> {
        let parameters: [String: Double] = [
            "x": lng, "y": lat
        ]
        return Observable.create { observer in
            AF.request(coord2AddressURL, method: .get, parameters: parameters, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let addressList = JSON(value)["documents"].arrayValue[0]
                        let address = Address(address: "\(addressList["address"]["address_name"])",
                            roadAddress: "\(addressList["road_address"]["address_name"])",
                            lng: "\(lng)",
                            lat: "\(lat)")
                        observer.onNext(address)
                    case .failure(let err):
                        print(err)
                    }
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
