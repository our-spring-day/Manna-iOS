//
//  Address.swift
//  Manna-iOS
//
//  Created by once on 2020/07/13.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

struct Address: Codable {
    let address: String
    let roadAddress: String
    let lng: String         //x longitude
    let lat: String         //y latitude
}
