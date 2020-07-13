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
        addView()
        attribute()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addView() {
        addSubview(idLabel)
        addSubview(userImageView)
    }
    func attribute() {
        idLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .systemFont(ofSize: 14, weight: .light)
            $0.textColor = .black
        }
        userImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 22
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    }
    func layout() {
        idLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(userImageView.snp.right).offset(10)
        }
        userImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(22)
            $0.width.height.equalTo(50)
            $0.centerY.equalToSuperview()
        }
    }
}
