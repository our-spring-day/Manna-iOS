//
//  SetListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SetListViewController: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
//    let testRadioButton =
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        var tableView = MainView(frame: CGRect(x: 5, y: 66, width: screenSize.width-10, height: screenSize.height - 266))
        view.addSubview(tableView)
    }
}
