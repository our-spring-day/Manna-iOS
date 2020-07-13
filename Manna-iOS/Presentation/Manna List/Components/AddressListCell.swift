//
//  AddressListCell.swift
//  Manna-iOS
//
//  Created by once on 2020/07/13.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit
import Then

class AddressListCell: UITableViewCell {
    static let identifier = "AddressListCell"
    
    let address = UILabel().then {
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
    }
    let jibunAddress = UILabel().then {
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(address)
        addSubview(jibunAddress)
        
        labelAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func labelAutolayout() {
        address.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        jibunAddress.snp.makeConstraints {
            $0.top.equalTo(address.snp.bottom).offset(20)
            $0.leading.equalTo(address)
        }
    }
}
