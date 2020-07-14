//
//  AddressAPI.swift
//  Manna-iOS
//
//  Created by once on 2020/07/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let getAddressUrl = "https://dapi.kakao.com/v2/local/search/keyword.json"

class AddressAPI {
    static func searchAddress(_ keyword: String) {
        let headers: HTTPHeaders = [ "Authorization": "KakaoAK ec74a28d28177a706155cb8af1fb7ec8" ]
        
        let parameters: [String: Any] = [ "query": keyword ]
        
        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get, parameters: parameters, headers: headers)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    resultList.removeAll()
                    if let addressList = JSON(value)["documents"].array {
                        for item in addressList {
                            print(item["address_name"])
                            print(item["road_address_name"])
                            resultList.append(Address(address: item["address_name"].string!, jibunAddress: item["road_address_name"].string!))
                        }
                        print(resultList)
                        viewModel.output.address.accept(resultList)
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
}
