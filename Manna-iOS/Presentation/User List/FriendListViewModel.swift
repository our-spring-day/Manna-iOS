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

protocol UserListViewModelInput {
    var searchValue: AnyObserver<String> { get }
    var deletedFriend: AnyObserver<UserTestStruct> { get }
    var newFriend: AnyObserver<UserTestStruct> { get }
}

protocol UserListViewModelOutput {
    static var filteredFriendsList: BehaviorRelay<[UserTestStruct]> { get }
}

protocol UserListViewModelType {
    var inputs: UserListViewModelInput { get }
    var outputs: UserListViewModelOutput { get }
}

class FriendListViewModel: UserListViewModelType,UserListViewModelInput,UserListViewModelOutput {
    let disposeBag = DisposeBag()
    
    var searchValue: AnyObserver<String>
    var deletedFriend: AnyObserver<UserTestStruct>
    var newFriend: AnyObserver<UserTestStruct>
    static var friendsOB = BehaviorRelay<[UserTestStruct]>(value: UserListModel.friendList)
    static var filteredFriendsList = BehaviorRelay(value: [UserTestStruct]())
    
    init() {
        //input
        let searchValueInput = PublishSubject<String>()
        let deletedFriendInput = PublishSubject<UserTestStruct>()
        let newFriendInput = PublishSubject<UserTestStruct>()
        
        //output
        //searchValue 가 searchValueInput의 옵져버니까 searchvaluinput이 옵져버블이 되는 그런건가?
        searchValue = searchValueInput.asObserver()
        deletedFriend = deletedFriendInput.asObserver()
        newFriend = newFriendInput.asObserver()
        
        searchValueInput
            .subscribe(onNext: { value in
                FriendListViewModel.self.friendsOB.map({ $0.filter({
                    if value.isEmpty { return true }
                    return  ($0.name.lowercased().contains(value.lowercased()))})
                })
                    .map({$0.sorted(by: {$0.name < $1.name})})
                    .bind(to: FriendListViewModel.self.filteredFriendsList )
            }).disposed(by: disposeBag)
        
        deletedFriendInput
            .subscribe(onNext: { item in
                var newValue = FriendListViewModel.self.friendsOB.value
                newValue.remove(at: newValue.firstIndex(where: { $0.name == item.name })!)
                FriendListViewModel.self.friendsOB.accept(newValue)
            }).disposed(by: disposeBag)
        
        newFriendInput
            .subscribe(onNext: { item in
                var newValue = FriendListViewModel.self.friendsOB.value
                newValue.append(item)
                newValue = newValue.sorted(by: { $0.name < $1.name })
                FriendListViewModel.self.friendsOB.accept(newValue)
            })
            .disposed(by: disposeBag)
    }
    var inputs: UserListViewModelInput { return self }
    var outputs: UserListViewModelOutput { return self }
}
