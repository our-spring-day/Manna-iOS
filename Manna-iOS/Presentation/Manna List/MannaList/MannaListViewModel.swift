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

protocol MannaListViewModelType {
    var allMannas: Observable<[MannaSection]> { get }
}

struct MannaListViewModel: MannaListViewModelType {
    let disposeBag = DisposeBag()
    
    let allMannas: Observable<[MannaSection]>
    init() {
        allMannas = MannaProvider.observable()
    }
}
