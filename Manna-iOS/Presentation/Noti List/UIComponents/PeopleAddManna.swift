//
//  PeopleAddManna.swift
//  Manna-iOS
//
//  Created by once on 2020/08/01.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import Then

class PeopleAddManna: UIView {
    
    lazy var mannaPeople = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) 
    }
    
    func attribute() {
        backgroundColor = .gray
        mannaPeople.do {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func layout() {
        addSubview(mannaPeople)
        mannaPeople.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
}
