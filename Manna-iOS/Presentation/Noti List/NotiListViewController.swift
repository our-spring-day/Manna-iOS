//
//  NotiListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class NotiListViewController: UIViewController {
//    let disposeBag = DisposeBag()
    
    var meetingMemberArray: [UserTestStruct] = []
    let screenSize: CGRect = UIScreen.main.bounds
//    var tableView = FriendsListTableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = FriendsListTableView(frame: CGRect(x: 5, y: 266, width: screenSize.width-10, height: screenSize.height - 266))
        view.addSubview(tableView)
//        tableView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
    }
}
