//
//  UserListTableViewCell.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/02.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    // MARK: - Property
    // imageView 생성
    private let img: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "notilistimage")
        return imgView
    }()
    // label 생성
    private let label: UILabel = {
        let label = UILabel()
        label.text = "상어상어"
        label.textColor = UIColor.gray
        return label
    }()
    //init for UI create programatically
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private
    private func setConstraint() {
        contentView.addSubview(label)
        contentView.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            img.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            img.widthAnchor.constraint(equalToConstant: 64),
            img.heightAnchor.constraint(equalToConstant: 64),
            label.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: img.centerYAnchor)
        ])
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
