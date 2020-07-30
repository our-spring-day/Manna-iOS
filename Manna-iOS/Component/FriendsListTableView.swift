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
import Then

class FriendListTableView: UIView {
    let disposeBag = DisposeBag()
    
    let baseTableView = UITableView()

    override init (frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        self.addSubview(baseTableView)
        
        baseTableView.do {
            $0.register(FriendListCell.self, forCellReuseIdentifier: FriendListCell.identifier)
            $0.rowHeight = 55
        }
    }
    
    func layout() {
        self.addSubview(baseTableView)
        
        baseTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
