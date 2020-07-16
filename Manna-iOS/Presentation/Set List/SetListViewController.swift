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
    var tableView = FriendsListTableView()
    let screenSize: CGRect = UIScreen.main.bounds
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableViewSet()
        tableView.tableView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: { str in
                print("이부분인가요?",str)
            }).disposed(by: disposeBag
        )
        tableView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.tableView.tableView.cellForRow(at: indexPath)
//                print(indexPath[1])
                print(indexPath)
            }).disposed(by: disposeBag)
    }
    func tableViewSet() {
        tableView = FriendsListTableView(frame: CGRect(x: 5, y: 66, width: screenSize.width-10, height: screenSize.height - 266))
        view.addSubview(tableView)
    }
}
