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
    
    var inputs: Input { get }
    var outputs: Output? { get }
}
class UserListViewModel: Type {
    let disposeBag = DisposeBag()
    let inputs: Input
    var outputs: Output?
    let userListModel: UserListModel?
    init(input: Input) {
        self.inputs = input
        userListModel = UserListModel()
        let filteredFriends = input.searchKeyword.asObservable()
            .filterEmpty()
            .subscribe(onNext: {skw in
                print(self.userListModel!.friends.filter{ $0.lowercased().contains( skw.lowercased() )})
            })
        //        self.outputs = Output(showFriends: filteredFriends)
        
        //        self.outputs = Output(showFriends: Observable. )
        
        
        //        self.outputs = Output(showFriends: filteredFriends)
    }
}
extension UserListViewModel {
    struct Input {
        let searchKeyword: Observable<String>
    }
    struct Output {
        var showFriends: Observable<String>
    }
}
