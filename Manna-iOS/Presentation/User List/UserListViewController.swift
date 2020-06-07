//
//  UserListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Toaster
import Then

class UserListViewController: UIViewController{
    // MARK: - Property
    var disposeBag = DisposeBag()
    let tableView = UITableView()
    var userListViewModel = UserListViewModel()
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    func attribute() {
        navigationItem.title = "친구"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.do {
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            $0.register(UserListCell.self, forCellReuseIdentifier: "UserListCell")
            $0.separatorStyle = .singleLine
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 160
        }
    }
    func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func bind() {
        userListViewModel.outputs.friendsId
            //                    .bind(to: tableView.rx.items(cellIdentifier: "UserListCell",cellType: UITableViewCell.self)) { (row, element, cell) in
//            .bind(to: tableView.rx.items(cellIdentifier: "UserListCell")) { row, element, cell in
//                print(cell)
//        }
//        .disposed(by: disposeBag)
            .bind(to: tableView.rx.items) {(tv, row, item) -> UITableViewCell in
                let cell = tv.dequeueReusableCell(withIdentifier: "UserListCell", for: IndexPath.init(row: row, section: 0)) as! UserListCell
                cell.idLabel.text = item
                return cell
        }
        print("func bind : before subscribe")
        //        userListViewModel.outputs.friendsId
        //            .subscribe(onNext: {test in
        //                print(test)
        //            })
        print("func bind : after subscribe")
    }
}
