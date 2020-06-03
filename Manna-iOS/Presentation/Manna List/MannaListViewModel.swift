//
//  MannaListViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/05/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MannaListViewModel {
    var mannaObservable = BehaviorSubject<[Manna]>(value: [])
    
    init() {
        let mannaList: [Manna] = [
            Manna(title: "망년회", place: "홍대입구", appointmentTime: "1시", numberPeople: "3명"),
            Manna(title: "망년회", place: "홍대입구", appointmentTime: "1시", numberPeople: "3명"),
            Manna(title: "망년회", place: "홍대입구", appointmentTime: "1시", numberPeople: "3명")
        ]
        
        mannaObservable.onNext(mannaList)
    }
}
