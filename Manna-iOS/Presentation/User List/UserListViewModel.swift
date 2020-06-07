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
}
protocol Type {
    var inputs: Input { get }
    var outputs: Output { get }
}
struct UserListViewModel: Type, Input, Output {
    var friendsId: Observable<[String]>
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
        self.friendsId = Observable.of(userListModel.friends)
    }
    var inputs: Input { return self }
    var outputs: Output { return self }
}
