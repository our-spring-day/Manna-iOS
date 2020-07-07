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
    var title: Observable<String> { get }
    var people: Observable<String> { get }
    var time: Observable<String> { get }
    var place: Observable<String> { get }
}

protocol AddMannaViewModelOutput {
}

protocol AddMannaViewModelType {
    var inputs: AddMannaViewModelInput { get }
    var outputs: AddMannaViewModelOutput { get }
}

class AddMannaViewModel: AddMannaViewModelInput, AddMannaViewModelOutput, AddMannaViewModelType {
    let disposeBag = DisposeBag()
    
    let title: Observable<String>
    let people: Observable<String>
    let time: Observable<String>
    let place: Observable<String>
    
    
    init() {
        let titleInput = PublishSubject<String>()
        let peopleInput = PublishSubject<String>()
        let timeInput = PublishSubject<String>()
        let placeInput = PublishSubject<String>()
        
        title = titleInput.asObservable()
        people = peopleInput.asObservable()
        time = timeInput.asObservable()
        place = placeInput.asObservable()
        
        Observable.zip(title, people, time, place)
            .subscribe {
                print($0)
            }
            .disposed(by: disposeBag)

    }
    
    var inputs: AddMannaViewModelInput { return self }
    var outputs: AddMannaViewModelOutput { return self }
}
