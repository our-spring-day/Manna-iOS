//
//  DurringMeetingViewModel.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/08/06.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

class DurringMeetingViewModel {
    let disposeBag = DisposeBag()
    let model = DurringMeetingModel()
    var meetingInfo =  BehaviorRelay<[TempPeopleStruct]>(value: DurringMeetingModel().getMeetingInfo())
    var testFlag = true
    
    init() {
        
    }
    
    func searchMeetingInfo() {
//        if testFlag {
//            var value = meetingInfo.value
//            value.removeAll()
//            meetingInfo.accept(value)
//            testFlag.toggle()
//        } else {
//            var value = meetingInfo.value
//            value = model.getMeetingInfo()
//            meetingInfo.accept(value)
//            testFlag.toggle()
//        }
    }
}
