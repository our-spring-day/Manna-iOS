//
//  DurringMeetingModel.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/09/28.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import NMapsMap

struct TempPeopleStruct {
    var id: String
    var currentLocation: NMGLatLng
}
var hyogeun = TempPeopleStruct(id: "hyogeun", currentLocation: NMGLatLng(lat: 37.2819578, lng: 127.0115508))
var sangwon = TempPeopleStruct(id: "sangwon", currentLocation: NMGLatLng(lat: 37.598437, lng: 126.915523))
var jongchan = TempPeopleStruct(id: "jongchan", currentLocation: NMGLatLng(lat: 37.478566, lng: 126.864476))
var wooseok = TempPeopleStruct(id: "wooseok", currentLocation: NMGLatLng(lat: 37.482126, lng: 126.976702))
var yeonjae = TempPeopleStruct(id: "yeonjae", currentLocation: NMGLatLng(lat: 37.618727, lng: 126.920874))
var jaein = TempPeopleStruct(id: "jaein", currentLocation: NMGLatLng(lat: 37.411677, lng: 127.128621))

class DurringMeetingModel {
    func getMeetingInfo() -> [TempPeopleStruct] {
        return [hyogeun, sangwon, jongchan, wooseok, yeonjae, jaein]
    }
}
