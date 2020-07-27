//
//  SelectPlacePinViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/07/28.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SelectPlacePinViewModelInput {
    var longitude: AnyObserver<Double> { get }
    var latitude: AnyObserver<Double> { get }
}
protocol SelectPlacePinViewModelOutput {
    var address: Observable<String> { get }
}

protocol SelectPlacePinViewModelType {
    var inputs: SelectPlacePinViewModelInput { get }
    var outputs: SelectPlacePinViewModelOutput { get }
}
class SelectPlacePinViewModel: SelectPlacePinViewModelType, SelectPlacePinViewModelInput, SelectPlacePinViewModelOutput {
    // input
    let longitude: AnyObserver<Double>
    let latitude: AnyObserver<Double>
    
    // output
    let address: Observable<String>
    
    let disposeBag = DisposeBag()
    
    init() {
        let lngInput = PublishSubject<Double>()
        let latInput = PublishSubject<Double>()
        
        let addressOut = BehaviorRelay<String>(value: "")
        
        longitude = lngInput.asObserver()
        latitude = latInput.asObserver()
        
        Observable.combineLatest(lngInput, latInput)
            .flatMap { AddressAPI.getAddress($0, $1) }
            .map { $0.address }
            .subscribe(onNext: { str in
            addressOut.accept(str)
            })
            .disposed(by: disposeBag)
        
        address = addressOut.asObservable()
        
    }
    var inputs: SelectPlacePinViewModelInput { return self }
    var outputs: SelectPlacePinViewModelOutput { return self }
    
}
