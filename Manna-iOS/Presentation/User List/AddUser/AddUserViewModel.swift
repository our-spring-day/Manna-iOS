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
    
    var filteredUser = BehaviorRelay(value: [UserTestStruct]())
    let friendsList = UserListTestStruct().userListTestStruct
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    lazy var itemsObservable = Observable.of(self.friendsList)
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    
    init() {
        searchValueObservable
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.itemsObservable.map({ $0.filter({ key in
                    if value.isEmpty {
                        return false
                    } else if key.name == value {
                        return true
                    } else {
                        return false
                    }
                })
                }).bind(to: self.filteredUser)
            }).disposed(by: disposeBag)
    }
}
