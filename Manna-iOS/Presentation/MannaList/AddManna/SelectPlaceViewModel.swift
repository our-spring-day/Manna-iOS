//
//  SelectPlaceViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/08/11.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
protocol SelectPlaceViewModelInput {
    var address: AnyObserver<String> { get }
}
protocol SelectPlaceViewModelOutput {
    var addressArr: Observable<[Address]> { get }
}

protocol SelectPlaceViewModelType {
    var inputs: SelectPlaceViewModelInput { get }
    var outputs: SelectPlaceViewModelOutput { get }
}

class SelectPlaceViewModel: SelectPlaceViewModelType, SelectPlaceViewModelInput, SelectPlaceViewModelOutput {
    let disposeBag = DisposeBag()
    
    let address: AnyObserver<String>
    
    let addressArr: Observable<[Address]>
    
    init() {
        let addressInput = PublishSubject<String>()

        let addressOutput = BehaviorRelay<[Address]>(value: [])
        
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
        
    }
    
    var inputs: SelectPlaceViewModelInput { return self }
    var outputs: SelectPlaceViewModelOutput { return self }
}
