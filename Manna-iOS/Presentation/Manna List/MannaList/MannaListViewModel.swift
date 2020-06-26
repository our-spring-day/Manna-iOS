//
//  MannaListViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/05/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol MannaListViewModelInput {
    var allMannas: Observable<[MannaSection]> { get }
}

protocol MannaListViewModelType {
    var input: MannaListViewModelInput { get }
}

class MannaListViewModel: MannaListViewModelType, MannaListViewModelInput {
    
    init() {
        allMannas = MannaProvider.observable()
    }
    
    let allMannas: Observable<[MannaSection]>
    var input: MannaListViewModelInput { return self } // 지금 일단 쓰이진 않음
}
