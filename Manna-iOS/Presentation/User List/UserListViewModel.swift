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
    var showFriends: [String] = []
    var filteredFriends: [String]?
    var filteredObservable: Observable<[String]>?
    init(input: Input) {
        self.inputs = input
        input.searchKeyword.asObservable()
            .filterEmpty()
            .debug()
            .subscribe(onNext: {skw in
                let filtered = self.userListModel.friends.filter {$0.lowercased().contains(skw.lowercased())}
                self.filteredFriends = filtered
                if self.filteredFriends == [] || self.filteredFriends == nil {
                    self.showFriends = self.userListModel.friends.sorted()
                } else {
                    self.showFriends = (self.filteredFriends!.sorted())
                }
//                print(self.showFriends)
                self.inputs?.tableView.reloadData()
            }).disposed(by: disposeBag)
        self.showFriends = userListModel.friends.sorted()
        self.outputs = Output(showFriends: showFriends)
    }
}
extension UserListViewModel {
    struct Input {
        let searchKeyword: Observable<String>
        let tableView: UITableView
    }
    struct Output {
        var showFriends: [String]
    }
}
