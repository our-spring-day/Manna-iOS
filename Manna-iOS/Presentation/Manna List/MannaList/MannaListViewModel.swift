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

protocol MannaListViewModelOutput {
    var allMannas: Observable<[MannaSection]> { get }
}

protocol MannaListViewModelType {
    var outputs: MannaListViewModelOutput { get }
}

class MannaListViewModel: MannaListViewModelType, MannaListViewModelOutput {
    let allMannas: Observable<[MannaSection]>
    
    init() {
        allMannas = MannaProvider.observable()
    }
    
    var outputs: MannaListViewModelOutput { return self }
}
