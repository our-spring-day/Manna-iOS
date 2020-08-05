//
//  FinalAddManna.swift
//  Manna-iOS
//
//  Created by once on 2020/08/05.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class FinalAddManna: UIView {
    
    let finalTimeLabel = UILabel()
    let finalTime = UILabel()
    let finalPlaceLabel = UILabel()
    let finalPlace = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func attribute() {
        finalTimeLabel.do {
            $0.text = "시간 : "
            $0.textColor = .black
        }
        finalTime.do {
            $0.text = "ffjfjdfkdlfjdkf"
            $0.textColor = .black
        }
        finalPlaceLabel.do {
            $0.text = "장소 : "
            $0.textColor = .black
        }
        finalPlace.do {
            $0.text = "bbbbb"
            $0.textColor = .black
        }
    }
    
    func layout() {
        addSubview(finalTimeLabel)
        addSubview(finalTime)
        addSubview(finalPlaceLabel)
        addSubview(finalPlace)
        finalTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(40)
        }
        finalTime.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalTo(finalTimeLabel.snp.trailing).offset(20)
        }
        finalPlaceLabel.snp.makeConstraints {
            $0.top.equalTo(finalTimeLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(40)
        }
        finalPlace.snp.makeConstraints {
            $0.top.equalTo(finalPlaceLabel)
            $0.leading.equalTo(finalPlaceLabel.snp.trailing).offset(20)
        }
    }
}
