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
    
    var collectionView: UICollectionView!
    let layoutValue = UICollectionViewFlowLayout()
    var textField = UITextField()
    var tableView = UITableView()
    
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
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutValue)
        collectionView.do {
            $0.backgroundColor = .white
            $0.register(CheckedFriendCell.self, forCellWithReuseIdentifier: CheckedFriendCell.identifier)
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
        layoutValue.do {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
            $0.itemSize = CGSize(width: 50, height: 50)
            $0.scrollDirection = .horizontal
        }
        textField.do {
            $0.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            $0.backgroundColor = .lightGray
        }
        tableView.do {
            $0.register(FriendListCell.self, forCellReuseIdentifier: FriendListCell.identifier)
            $0.rowHeight = 55
        }
    }
    
    func layout() {
        addSubview(collectionView)
        addSubview(textField)
        addSubview(tableView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.width.equalTo(400)
            $0.height.equalTo(50)
            $0.centerX.equalTo(self.snp.centerX)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.width.equalTo(self).offset(-50)
            $0.height.equalTo(40)
            $0.centerX.equalTo(self.snp.centerX)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
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
