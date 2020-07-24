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
    var title: AnyObserver<String> { get }
    var people: AnyObserver<String> { get }
    var time: AnyObserver<String> { get }
    var place: AnyObserver<String> { get }
    var address: AnyObserver<String> { get }
}
protocol AddMannaViewModelOutput {
    var addressOut: Observable<[Address]> { get }
}

protocol AddMannaViewModelType {
    var inputs: AddMannaViewModelInput { get }
    var outputs: AddMannaViewModelOutput { get }
}

class AddMannaViewModel: AddMannaViewModelType, AddMannaViewModelInput, AddMannaViewModelOutput {
    
    let title: AnyObserver<String>
    let people: AnyObserver<String>
    let time: AnyObserver<String>
    let place: AnyObserver<String>
    let address: AnyObserver<String>
    
    let addressOut: Observable<[Address]>
    
    let disposeBag = DisposeBag()
    
    init() {
        // Input
        let titleInput = PublishSubject<String>()
        let peopleInput = PublishSubject<String>()
        let timeInput = PublishSubject<String>()
        let placeInput = PublishSubject<String>()
        let addressInput = PublishSubject<String>()

        // Output
        let addressOutput = BehaviorRelay<[Address]>(value: [])
//        let addressOutput = Variable<[Address]>([])
        
        title = titleInput.asObserver()
        people = peopleInput.asObserver()
        time = timeInput.asObserver()
        place = placeInput.asObserver()
        address = addressInput.asObserver()
        
        addressInput
            .debug()
            .map({ "\($0)" })
            .do(onNext: {
                print("지나가는지 : \($0)")
            })
            .flatMap({ AddressAPI.getAddress($0)})
            .subscribe(onNext: { value in
                addressOutput.accept(value)
            })
            .disposed(by: disposeBag)

        addressOut = addressOutput.asObservable()
        
        addressOut.subscribe {
            print("아웃풋 : \($0)")
        }
        
        Observable.zip(titleInput, peopleInput, timeInput, placeInput)
            .subscribe(onNext: { title, people, time, place in
                let manna = Manna(title: title, numberPeople: people, appointmentTime: time, place: place)
                MannaProvider.addManna(data: manna)
            })
            .disposed(by: disposeBag)
    }
    
    var inputs: AddMannaViewModelInput { return self }
    var outputs: AddMannaViewModelOutput { return self }
}
