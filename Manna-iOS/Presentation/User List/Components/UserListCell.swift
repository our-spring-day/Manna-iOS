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
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .systemFont(ofSize: 14, weight: .light)
            $0.textColor = .black
        }
        userImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            $0.contentMode = .scaleToFill
            $0.layer.cornerRadius = 1
            $0.layer.masksToBounds = true
        }
    }
    func layout() {
        addSubview(idLabel)
        addSubview(userImageView)
        userImageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.height.equalTo(10)
//            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
//            $0.top.equalTo(view).offset(300)
//            $0.width.equalTo(screenSize.width).offset(300)
//            $0.height.equalTo(screenSize.height).offset(300)
        }
        idLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(userImageView.snp.right).offset(100)
            $0.right.equalToSuperview().offset(-8)
        }
    }
}
