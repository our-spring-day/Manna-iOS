//
//  PlaceAddMannaViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/07/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PlaceAddMannaViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class PlaceAddMannaViewModel: PlaceAddMannaViewModelType {
    struct Input {
        let address = PublishSubject<String>()
    }
    
    struct Output {
        
    }
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    init() {
        
    }
}
