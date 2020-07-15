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
    let checkBox = CheckBox()
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
        addSubview(checkBox)
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
        checkBox.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
            $0.setImage(UIImage(named: "unchecked"), for: .normal)
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
        checkBox.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
}

class CheckBox: UIButton {
    convenience init() {
        self.init(frame: .zero)
        self.setImage(UIImage(named: "unchecked"), for: .normal)
        self.setImage(UIImage(named: "checked"), for: .selected)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        self.isSelected = !self.isSelected
    }
}
