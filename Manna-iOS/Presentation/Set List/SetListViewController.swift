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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        var snakeView = MainView(frame: CGRect(x: 200, y: 200, width: self.view.frame.size.width, height: 66))
        view.addSubview(snakeView)
        snakeView.updateData(title: "hello")
        
    }
}
