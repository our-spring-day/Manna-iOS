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
import NMapsMap

class SetListViewController: UIViewController {
    var authState: NMFAuthState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nmapFView = NMFMapView(frame: view.frame)
        view.addSubview(nmapFView)
        attribute()
        layout()
        bind()
    }
    func attribute() {
    }
    func layout() {
    }
    func bind() {
    }
}
