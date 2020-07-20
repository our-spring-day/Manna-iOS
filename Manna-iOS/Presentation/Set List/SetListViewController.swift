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
    
    var meetingMemberArray: [UserTestStruct] = []
    let screenSize: CGRect = UIScreen.main.bounds
    var tableView = FriendsListTableView()
    
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
        //        tableView = FriendsListTableView(frame: CGRect(x: 5, y: 266, width: screenSize.width-10, height: screenSize.height - 266))
                tableView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
    }
    
    func bind() {
        tableView.tableView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: { str in
                print("이부분인가요?", str)
            }).disposed(by: disposeBag
        )
    }
}
//쓸모가 있을듯
//let cell = self?.tableView.tableView.cellForRow(at: indexPath)
//print(indexPath[1])
