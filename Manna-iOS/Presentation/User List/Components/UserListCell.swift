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

class UserListCell: UITableViewCell {
    static let identifier = "UserListCell"
    var disposeBag = DisposeBag()
    
    let idLabel = UILabel()
    let userImageView = UIImageView()
    let checkBox = CheckBox()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        
        layout()
        
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
          
      disposeBag = DisposeBag()
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
            $0.layer.cornerRadius = 22
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        checkBox.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            $0.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    func layout() {
        addSubview(idLabel)
        addSubview(userImageView)
        addSubview(checkBox)
        
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
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
}
