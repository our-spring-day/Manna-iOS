//
//  CheckBox.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/15.
//  Copyright © 2020 정재인. All rights reserved.
//
import Foundation
import UIKit
import RxSwift
import RxCocoa
class CheckBox: UIButton {
    let disposeBag = DisposeBag()
    var flag = 0
    var userInfo: UserTestStruct?
    convenience init() {
        self.init(frame: .zero)
        self.setImage(UIImage(named: "unchecked"), for: .normal)
        self.setImage(UIImage(named: "checked"), for: .selected)
        self.rx.tap
            .subscribe(onNext: { item in
                self.isSelected = !self.isSelected
                if self.isSelected == true {
                    self.flag = 1
                    if let info = self.userInfo {
                        print(info)
                    }
                } else {
                    self.flag = 0
                    if let info = self.userInfo {
                        print("delete",info)
                    }
                }
            }).disposed(by: disposeBag)
    }
}
