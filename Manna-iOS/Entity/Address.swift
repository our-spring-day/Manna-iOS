//
//  Address.swift
//  Manna-iOS
//
//  Created by once on 2020/07/13.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

struct Address: Codable {
    var url: String?
    var distance: String?
    var roadAddress: String
    var address: String
    var phone: String?
    var x: String
    var y: String
    var place_name: String?
    var id: String?
    var category_name: String?
    var category_group_code: String?
    var category_group_name: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "place_url"
        case distance
        case roadAddress = "road_address_name"
        case address = "address_name"
        case phone
        case x, y
        case place_name
        case id
        case category_name
        case category_group_name
        case category_group_code
    }
}
//struct Address: Codable {
//    let address: String
//    let roadAddress: String
//    let lng: String         //x longitude
//    let lat: String         //y latitude
//
//    enum CodingKeys: String, CodingKey {
//        case address
//        case roadAddress
//        case lng = "x"
//        case lat = "y"
//    }
//}
