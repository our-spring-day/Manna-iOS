//
//  DurringMeetingModel.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/09/28.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import NMapsMap

struct tempPeopleStruct {
    let id: String
    var currentLocation: NMGLatLng
}
var hyogeun = tempPeopleStruct(id: "hyogeun", currentLocation: NMGLatLng(lat: 37.2819578, lng: 127.0115508))
var sangwon = tempPeopleStruct(id: "sangwon", currentLocation: NMGLatLng(lat: 37.598437, lng: 126.915523))
var jongchan = tempPeopleStruct(id: "jongchan", currentLocation: NMGLatLng(lat: 37.478566, lng: 126.864476))
var wooseok = tempPeopleStruct(id: "wooseok", currentLocation: NMGLatLng(lat: 37.482126, lng: 126.976702))
var yeonjae = tempPeopleStruct(id: "yeonjae", currentLocation: NMGLatLng(lat: 37.618727, lng: 126.920874))
var jaein = tempPeopleStruct(id: "jaein", currentLocation: NMGLatLng(lat: 37.411677, lng: 127.128621))

class DurringMeetingModel {
    func getMeetingInfo() -> [tempPeopleStruct]{
        return [hyogeun,sangwon,jongchan,wooseok,yeonjae,jaein]
    }
}
