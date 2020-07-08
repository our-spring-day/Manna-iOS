//
//  UserListTableViewCell.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/02.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class UserListCell: UITableViewCell {
    static let identifier = "UserListCell"
    let idLabel = UILabel()
    let userImageView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func attribute() {
        idLabel.do {
            $0.font = .systemFont(ofSize: 14, weight: .light)
            $0.textColor = .black
        }
        userImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 1
            $0.layer.masksToBounds = true
//            $0.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 10, height: 10))
        }
    }
    func layout() {
        addSubview(idLabel)
        addSubview(userImageView)
        //UIImageView(frame: CGRectMake(5, 5, 50, 50))
        userImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.left.equalToSuperview()
//            $0.width.height.equalTo(0)
            $0.height.equalTo(10)
//            $0.width.equalTo(50)
        }
        idLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(userImageView.snp.right).offset(50)
            $0.right.equalToSuperview().offset(-8)
        }
    }
}
