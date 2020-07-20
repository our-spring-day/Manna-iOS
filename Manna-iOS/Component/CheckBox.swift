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
    
    var userInfo: UserTestStruct?
    
    var flag = 0
    
    convenience init() {
        self.init(frame: .zero)
        self.setImage(UIImage(named: "unchecked"), for: .normal)
        self.setImage(UIImage(named: "checked"), for: .selected)
        self.rx.tap
            .subscribe(onNext: { item in
                self.isSelected = !self.isSelected
                if self.isSelected == true {
                    self.flag = 1
                    print(self.userInfo)
                    if let info = self.userInfo { print(info) }
                } else {
                    self.flag = 0
                    if let info = self.userInfo { print("delete",info) }
                }
            }).disposed(by: disposeBag)
    }
}
