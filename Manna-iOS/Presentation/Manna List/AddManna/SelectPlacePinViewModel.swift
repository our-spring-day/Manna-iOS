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
    var address: Observable<Address> { get }
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
    let address: Observable<Address>
    
    let disposeBag = DisposeBag()
    
    init(model: SelectPlacePinModel = SelectPlacePinModel()) {
        let lngInput = PublishSubject<Double>()
        let latInput = PublishSubject<Double>()
        
        let addressOutput = PublishRelay<Address>()
        
        longitude = lngInput.asObserver()
        latitude = latInput.asObserver()
        
        Observable.combineLatest(lngInput, latInput)
            .flatMap({ model.getAddress($0, $1)})
            .subscribe(onNext: { result in
                switch result {
                case .success(let address):
                    addressOutput.accept(address)
                case .failure(let err):
                    print(err)
                }
            })
            .disposed(by: disposeBag)
        
        address = addressOutput.asObservable()
        
    }
    var inputs: SelectPlacePinViewModelInput { return self }
    var outputs: SelectPlacePinViewModelOutput { return self }
    
}
