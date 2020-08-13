//
//  FriendsListCollectionView.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/21.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class FriendsListCollectionView: UIView {
    var baseCollectionView: UICollectionView!
    let layoutValue: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        self.do {
            $0.backgroundColor = .white
        }
        baseCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutValue)
        baseCollectionView.do {
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
    }
    
    func layout() {
        self.addSubview(baseCollectionView)
        
        baseCollectionView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(100)
            $0.centerX.equalTo(self.snp.centerX)
        }
    }
}
