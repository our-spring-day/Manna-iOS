//
//  AddMannaViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/06/09.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift

protocol AddMannaViewModelInput {
    var total: PublishSubject<Manna> { get }
    var title: PublishSubject<String> { get }
    var people: PublishSubject<String> { get }
    var time: PublishSubject<String> { get }
    var place: PublishSubject<String> { get }
}

protocol AddMannaViewModelType {
    var inputs: AddMannaViewModelInput { get }
}

class AddMannaViewModel: AddMannaViewModelInput, AddMannaViewModelType {
    let disposeBag = DisposeBag()
    
    let total: PublishSubject<Manna> = PublishSubject<Manna>()
    let title: PublishSubject<String> = PublishSubject<String>()
    let people: PublishSubject<String> = PublishSubject<String>()
    let time: PublishSubject<String> = PublishSubject<String>()
    let place: PublishSubject<String> = PublishSubject<String>()
    
    init() {
        title
            .takeLast(1)
            .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        
        people.subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        
        time.subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        
        place.subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        
//        Observable.merge(title, people, time, place)
//                .subscribe{
//                    print($0)
//                }
//                .disposed(by: disposeBag)
    }
    
    var inputs: AddMannaViewModelInput { return self }
}
