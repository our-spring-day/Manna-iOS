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
    var longitude: AnyObserver<Double> { get }
    var latitude: AnyObserver<Double> { get }
}
protocol AddMannaViewModelOutput {
    var addressArr: Observable<[Address]> { get }
    var addressSingle: Observable<Address> { get }
}

protocol AddMannaViewModelType {
    var inputs: AddMannaViewModelInput { get }
    var outputs: AddMannaViewModelOutput { get }
}

class AddMannaViewModel: AddMannaViewModelType, AddMannaViewModelInput, AddMannaViewModelOutput {
    
    let disposeBag = DisposeBag()
    
    let title: AnyObserver<String>
    let people: AnyObserver<String>
    let time: AnyObserver<String>
    let place: AnyObserver<String>
    let longitude: AnyObserver<Double>
    let latitude: AnyObserver<Double>
    let address: AnyObserver<String>
    
    let addressArr: Observable<[Address]>
    let addressSingle: Observable<Address>
    
    init() {
        // Input
        let titleInput = PublishSubject<String>()
        let peopleInput = PublishSubject<String>()
        let timeInput = PublishSubject<String>()
        let placeInput = PublishSubject<String>()
        let lngInput = PublishSubject<Double>()
        let latInput = PublishSubject<Double>()
        let addressInput = PublishSubject<String>()

        // Output
        let addressOutput = BehaviorRelay<[Address]>(value: [])
        let addressSingleOutput = BehaviorRelay<Address>(value: Address(address: "", roadAddress: "", lng: "", lat: ""))
        
        title = titleInput.asObserver()
        people = peopleInput.asObserver()
        time = timeInput.asObserver()
        place = placeInput.asObserver()
        longitude = lngInput.asObserver()
        latitude = latInput.asObserver()
        address = addressInput.asObserver()
        
        addressInput
            .debug()
            .map({ "\($0)" })
            .flatMap({ AddressAPI.getAddress($0)})
            .subscribe(onNext: { value in
                addressOutput.accept(value)
            })
            .disposed(by: disposeBag)

        addressArr = addressOutput.asObservable()

        Observable.combineLatest(lngInput, latInput)
            .flatMap { AddressAPI.getAddress($0, $1) }
            .subscribe(onNext: { address in
                addressSingleOutput.accept(address)
            })
            .disposed(by: disposeBag)
        
        addressSingle = addressSingleOutput.asObservable()
        

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
