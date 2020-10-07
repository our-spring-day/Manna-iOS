//
//  PeopleAddManna.swift
//  Manna-iOS
//
//  Created by once on 2020/08/01.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit
import Then

class PeopleAddManna: UIView, UITextFieldDelegate {
    
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
        mannaPeople.do {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.delegate = self
        }
    }
    
    func layout() {
        addSubview(mannaPeople)
        mannaPeople.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.top.equalTo(self.snp.top).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
}

extension PeopleAddManna {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
