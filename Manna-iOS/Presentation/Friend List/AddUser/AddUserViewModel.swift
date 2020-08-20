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

protocol AddUserViewModelInput {
    var searchedUserID: AnyObserver<String> { get }
    var requestingFriend: AnyObserver<Void> { get }
}

protocol AddUserViewModelOutput {
    var filteredUser: Observable<User> { get }
}

protocol AddUserViewModelType {
    var inputs: AddUserViewModelInput { get }
    var outputs: AddUserViewModelOutput { get }
}

class AddUserViewModel: AddUserViewModelType, AddUserViewModelInput, AddUserViewModelOutput {
    
    let disposeBag = DisposeBag()
    //input
    let searchedUserID: AnyObserver<String>
    var requestingFriend: AnyObserver<Void>
    //output
    var filteredUser: Observable<User>
    var itemsObservable = Observable.of(UserListModel().userList)
    
    init() {
        let searchedUserIDInput = PublishSubject<String>()
        let filteredUserOutput = PublishSubject<User>()
        let requestingFriendInput = PublishSubject<Void>()
        
        searchedUserID = searchedUserIDInput.asObserver()
        requestingFriend = requestingFriendInput.asObserver()
        filteredUser = filteredUserOutput.asObservable()
        
        //검색한 아이디로 정확히 맞아떨어지는 것만 출력 -> 떨어지지 않을 시에 대한 예외 처리 해야합니다.
        searchedUserIDInput
            .filterEmpty()
            .distinctUntilChanged()
            .flatMap({ value in
                self.itemsObservable.map {
                    $0.filter { key in
                        if key.name == value { return true } else { return false }
                    }
                }})
            .filterEmpty()
            .map { $0[0] }
            .bind(to: filteredUserOutput)
            .disposed(by: disposeBag)
        
        //친구추가 버튼 눌렀을 때 
        requestingFriendInput.withLatestFrom(filteredUser)
            .subscribe(onNext: { item in
                var newValue = FriendListViewModel.self.originalFriendList.value
                newValue.append(item)
                newValue = newValue.sorted(by: { $0.name < $1.name })
                FriendListViewModel.self.originalFriendList.accept(newValue)
            })
            .disposed(by: disposeBag)
    }
    var inputs: AddUserViewModelInput { return self }
    var outputs: AddUserViewModelOutput { return self }
}
