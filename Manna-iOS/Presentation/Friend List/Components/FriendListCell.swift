//
//  UserListTableViewCell.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/02.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class FriendListCell: UITableViewCell {
    static let identifier = "UserListCell"
    
    let friendIdLabel = UILabel()
    let friendImageView = UIImageView()
    let checkBoxImageView = UIImageView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - attribute
    
    func attribute() {
        friendIdLabel.do {
            $0.font = .systemFont(ofSize: 14, weight: .light)
            $0.textColor = .black
        }
        friendImageView.do {
            $0.layer.cornerRadius = 22
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        checkBoxImageView.do {
            $0.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            $0.image = UIImage(named: "unchecked")
        }
    }
    
    // MARK: - layout
    
    func layout() {
        addSubview(friendIdLabel)
        addSubview(friendImageView)
        addSubview(checkBoxImageView)
        
        friendIdLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(friendImageView.snp.right).offset(10)
        }
        friendImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(22)
            $0.width.height.equalTo(50)
            $0.centerY.equalToSuperview()
        }
        checkBoxImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
}
