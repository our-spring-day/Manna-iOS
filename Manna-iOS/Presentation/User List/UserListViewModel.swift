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
    
    var friendsOB = BehaviorRelay<[UserTestStruct]>(value: [namjihyeon, juyeon, bomin, mino, beenzino, gdragon, iuzzang, jenny, jisoo, jpark, crush, bloo, rain, kimwoobin, kingkihoon, munchan2])
    var filteredFriendsList = BehaviorRelay(value: [UserTestStruct]())
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    var deletedFriends: BehaviorRelay<IndexPath> = BehaviorRelay(value: [])
    var newFriend: PublishSubject<UserTestStruct> = PublishSubject<UserTestStruct>()
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    
    init() {
        searchValueObservable
            .subscribe(onNext: { value in
                self.friendsOB.map({ $0.filter({
                    if value.isEmpty { return true }
                    return  ($0.name.lowercased().contains(value.lowercased()))
                })
                }).bind(to: self.filteredFriendsList )
            }).disposed(by: disposeBag)
        
        deletedFriends
            .subscribe(onNext: {index in
                //                self.friendsList.remove(at: index[1])
            }).disposed(by: disposeBag)
        
        newFriend
            .debug("이거에연?")
            .subscribe(onNext:{ item in
                var newValue = self.friendsOB.value
                newValue.append(item)
                self.friendsOB.accept(newValue)
            })
            .disposed(by: disposeBag)
    }
}
