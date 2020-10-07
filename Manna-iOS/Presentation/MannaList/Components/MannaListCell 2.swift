//
//  MannaListCell.swift
//  Manna-iOS
//
//  Created by once on 2020/05/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit
import Then

class MannaListCell: UITableViewCell {
    static let identifier = "MannaListCell"
    
    //title
    let title = UILabel()
    
    //place
    let place = UILabel()
    let pin = UIImageView()
    
    //appointmentTime
    let appointmentTime = UILabel()
    let clock = UIImageView()
    
    //numberPeople
    let numberPeople = UILabel()
    let user = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func attribute() {
        title.do {
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        place.do {
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        appointmentTime.do {
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        numberPeople.do {
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        pin.do {
            $0.image = UIImage(named: "Image")
            $0.contentMode = .scaleAspectFit
        }
        clock.do {
            $0.image = UIImage(named: "Image-1")
            $0.contentMode = .scaleAspectFit
        }
        user.do {
            $0.image = UIImage(named: "Image-2")
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func layout() {
        addSubview(title)
        addSubview(pin)
        addSubview(place)
        addSubview(clock)
        addSubview(appointmentTime)
        addSubview(user)
        addSubview(numberPeople)
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalTo(pin.snp.top).offset(-5)
            $0.left.equalToSuperview().offset(10)
        }
        pin.snp.makeConstraints {
            $0.left.equalTo(title)
            $0.centerY.equalToSuperview()
        }
        place.snp.makeConstraints {
            $0.leading.equalTo(pin.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        clock.snp.makeConstraints {
            $0.top.equalTo(pin.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-5)
            $0.left.equalTo(title)
        }
        appointmentTime.snp.makeConstraints {
            $0.top.equalTo(clock)
            $0.bottom.equalTo(clock)
            $0.leading.equalTo(clock.snp.trailing).offset(10)
        }
        user.snp.makeConstraints {
            $0.top.equalTo(clock)
            $0.bottom.equalTo(clock)
            $0.leading.equalTo(appointmentTime.snp.trailing).offset(10)
        }
        numberPeople.snp.makeConstraints {
            $0.top.equalTo(clock)
            $0.bottom.equalTo(clock)
            $0.leading.equalTo(user.snp.trailing).offset(10)
        }
    }
}
