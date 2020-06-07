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
    let idLable = UILabel()
    let userImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func attribute() {
        idLable.do {
            $0.font = .systemFont(ofSize: 14, weight: .light)
            $0.textColor = .black
        }
        
        userImageView.do {
            //clipsToBounds??
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFit
        }
    }
    func layout(){
        addSubview(idLable)
        addSubview(userImageView)
        
        userImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.left.equalToSuperview()
            $0.width.height.equalTo(120)
        }
        
        idLable.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(userImageView.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-8)
        }
    }
}
