
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
    var itemFromTableView: AnyObserver<UserTestStruct> { get }
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
    var itemFromTableView: AnyObserver<UserTestStruct>
    var itemFromCollectionView: AnyObserver<UserTestStruct>
    var searchedFriendID: AnyObserver<String>
    
    //outputs
    var friendList: Observable<[UserTestStruct]>
    var checkedFriendList: Observable<[UserTestStruct]>
    
    
    init() {
        let itemFromTableViewInput = PublishSubject<UserTestStruct>()
        let itemFromCollectionViewInput = PublishSubject<UserTestStruct>()
        let SRCHInput = PublishSubject<String>()
        
        let originalFriendList = BehaviorRelay<[UserTestStruct]>(value: UserListModel.originalFriendList)
        let friendListOutput = BehaviorRelay<[UserTestStruct]>(value: originalFriendList.value)
        let checkedFriendListOutput = BehaviorRelay<[UserTestStruct]>(value: [])
        
        itemFromTableView = itemFromTableViewInput.asObserver()
        itemFromCollectionView = itemFromCollectionViewInput.asObserver()
        searchedFriendID = SRCHInput.asObserver()
        
        friendList = friendListOutput.asObservable()
        checkedFriendList = checkedFriendListOutput.asObservable()
        
        //checkedFriendList update with tableView
        itemFromTableViewInput
            .subscribe(onNext: { item in
                var newOriginalValue = originalFriendList.value
                var newCheckValue = checkedFriendListOutput.value
                if newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag == 0 {
                    newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag = 1
                    newCheckValue.insert(newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!], at: 0)
                } else {
                    newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag = 0
                    newCheckValue.remove(at: newCheckValue.firstIndex(where: { $0.name == item.name })!)
                }
                originalFriendList.accept(newOriginalValue)
                checkedFriendListOutput.accept(newCheckValue)
            }).disposed(by: disposeBag)
        
        //checkedMemberArray update with collectionView
        itemFromCollectionViewInput
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
            .flatMapLatest { (value) -> Observable<[UserTestStruct]> in
                let result = originalFriendList.map { list in
                    list.filter {
                        if value.isEmpty { return true }
                        return ($0.name.lowercased().contains(value.lowercased()))
                    }}
                    .map { $0.sorted(by: { $0.name < $1.name }) }
                return result
        }
        .bind(to: friendListOutput)
        .disposed(by: disposeBag)
    }
    
    var inputs: InviteFriendsViewModellInput { return self }
    var outputs: InviteFriendsViewModelOutput { return self }
}
