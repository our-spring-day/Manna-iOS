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
    
    init(model: SelectPlaceModel = SelectPlaceModel()) {
        let addressInput = PublishSubject<String>()
        
        let addressOutput = BehaviorRelay<[Address]>(value: [])
        
        address = addressInput.asObserver()
        
        addressInput
            .flatMap({ model.getAdress($0) })
            .subscribe(onNext: { result in
                switch result {
                case .success(let address):
                    addressOutput.accept(address)
                case .failure(let err):
                    print(err)
                }
            })
            .disposed(by: disposeBag)
        
        addressArr = addressOutput.asObservable()
        
    }
    
    var inputs: SelectPlaceViewModelInput { return self }
    var outputs: SelectPlaceViewModelOutput { return self }
}
