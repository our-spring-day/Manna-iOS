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

protocol  Type {
    var searchValue: BehaviorRelay<String> { get }
}
class UserListViewModel: Type {
    let disposeBag = DisposeBag()
    let friendsList = UserListModel().friends.sorted()
    var filteredFriendsList: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var itemsObservable: Observable<[String]> = Observable.of(self.friendsList)
    lazy var filteredItemobservable: Observable<[String]> = self.filteredFriendsList.asObservable()
    init() {
        searchValueObservable
            .subscribe(onNext: { value in
                //이부분 계속 응용가능할듯
                self.itemsObservable.map({ $0.filter({
                    if value.isEmpty { return true }
                    return  ($0.lowercased().contains(value.lowercased()))
                })
                }).bind(to: self.filteredFriendsList)
            }).disposed(by: disposeBag)
    }
}
