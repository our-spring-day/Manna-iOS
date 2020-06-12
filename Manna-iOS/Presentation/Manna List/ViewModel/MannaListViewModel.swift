//
//  MannaListViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/05/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol MannaListViewModelType {
    var allMannas: Observable<[MannaListModel]> { get }
    var mannas: BehaviorRelay<[MannaListModel]> { get }
}

class MannaListViewModel {
    let disposeBag = DisposeBag()
    
    let addManna = PublishSubject<Void>()
    let mannas = BehaviorSubject<[MannaListModel]>(value: [])
    let allMannas: Observable<[MannaListModel]>


    init() {
        allMannas = mannas
    
//        mannas.onNext([
//            MannaListModel(title: "Dummy", place: "Dummy", appointmentTime: "Dummy", numberPeople: "Dummy")
//        ])
    }
}
