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
    var outputs: Output { get }
}
class UserListViewModel: Type {
    let disposeBag = DisposeBag()
    let inputs: Input
    let outputs: Output
    let userListModel: UserListModel
    
    init(input: Input) {
        self.inputs = input
        userListModel = UserListModel()
        
        let filteredFriends = input.searchKeyword.asObservable()
            .subscribe(onNext: {skw in
                self.userListModel.friends.filter{ $0.lowercased().contains(skw.lowercased())}
            })
        .disposed(by: disposeBag)
        //        let filteredFriends = input.searchKeyword.asObservable()
        //            .flatMap{ skw in self.userListModel.friends.filter {
        //            $0.localizedCaseInsensitiveContains(skw)}}
        //            });.disposed(by: disposeBag)
        
        //        filteredFridensIdObservable.subscribe(onNext: {value in
        //            print("Search value received = \(value)'")
        //
        //            self.friendsId.map({ $0.filter({
        //                if value.isEmpty {return true}
        //                return ($0.lowercased().contains(value.lowercased()))
        //            })
        //            })
        //            }).disposed(by: disposeBag)
        self.outputs = Output(showFriends: filteredFriends)
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
