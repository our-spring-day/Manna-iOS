//
//  CheckBox.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/15.
//  Copyright © 2020 정재인. All rights reserved.
//
import Foundation
import UIKit
import RxCocoa
import RxSwift

class CheckBox: UIButton {
    let disposeBag = DisposeBag()
    
    convenience init() {
        self.init(frame: .zero)
        self.setImage(UIImage(named: "unchecked"), for: .normal)
        self.setImage(UIImage(named: "checked"), for: .selected)
        //self.isSelected = !self.isSelected
    }
}
