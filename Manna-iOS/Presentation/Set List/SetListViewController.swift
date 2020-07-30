//
//  SetListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SetListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = FriendListViewModel()
    var meetingMemberArray: [UserTestStruct] = []
    let screenSize: CGRect = UIScreen.main.bounds
    var tableView = FriendListTableView(frame: CGRect(x: 5, y: 266, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.height - 266))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    func attribute() {
        view.do {
            $0.backgroundColor = .white
        }
    }
    
    func layout() {
        view.addSubview(tableView)
    }
    
    func bind() {
        FriendListViewModel.self.myFriendList
            .bind(to: tableView.baseTableView.rx.items(cellIdentifier: FriendListCell.identifier, cellType: FriendListCell.self)) {(_: Int, element: UserTestStruct, cell: FriendListCell) in
                cell.friendIdLabel.text = element.name
                cell.friendImageView.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: disposeBag)
        
    }
}
