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
private let getAddressUrl = "https://dapi.kakao.com/v2/local/search/keyword.json"

class AddressAPI: AddressFetchable {
    static func getAddress(_ keyword: String) -> Observable<[Address]> {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK ec74a28d28177a706155cb8af1fb7ec8"
        ]
        let parameters: [String: String] = [
            "query": keyword
        ]
        
        return Observable.create { observer in
            AF.request(getAddressUrl, method: .get, parameters: parameters, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        var resultList: [Address] = []
                        if let addressList = JSON(value)["documents"].array {
                            for item in addressList {
                                let address = Address(address: item["address_name"].string!,
                                                      roadAddress: item["road_address_name"].string!)
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
}
