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

protocol Input {
    func searchFriends()
    func detailFriends()
    func deleteFriends()
}
protocol Output {
    var friendsId: Observable<[String]> { get }
    var filteredFriendsId: Variable<String> { get }
}
protocol Type {
    var inputs: Input { get }
    var outputs: Output { get }
}
struct UserListViewModel: Type, Input, Output {
    let disposeBag = DisposeBag()
    var filteredFriendsId: Variable<String> = Variable("")
    let testArr: [String]
    var friendsId: Observable<[String]>
    lazy var filteredFridensIdObservable: Observable<String> = self.filteredFriendsId.asObservable()
    func searchFriends() {
        print("searchFriedns")
    }
    func detailFriends() {
        print("detailFriendss")
    }
    func deleteFriends() {
        print("deleteFriends")
    }
    let userListModel: UserListModel
    init() {
        print("UserListViewModel Pass")
        userListModel = UserListModel()
        testArr = userListModel.friends.sorted()
        self.friendsId = Observable.of(testArr)
        filteredFridensIdObservable.subscribe(onNext: {value in
            print("Search value received = \(value)'")
            
            self.friendsId.map({ $0.filter({
                if value.isEmpty {return true}
                return ($0.lowercased().contains(value.lowercased()))
            })
            })
            }).disposed(by: disposeBag)
    }
    var inputs: Input { return self }
    var outputs: Output { return self }
}
