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
    
    func labelAutolayout(){
        address.translatesAutoresizingMaskIntoConstraints = false
        address.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        address.heightAnchor.constraint(equalToConstant: 48).isActive = true
        address.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
        jibunAddress.translatesAutoresizingMaskIntoConstraints = false
        jibunAddress.topAnchor.constraint(equalTo: address.bottomAnchor).isActive = true
        jibunAddress.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        jibunAddress.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}
