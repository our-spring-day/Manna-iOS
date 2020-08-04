//
//  InviteFriendsViewModel.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/31.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol InviteFriendsViewModellInput {
    var indexFromTableView: AnyObserver<IndexPath> { get }
    var itemFromCollectionView: AnyObserver<UserTestStruct> { get }
}

protocol InviteFriendsViewModelOutput {
    var friendList: Observable<[UserTestStruct]> { get }
    var checkedFriendList: Observable<[UserTestStruct]> { get }
}

protocol InviteFriendsViewModelType {
    var inputs: InviteFriendsViewModellInput { get }
    var outputs: InviteFriendsViewModelOutput { get }
}

class InviteFriendsViewModel: InviteFriendsViewModelType, InviteFriendsViewModellInput, InviteFriendsViewModelOutput {
    
    let disposeBag = DisposeBag()
    //inputs
    var indexFromTableView: AnyObserver<IndexPath>
    var itemFromCollectionView: AnyObserver<UserTestStruct>
    
    //outputs
    var friendList: Observable<[UserTestStruct]>
    var checkedFriendList: Observable<[UserTestStruct]>
    
    
    init() {
        var INDXInput = PublishSubject<IndexPath>()
        var ITMInput = PublishSubject<UserTestStruct>()
        var friendListOutput = FriendListViewModel.self.myFriendList
        var checkedFriendListOutput = PublishSubject<[UserTestStruct]>()
        
        indexFromTableView = INDXInput.asObserver()
        itemFromCollectionView = ITMInput.asObserver()
        friendList = friendListOutput.asObservable()
        checkedFriendList = checkedFriendListOutput.asObservable()
    
        //friendList <-bind-> checkedFriendList
        friendListOutput
            .map { $0.filter { $0.checkedFlag == 1 } }
            .bind(to: checkedFriendListOutput)
            .disposed(by: disposeBag)
        
        //checkedFriendList update with tableView
        INDXInput
            .subscribe(onNext: { index in
                var flagValue = FriendListViewModel.self.myFriendList.value
                if flagValue[index[1]].checkedFlag == 0 {
                    flagValue[index[1]].checkedFlag = 1
                } else {
                    flagValue[index[1]].checkedFlag = 0
                }
                FriendListViewModel.self.myFriendList.accept(flagValue)
            }).disposed(by: disposeBag)
        
        //checkedMemberArray update with collectionView
        ITMInput
            .subscribe(onNext: { item in
                var flagValue = FriendListViewModel.self.myFriendList.value
                flagValue[flagValue.firstIndex(where: {$0.name == item.name})!].checkedFlag = 0
                FriendListViewModel.self.myFriendList.accept(flagValue)
            }).disposed(by: disposeBag)
    }
    var inputs: InviteFriendsViewModellInput { return self }
    var outputs: InviteFriendsViewModelOutput { return self }
}
