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
    var searchedFriendID: AnyObserver<String> { get }
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
    var searchedFriendID: AnyObserver<String>
    
    //outputs
    var friendList: Observable<[UserTestStruct]>
    var checkedFriendList: Observable<[UserTestStruct]>
    
    
    init() {
        let INDXInput = PublishSubject<IndexPath>()
        let ITMInput = PublishSubject<UserTestStruct>()
        let SRCHInput = PublishSubject<String>()
        
        let originalFriendList = FriendListViewModel.self.myFriendList
        let friendListOutput = PublishSubject<[UserTestStruct]>()
        let checkedFriendListOutput = BehaviorRelay<[UserTestStruct]>(value: [])
        
        indexFromTableView = INDXInput.asObserver()
        itemFromCollectionView = ITMInput.asObserver()
        searchedFriendID = SRCHInput.asObserver()
        
        friendList = friendListOutput.asObservable()
        checkedFriendList = checkedFriendListOutput.asObservable()
        
        //checkedFriendList update with tableView
        INDXInput
            .subscribe(onNext: { index in
                var newOriginalValue = originalFriendList.value
                var newCheckValue = checkedFriendListOutput.value
                
                if newOriginalValue[index[1]].checkedFlag == 0 {
                    newOriginalValue[index[1]].checkedFlag = 1
                    newCheckValue.append(newOriginalValue[index[1]])
                } else {
                    newOriginalValue[index[1]].checkedFlag = 0
                    newCheckValue.remove(at: newCheckValue.firstIndex(where: { $0.name == newOriginalValue[index[1]].name })!)
                }
                originalFriendList.accept(newOriginalValue)
                checkedFriendListOutput.accept(newCheckValue)
            }).disposed(by: disposeBag)
        
        //checkedMemberArray update with collectionView
        ITMInput
            .subscribe(onNext: { item in
                var newOriginalValue = originalFriendList.value
                var newCheckValue = checkedFriendListOutput.value
                
                newOriginalValue[newOriginalValue.firstIndex(where: {$0.name == item.name})!].checkedFlag = 0
                newCheckValue.remove(at: newCheckValue.firstIndex(where: { $0.name == item.name})!)
                
                originalFriendList.accept(newOriginalValue)
                checkedFriendListOutput.accept(newCheckValue)
            }).disposed(by: disposeBag)
        
        //friendList update with searchValue
        SRCHInput
            .subscribe(onNext: { value in
                originalFriendList.map { $0.filter {
                    if value.isEmpty { return true }
                    return ($0.name.lowercased().contains(value.lowercased()))
                    }}
                    .map { $0.sorted(by: { $0.name < $1.name }) }
                    .bind(to: friendListOutput)
            }).disposed(by: disposeBag)
    }
    var inputs: InviteFriendsViewModellInput { return self }
    var outputs: InviteFriendsViewModelOutput { return self }
}
