//
//  AddMannaViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/06/09.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddMannaViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class AddMannaViewModel: AddMannaViewModelType {
    struct Input {
        let title = PublishSubject<String>()
        let people = PublishSubject<String>()
        let time = PublishSubject<String>()
        let place = PublishSubject<String>()
        
//        let address = PublishSubject<String>()
    }
    
    struct Output {
        let addressResult = BehaviorRelay<[Address]>(value: [Address]())
        let addressRoad = ReplaySubject<String>.create(bufferSize: 1)
    }
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    init() {
        let titleInput = input.title
        let peopleInput = input.people
        let timeInput = input.time
        let placeInput = input.place
        
//        input.address
//            .debug()
//            .subscribe(onNext: { [weak self] str in
//                print("str1111 : \(str)")
//                self?.output.addressRoad.onNext(str)
//            })
//            .disposed(by: disposeBag)
        
        Observable.zip(titleInput, peopleInput, timeInput, placeInput)
            .subscribe(onNext: { title, people, time, place in
                let manna = Manna(title: title, numberPeople: people, appointmentTime: time, place: place)
                MannaProvider.addManna(data: manna)
            })
            .disposed(by: disposeBag)
    }
}
