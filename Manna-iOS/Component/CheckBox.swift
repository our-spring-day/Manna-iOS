//
//  CheckBox.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/15.
//  Copyright © 2020 정재인. All rights reserved.
//
import Foundation
import UIKit

class CheckBox: UIButton {
    var flag = 0
    var cellIndex = 0
    convenience init() {
        self.init(frame: .zero)
        self.setImage(UIImage(named: "unchecked"), for: .normal)
        self.setImage(UIImage(named: "checked"), for: .selected)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        print(cellIndex)
        self.isSelected = !self.isSelected
        if self.isSelected == true  {
            flag = 1
        }
        else {
            flag = 0
        }
        print(flag)
    }
}
