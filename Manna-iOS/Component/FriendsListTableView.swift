//
//  FriendsList.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FriendsListTableView: UIView {
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let viewModel = UserListViewModel()
    let checkBox = CheckBox()
    var memberInfo = MeetingInfo()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
        tableBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        tableView.do {
            $0.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
            $0.rowHeight = 55
        }
    }
    
    func layout() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func tableBind() {
        viewModel.filteredFriendsList
            .bind(to: tableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self)) {(index: Int, element: UserTestStruct, cell: UserListCell) in
                cell.idLabel.text = element.name
                cell.userImageView.image = UIImage(named: "\(element.profileImage)")
                cell.checkBox.userInfo = element
        }.disposed(by: disposeBag)
    }
}
