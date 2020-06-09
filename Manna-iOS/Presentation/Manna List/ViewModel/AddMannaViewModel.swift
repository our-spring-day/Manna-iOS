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
}
protocol AddMannaViewModelOutput {
}

protocol AddMannaViewModelType {
    var inputs: MannaListViewModelInput { get }
    var outputs: MannaListViewModelOutput { get }
}

class AddMannaViewModel: AddMannaViewModelInput, AddMannaViewModelOutput, AddMannaViewModelType {
    
    var inputs: MannaListViewModelInput { return self }
    var outputs: MannaListViewModelOutput { return self }
}
