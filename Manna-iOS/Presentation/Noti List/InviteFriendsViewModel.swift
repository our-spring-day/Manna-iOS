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
        
        friendListOutput
        .skip(2)
            .map { $0.filter { $0.checkedFlag == true } }
            .scan([User](), accumulator: {
                var lastValue = $0
                let newValue = $1
                
                if lastValue.count < newValue.count {
                    let checkedFriend = newValue.filter { !lastValue.contains($0 ) }
                    lastValue.insert(checkedFriend[0], at: 0)
                    return lastValue
                } else {
                    let uncheckedFriend = lastValue.filter { !newValue.contains($0 ) }
                    if let uncheckedIndex = lastValue.firstIndex(of: uncheckedFriend[0]) { lastValue.remove(at: uncheckedIndex)
                    }
                    return lastValue
                }
            })
            .bind(to: checkedFriendListOutput)
            .disposed(by: disposeBag)
        
        
        //테이블뷰에서 일어난 클릭으로 넘어온 유저의 플래그를 true/false 스위칭 하는 부분
        itemFromTableViewInput
            .subscribe(onNext: { item in
                var newOriginalValue = originalFriendList.value
                if newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag == false {
                    newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag = true
                } else {
                    newOriginalValue[newOriginalValue.firstIndex(where: { $0.name == item.name })!].checkedFlag = false
                }
                originalFriendList.accept(newOriginalValue)
            }).disposed(by: disposeBag)
        
        //콜렉션뷰에서 일어난 클릭으로 넘어온 유저의 플래그를 false로 스위칭 하는 부분
        itemFromCollectionViewInput
            .subscribe(onNext: { item in
                var newOriginalValue = originalFriendList.value
                newOriginalValue[newOriginalValue.firstIndex(where: {$0.name == item.name})!].checkedFlag = false
                originalFriendList.accept(newOriginalValue)
            }).disposed(by: disposeBag)
        
<<<<<<< HEAD
        //friendList update with searchValue
=======
        //검색어에 따른 친구목록 필터링
>>>>>>> develop
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
