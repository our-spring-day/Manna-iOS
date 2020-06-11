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

protocol Type {
    associatedtype Input
    associatedtype Output
    
    var inputs: Input? { get }
    var outputs: Output? { get }
}
class UserListViewModel: Type {
    let disposeBag = DisposeBag()
    var inputs: Input?
    var outputs: Output?
    var userListModel = UserListModel()
    var sortedFriends: [String]?
    var filteredFriends: [String]?
    init(input: Input) {
        self.inputs = input
        input.searchKeyword.asObservable()
            .filter{ self.userListModel.friends.contains($0.lowercased())}
            .subscribe(onNext: { skw in
//                self.filteredFriends = self.userListModel.friends.filter{ $0.lowercased().contains( skw.lowercased())}
            })
            .disposed(by: disposeBag)
        sortedFriends = (userListModel.friends.sorted())
//        print(sortedFriends!)
        self.outputs = Output(showFriends: Observable.of(sortedFriends!)) 
        print(outputs?.showFriends)
    }
}
extension UserListViewModel {
    struct Input {
        let searchKeyword: Observable<String>
    }
    struct Output {
        var showFriends: Observable<[String]>
    }
}
