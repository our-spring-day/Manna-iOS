//
//  PlaceAddManna.swift
//  Manna-iOS
//
//  Created by once on 2020/08/02.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class PlaceAddManna: UIView {
    
    lazy var descriptLabel = UILabel()
    lazy var mannaPlace = UITextField()
    lazy var searchButton = UIButton()
    lazy var selectButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func attribute() {
        backgroundColor = .white
        descriptLabel.do {
            $0.text = "지번, 도로명, 건물명을 입력하세요."
            $0.textColor = .black
        }
        mannaPlace.do {
            $0.placeholder = "  예) 만나동12-3 또는 만나아파트"
        }
        searchButton.do {
            $0.setTitle("검색", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }
        selectButton.do {
            $0.setTitle("현위치로 주소설정", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func layout() {
        addSubview(descriptLabel)
        addSubview(mannaPlace)
        addSubview(searchButton)
        addSubview(selectButton)
        
        descriptLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(40)
        }
        mannaPlace.snp.makeConstraints {
            $0.top.equalTo(descriptLabel.snp.top).offset(70)
            $0.centerX.equalTo(snp.centerX)
            $0.width.equalTo(290)
            $0.height.equalTo(40)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalTo(mannaPlace)
            $0.leading.equalTo(mannaPlace.snp.trailing).offset(5)
            $0.trailing.equalTo(snp.trailing).offset(-5)
            $0.width.equalTo(50)
            $0.height.equalTo(40)
        }
        selectButton.snp.makeConstraints {
            $0.top.equalTo(mannaPlace.snp.bottom).offset(40)
            $0.centerX.equalTo(snp.centerX)
            $0.width.equalTo(290)
            $0.height.equalTo(40)
        }
    }
}
