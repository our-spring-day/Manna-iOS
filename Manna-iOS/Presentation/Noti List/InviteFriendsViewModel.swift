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
    var itemFromTableView: AnyObserver<User> { get }
    var itemFromCollectionView: AnyObserver<User> { get }
    var searchedFriendID: AnyObserver<String> { get }
}

protocol InviteFriendsViewModelOutput {
    var friendList: Observable<[User]> { get }
    var checkedFriendList: Observable<[User]> { get }
}

protocol InviteFriendsViewModelType {
    var inputs: InviteFriendsViewModellInput { get }
    var outputs: InviteFriendsViewModelOutput { get }
}

class InviteFriendsViewModel: InviteFriendsViewModelType, InviteFriendsViewModellInput, InviteFriendsViewModelOutput {
    let disposeBag = DisposeBag()
    //inputs
    var itemFromTableView: AnyObserver<User>
    var itemFromCollectionView: AnyObserver<User>
    var searchedFriendID: AnyObserver<String>
    
    //outputs
    var friendList: Observable<[User]>
    var checkedFriendList: Observable<[User]>
    
    
    init() {
        let itemFromTableViewInput = PublishSubject<User>()
        let itemFromCollectionViewInput = PublishSubject<User>()
        let SRCHInput = PublishSubject<String>()
        
        let originalFriendList = BehaviorRelay<[User]>(value: FriendListModel.originalFriendList)
        let friendListOutput = BehaviorRelay<[User]>(value: originalFriendList.value)
        let checkedFriendListOutput = BehaviorRelay<[User]>(value: [])
        
        itemFromTableView = itemFromTableViewInput.asObserver()
        itemFromCollectionView = itemFromCollectionViewInput.asObserver()
        searchedFriendID = SRCHInput.asObserver()
        
        friendList = friendListOutput.asObservable()
        checkedFriendList = checkedFriendListOutput.asObservable()
        
        checkedFriendListOutput
            .map { $0.filter { $0.checkedFlag == true } }
            .scan([User](), accumulator: { (lastValue, newValue) in
            if lastValue.count < newValue.count {
                print("한명 늘었네용")
                print(newValue.filter { !lastValue.contains($0 as! User) })
            } else {
                print("한명 줄었네용")
                //없어진놈
                print(lastValue.filter { !newValue.contains($0 as! User) })
            }
            return newValue
        })
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        
        //checkedFriendList update with tableView
        itemFromTableViewInput
            .subscribe(onNext: { item in
                var newOriginalValue = originalFriendList.value
                var newCheckValue = checkedFriendListOutput.value
                
                if newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag == false {
                    newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag = true
                    newCheckValue.insert(newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!], at: 0)
                } else {
                    newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag = false
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
                newOriginalValue[newOriginalValue.firstIndex(where: {$0.name == item.name})!].checkedFlag = false
                newCheckValue.remove(at: newCheckValue.firstIndex(where: { $0.name == item.name})!)
                originalFriendList.accept(newOriginalValue)
                checkedFriendListOutput.accept(newCheckValue)
            }).disposed(by: disposeBag)
        
        //friendList update with searchValue
        SRCHInput
            .flatMapLatest { (value) -> Observable<[User]> in
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
