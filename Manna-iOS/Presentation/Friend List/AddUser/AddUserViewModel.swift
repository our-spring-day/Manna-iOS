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
    
    let filteredUser = BehaviorRelay(value: UserTestStruct(name: "", profileImage: "", checkedFlag: 0))
    let friendsList = UserListTestStruct().userListTestStruct
    let searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    var didClick = BehaviorRelay<UserTestStruct>(value: UserTestStruct(name: "", profileImage: "", checkedFlag: 0))
    lazy var itemsObservable = Observable.of(self.friendsList)
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    
    init() {
        searchValueObservable
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
                .bind(to: self.filteredUser)
            }).disposed(by: disposeBag)
        
    }
}
