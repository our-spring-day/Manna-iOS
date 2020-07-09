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

protocol AddMannaViewModelInput {
    associatedtype Input
    
    var input: Input { get }
}

//protocol AddMannaViewModelOutput {
//}
//
//protocol AddMannaViewModelType {
//    var inputs: AddMannaViewModelInput { get }
//    var outputs: AddMannaViewModelOutput { get }
//}

class AddMannaViewModel: AddMannaViewModelInput {
    struct Input {
        let title = PublishSubject<String>()
        let people = PublishSubject<String>()
        let time = PublishSubject<String>()
        let place = PublishSubject<String>()
    }
    
    let input = Input()
    let disposeBag = DisposeBag()
    
    init() {
        let titleInput = input.title
        let peopleInput = input.people
        let timeInput = input.time
        let placeInput = input.place
        
        Observable.zip(titleInput, peopleInput, timeInput, placeInput)
            .subscribe(onNext: { title, people, time, place in
                let manna = Manna(title: title, numberPeople: people, appointmentTime: time, place: place)
                MannaProvider.addManna(data: manna)
            })
            .disposed(by: disposeBag)
    }
    
    
   
//    var inputs: AddMannaViewModelInput { return self }
//    var outputs: AddMannaViewModelOutput { return self }
}
