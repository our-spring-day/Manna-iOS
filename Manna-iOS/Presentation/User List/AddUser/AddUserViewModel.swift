//
//  AddUserViewModel.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/26.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class AddUserViewModel: Type {
    let disposeBag = DisposeBag()
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    var filteredUser = BehaviorRelay(value: [])
    let friendsList = UserListTestStruct().userListTestStruct
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var itemsObservable: Observable<[String]> = Observable.of(self.friendsList)
    init() {
        searchValueObservable
            .subscribe(onNext: { value in
                self.itemsObservable.map({ $0.filter({
                    if value.isEmpty { return true }
                    return  ($0.lowercased().contains(value.lowercased()))
                })
                }).bind(to: self.filteredUser)
            }).disposed(by: disposeBag)
    }
}
