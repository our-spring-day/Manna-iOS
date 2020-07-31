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
}

protocol AddUserViewModelOutput {
    var filteredUser: Observable<UserTestStruct> { get }
}

protocol AddUserViewModelType {
    var inputs: AddUserViewModelInput { get }
    var outputs: AddUserViewModelOutput { get }
}

class AddUserViewModel: AddUserViewModelType, AddUserViewModelInput, AddUserViewModelOutput {
    let disposeBag = DisposeBag()
    //input
    let searchedUserID: AnyObserver<String>
    //output
    var filteredUser: Observable<UserTestStruct>
    var itemsObservable = Observable.of(UserListTestStruct().userListTestStruct)
    
    init() {
        let searchedUserIDInput = PublishSubject<String>()
        var filteredUserOutput = PublishSubject<UserTestStruct>()
        
        searchedUserID = searchedUserIDInput.asObserver()
        filteredUser = filteredUserOutput.asObservable()
        
        searchedUserIDInput
            .filterEmpty()
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.itemsObservable.map{
                    $0.filter{ key in
                        if key.name == value {
                            return true
                        } else {
                            return false
                        }
                    }
                }
                .filterEmpty()
                .map({ $0[0] })
                .bind(to: filteredUserOutput)
            }).disposed(by: disposeBag)
    }
    
    var inputs: AddUserViewModelInput { return self }
    var outputs: AddUserViewModelOutput { return self }
}
