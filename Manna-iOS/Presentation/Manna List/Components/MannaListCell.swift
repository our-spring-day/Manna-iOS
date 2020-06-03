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
//    var mannaList = [
//        MannaListModel(title: "스터디", place: "홍대입구", appointmentTime: "11시", numberPeople: "3명")
//    ]
    
//    typealias MannaList = (title: String, place: String, appointmentTime: String, numberPeople: String)
    
    //title
    let title = UILabel()
    
    //title
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
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setData(mannaList: MannaList) {
//        title.do {
//            $0.text = mannaList.title
//        }
//        
//        place.do {
//            $0.text = mannaList.place
//        }
//        
//        appointmentTime.do {
//            $0.text = mannaList.appointmentTime
//        }
//        
//        numberPeople.do {
//            $0.text = mannaList.numberPeople
//        }
//    }
    
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
        addSubview(pin)             //핀
        addSubview(place)
        addSubview(clock)           //시계
        addSubview(appointmentTime)
        addSubview(user)
        addSubview(numberPeople)    //사람
        
        
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
            $0.bottom.equalToSuperview().offset(10)
            $0.left.equalTo(title)
        }
        
        appointmentTime.snp.makeConstraints {
            $0.top.equalTo(pin.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(10)
            $0.leading.equalTo(clock.snp.trailing).offset(10)
        }
        
        user.snp.makeConstraints {
            $0.top.equalTo(pin.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(10)
            $0.leading.equalTo(appointmentTime.snp.trailing).offset(10)
        }
        
        numberPeople.snp.makeConstraints {
            $0.top.equalTo(pin.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(10)
            $0.leading.equalTo(user.snp.trailing).offset(10)
        }
    }
}
