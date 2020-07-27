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
    static var friendsOB = BehaviorRelay<[UserTestStruct]>(value: UserListModel.friendList)
    static var filteredFriendsList = BehaviorRelay(value: [UserTestStruct]())
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    var deletedFriends: BehaviorRelay<IndexPath> = BehaviorRelay(value: [])
    var newFriend: PublishSubject<UserTestStruct> = PublishSubject<UserTestStruct>()
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    
    init() {
        searchValueObservable
            .subscribe(onNext: { value in
                UserListViewModel.self.friendsOB.map({ $0.filter({
                    if value.isEmpty { return true }
                    return  ($0.name.lowercased().contains(value.lowercased()))})
                })
                    .map({$0.sorted(by: {$0.name < $1.name})})
                    .bind(to: UserListViewModel.self.filteredFriendsList )
            }).disposed(by: disposeBag)
        
        deletedFriends
            .skip(1)
            .map { $0[1] }
            .subscribe(onNext: { index in
                var newValue = UserListViewModel.self.filteredFriendsList.value
                newValue.remove(at: index)
                UserListViewModel.self.filteredFriendsList.accept(newValue)
            }).disposed(by: disposeBag)
        
        newFriend
            .debug()
            .subscribe(onNext: { item in
                var newValue = UserListViewModel.self.filteredFriendsList.value
                newValue.append(item)
                newValue = newValue.sorted(by: { $0.name < $1.name })
                UserListViewModel.self.filteredFriendsList.accept(newValue)
            })
            .disposed(by: disposeBag)
    }
}
