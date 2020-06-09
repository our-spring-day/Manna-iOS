//
//  MannaListViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/05/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MannaListViewModelInput {
}
protocol MannaListViewModelOutput {
}

protocol MannaListViewModelType {
    var inputs: MannaListViewModelInput { get }
    var outputs: MannaListViewModelOutput { get }
}

class MannaListViewModel: MannaListViewModelInput, MannaListViewModelOutput, MannaListViewModelType {
    
    var inputs: MannaListViewModelInput { return self }
    var outputs: MannaListViewModelOutput { return self }
    
    var mannaObservable = BehaviorSubject<[Manna]>(value: [])
}
