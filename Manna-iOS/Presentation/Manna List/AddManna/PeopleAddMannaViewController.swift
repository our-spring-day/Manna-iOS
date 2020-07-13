//
//  PeopleAddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/25.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class PeopleAddMannaViewController: UIViewController {
    static let shared = PeopleAddMannaViewController()
    
    lazy var mannaPeople = UITextField().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        layout()
    }
    
    func layout() {
        view.addSubview(mannaPeople)
        mannaPeople.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
}
