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
    var title: Single<String> { get }
    var people: Single<String> { get }
    var time: Single<String> { get }
    var place: Single<String> { get }
}

protocol AddMannaViewModelOutput {
}

protocol AddMannaViewModelType {
    var inputs: AddMannaViewModelInput { get }
    var outputs: AddMannaViewModelOutput { get }
}

class AddMannaViewModel: AddMannaViewModelInput, AddMannaViewModelOutput, AddMannaViewModelType {
    
    let title: Single<String>
    let people: Single<String>
    let time: Single<String>
    let place: Single<String>
    
    let disposeBag = DisposeBag()
    
//    let title: Observable<String>
//    let people: Observable<String>
//    let time: Observable<String>
//    let place: Observable<String>
    
    init() {
        title = Single<String>
    }
    
    var inputs: AddMannaViewModelInput { return self }
    var outputs: AddMannaViewModelOutput { return self }
}
