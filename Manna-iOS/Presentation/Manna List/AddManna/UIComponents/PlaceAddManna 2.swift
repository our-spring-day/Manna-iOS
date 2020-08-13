//
//  PlaceAddManna.swift
//  Manna-iOS
//
//  Created by once on 2020/08/02.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit
import Then

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
            $0.textAlignment = .center
            $0.placeholder = "  예) 만나동12-3 또는 만나아파트"
        }
        searchButton.do {
            $0.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        }
        selectButton.do {
            $0.setTitle("현위치로 주소설정", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            $0.layer.cornerRadius = 4
        }
    }
    
    func layout() {
        let view = UIStackView().then {
            $0.distribution = .fillEqually
            $0.axis = .horizontal
        }
        addSubview(view)
        view.addArrangedSubview(mannaPlace)
        view.addArrangedSubview(searchButton)
        addSubview(descriptLabel)
        addSubview(selectButton)
        view.snp.makeConstraints {
            $0.top.equalTo(descriptLabel.snp.top).offset(70)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(40)
        }
        descriptLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(20)
            $0.leading.equalTo(self.snp.leading).offset(40)
        }
        mannaPlace.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
        }
        searchButton.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.1)
        }
        selectButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(20)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.height.equalTo(40)
        }
    }
}

extension PlaceAddManna {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
