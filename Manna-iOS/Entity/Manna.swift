//
//  Manna.swift
//  Manna-iOS
//
//  Created by once on 2020/06/03.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

struct Manna {
    let title: String
    let numberPeople: String
    let appointmentTime: String
    let place: String
    
    func setManna(_ title: String, _ people: String, _ time: String, _ place: String) -> Manna {
        return Manna(title: title, numberPeople: people, appointmentTime: time, place: place)
    }
}
