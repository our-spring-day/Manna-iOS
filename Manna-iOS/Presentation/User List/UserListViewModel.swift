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

protocol  Type {
    associatedtype Input
    associatedtype Output
    var input: Input { get }
    var output: Output { get }
}
class UserListViewModel: Type {
    var output: Output
    let input: Input
    let disposeBag = DisposeBag()
    let friendsList = UserListModel().friends.sorted()
    var filteredFriendsList: [String] = [""]
    init(input: Input) {
        self.input = input
        self.output = Output(showFriendsList: friendsList)
        self.input.text
            .subscribe(onNext: { searchKeyword in
                self.filteredFriendsList.removeAll()
                self.filteredFriendsList = self.friendsList.filter { $0.hasPrefix(searchKeyword) }
                self.output = Output(showFriendsList: self.filteredFriendsList)
            }).disposed(by: disposeBag)
        self.output = Output(showFriendsList: self.friendsList)
    }
}

extension UserListViewModel {
    struct Input {
        let text: Observable<String>
    }
    struct Output {
        let showFriendsList: [String]
    }
}
