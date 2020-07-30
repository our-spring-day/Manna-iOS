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
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.itemsObservable.map{
                    $0.filter{ key in
                        if key.name == value {
                            //검색어와 일치하는 아이디가 있을 때
                            return true
                        } else {
                            //검색어와 일치하는 아이디가 없을 때
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
