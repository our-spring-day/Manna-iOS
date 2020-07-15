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

class MainView: UIView {
    let tableView = UITableView()
    let viewModel = UserListViewModel()
    let disposeBag = DisposeBag()
    //-------------------------------
//    var label: UILabel!
//    var button: UIButton!

    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.do {
            $0.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
            $0.rowHeight = 55
        }
        tableBind()
//        self.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
//
//
//        label = UILabel(frame: CGRect(x: 12, y: 8, width: self.frame.size.width-90, height: 50))
//        label.text = "Connection error please try again later!!"
//        label.textColor = UIColor.white
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 14)
//        self.addSubview(label)
//
//        button = UIButton(frame: CGRect(x: self.frame.size.width-87, y: 8, width: 86, height: 50))
//        button.setTitle("OK", for: .normal)
//        button.setTitleColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0), for: .normal)
//        button.addTarget(self, action: "hideSnackBar:", for: UIControl.Event.touchUpInside)
//        self.addSubview(button)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    func updateData(title:String){
//        self.label.text = title
//    }
    func tableBind() {
        viewModel.filteredFriendsList
            .bind(to: tableView.rx.items(cellIdentifier: UserListCell.identifier, cellType: UserListCell.self)) {(_: Int, element: UserTestStruct, cell: UserListCell) in
                cell.idLabel.text = element.name
                cell.userImageView.image = UIImage(named: "\(element.profileImage)")
        }.disposed(by: disposeBag)
    }
}
