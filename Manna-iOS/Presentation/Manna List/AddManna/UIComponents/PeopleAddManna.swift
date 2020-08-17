//
//  PeopleAddManna.swift
//  Manna-iOS
//
//  Created by once on 2020/08/01.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PeopleAddManna: UIView, UITextFieldDelegate {
    
    var collectionView = FriendsListCollectionView()
    var textField = UITextField()
    var tableView = FriendListTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) 
    }
    
    func attribute() {
        self.do {
            $0.backgroundColor = .white
        }
        textField.do {
            $0.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            $0.backgroundColor = .lightGray
        }
    }
    
    func layout() {
        addSubview(collectionView)
        addSubview(textField)
        addSubview(tableView)
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self)
        }
        textField.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.top.equalTo(self)
            $0.width.equalTo(self).offset(-50)
            $0.height.equalTo(40)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(self).offset(50)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(self)
        }
    }
}

extension PeopleAddManna {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
