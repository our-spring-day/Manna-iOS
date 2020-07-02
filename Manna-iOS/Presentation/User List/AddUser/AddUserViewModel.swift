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
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    var filteredUser = BehaviorRelay(value: [])
    let friendsList = UserListTestStruct().userListTestStruct
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var itemsObservable: Observable<[String]> = Observable.of(self.friendsList)
    init() {
        searchValueObservable
            .subscribe(onNext: { value in
                print("firstIndex : ", (self.friendsList.firstIndex(of: value)) == nil)
                self.itemsObservable.map({ $0.filter({
                    if value.isEmpty {
                        //검색어를 입력하라 라는 다이얼로그
                        return false
                    }
                    if (self.friendsList.firstIndex(of: value)) != nil {
                        return  $0.lowercased().contains(value.lowercased())
                    }
                    else {
                        //매칭되는 아이디가 없다는 뷰
                        return false
                    }
                })
                }).bind(to: self.filteredUser)
            }).disposed(by: disposeBag)
    }
}
