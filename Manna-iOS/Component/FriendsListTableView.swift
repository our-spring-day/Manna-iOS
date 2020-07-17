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
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.do {
            $0.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
            $0.rowHeight = 55
        }
        tableBind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableBind() {
        viewModel.filteredFriendsList
            .bind(to: tableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self)) {(index: Int, element: UserTestStruct, cell: UserListCell) in
                cell.idLabel.text = element.name
                cell.userImageView.image = UIImage(named: "\(element.profileImage)")
                cell.checkBox.userInfo = element
//                cell.checkBox.rx.tap
//                    .distinctUntilChanged({$0 == $1})
//                    .subscribe(onNext: {
//                        self.checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
//                        self.checkBox.setImage(UIImage(named: "checked"), for: .selected)
//                        self.checkBox.isSelected = !self.checkBox.isSelected
//                        print(cell.checkBox.userInfo)
//                        if self.checkBox.isSelected == true {
//                            self.checkBox.flag = 1
//                            self.memberInfo.member.append(element)
//                        } else {
//                            self.checkBox.flag = 0
//                            if let index = self.memberInfo.member.firstIndex(where: { $0.name == element.name}){
//                                self.memberInfo.member.remove(at: index)
//                            }
//                        }
//                    }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
}
