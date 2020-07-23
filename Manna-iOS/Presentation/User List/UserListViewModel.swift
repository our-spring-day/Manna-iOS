//
//  UserListViewModel.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/01.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class UserListViewModel: Type {
    let disposeBag = DisposeBag()
    
    let friendsList = UserListModel().friends.sorted(by: { $0.name < $1.name })
    var filteredFriendsList = BehaviorRelay(value: [UserTestStruct]())
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var itemsObservable: Observable<[UserTestStruct]> = Observable.of(self.friendsList)
    
    init() {
        searchValueObservable
            .subscribe(onNext: { value in
                self.itemsObservable.map({ $0.filter({
                    if value.isEmpty { return true }
                    return  ($0.name.lowercased().contains(value.lowercased()))
                })
                }).bind( to: self.filteredFriendsList )
            }).disposed(by: disposeBag)
    }
}
