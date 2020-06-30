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
//    var title: Observable<String> { get }
//    var people: Observable<String> { get }
//    var time: Observable<String> { get }
//    var place: Observable<String> { get }
}

protocol AddMannaViewModelOutput {

}

protocol AddMannaViewModelType {
    var inputs: AddMannaViewModelInput { get }
    var outputs: AddMannaViewModelOutput { get }
}

class AddMannaViewModel: AddMannaViewModelInput, AddMannaViewModelOutput, AddMannaViewModelType {
    let disposeBag = DisposeBag()
    
    
    
        
    var outputs: AddMannaViewModelOutput { return self }
    var inputs: AddMannaViewModelInput { return self }
}
