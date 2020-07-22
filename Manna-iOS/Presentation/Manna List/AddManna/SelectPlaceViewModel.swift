//
//  SelectPlaceViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/07/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SelectPlaceViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class SelectPlaceViewModel: SelectPlaceViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    init(_ searchAddress: String) {
        let address = Observable.just(searchAddress)
    }
}
