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

protocol FriendListViewModelInput {
    var searchedFriendID: AnyObserver<String> { get }
    var deletedFriend: AnyObserver<UserTestStruct> { get }
    var requestingFriend: AnyObserver<UserTestStruct> { get }
}

protocol FriendListViewModelOutput {
    static var myFriendList: BehaviorRelay<[UserTestStruct]> { get }
}

protocol FriendListViewModelType {
    var inputs: FriendListViewModelInput { get }
    var outputs: FriendListViewModelOutput { get }
}

class FriendListViewModel: FriendListViewModelType,FriendListViewModelInput, FriendListViewModelOutput {
    
    let disposeBag = DisposeBag()
    //input
    var searchedFriendID: AnyObserver<String>
    var deletedFriend: AnyObserver<UserTestStruct>
    var requestingFriend: AnyObserver<UserTestStruct>
    //output
    static var myFriendList = BehaviorRelay(value: [UserTestStruct]())
    static var originalFriendList = BehaviorRelay<[UserTestStruct]>(value: UserListModel.originalFriendList)
    
    init() {
        let searchedUserIDInput = PublishSubject<String>()
        let deletedFriendInput = PublishSubject<UserTestStruct>()
        let requestingFriendInput = PublishSubject<UserTestStruct>()
        
        searchedFriendID = searchedUserIDInput.asObserver()
        deletedFriend = deletedFriendInput.asObserver()
        requestingFriend = requestingFriendInput.asObserver()
        
        searchedUserIDInput
        .debug()
            .subscribe(onNext: { value in
                FriendListViewModel.self.originalFriendList.map({ $0.filter({
                    if value.isEmpty { return true }
                    return  ($0.name.lowercased().contains(value.lowercased()))})
                })
                    .map({$0.sorted(by: {$0.name < $1.name})})
                    .bind( to: FriendListViewModel.self.myFriendList ).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        deletedFriendInput
            .subscribe(onNext: { item in
                var newValue = FriendListViewModel.self.originalFriendList.value
                newValue.remove(at: newValue.firstIndex(where: { $0.name == item.name })!)
                FriendListViewModel.self.originalFriendList.accept(newValue)
            }).disposed(by: disposeBag)
        
        requestingFriendInput
            .subscribe(onNext: { item in
                var newValue = FriendListViewModel.self.originalFriendList.value
                newValue.append(item)
                newValue = newValue.sorted(by: { $0.name < $1.name })
                FriendListViewModel.self.originalFriendList.accept(newValue)
            })
            .disposed(by: disposeBag)
    }
    var inputs: FriendListViewModelInput { return self }
    var outputs: FriendListViewModelOutput { return self }
}
