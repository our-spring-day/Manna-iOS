//
//  MannaListModel.swift
//  Manna-iOS
//
//  Created by once on 2020/05/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

class MannaListModel {
    var title: String
    var place: String
    var appointmentTime: String
    var numberPeople: String
    
    init (title: String, place: String, appointmentTime: String, numberPeople: String){
        self.title = title
        self.place = place
        self.appointmentTime = appointmentTime
        self.numberPeople = numberPeople
    }
    
}
