//
//  TempViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/27.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import Then
import SnapKit

// MARK: - 임시 뷰컨트롤러 이며 곧 사라질 부분입니다
class TempViewController: UIViewController {
    let welcomeMessage = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(welcomeMessage)
        view.backgroundColor = .white
        
        welcomeMessage.do {
            $0.text = "당신은 \($0.text!)을(를) 만날 수 없습니다."
        }
        
        welcomeMessage.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
        }
    }
}
