//
//  Manna.swift
//  Manna-iOS
//
//  Created by once on 2020/06/03.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxDataSources

struct Manna {
    let title: String
    let place: String
    let appointmentTime: String
    let numberPeople: String
    
    init(title: String, place: String, appointmentTime: String, numberPeople: String) {
        self.title = title
        self.place = place
        self.appointmentTime = appointmentTime
        self.numberPeople = numberPeople
    }
}
