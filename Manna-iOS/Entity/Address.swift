//
//  Address.swift
//  Manna-iOS
//
//  Created by once on 2020/07/13.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

struct Address: Codable {
    var address : String
    var jibunAddress : String
    
    init(address : String ,jibunAddress : String) {
        self.address = address
        self.jibunAddress = jibunAddress
    }
}
