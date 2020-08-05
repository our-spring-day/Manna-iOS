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
    let disposeBag = DisposeBag()
    
    var authState: NMFAuthState!
    var nmapFView = NMFMapView()
    let cameraPosition = NMFCameraPosition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
        //현재 카메라의 포지션이고 유용하게 사용할듯
        let cameraPosition2 = nmapFView.cameraPosition
        print(cameraPosition2)
        
        let bottomSheet = BottomSheetViewController()
        
        self.addChild(bottomSheet)
        self.view.addSubview(bottomSheet.view)
        bottomSheet.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        bottomSheet.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
        
        bottomSheet.view.backgroundColor = .red
    }
    func attribute() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView.do {
            $0.mapType = .basic
            $0.symbolScale = 0.7
        }
    }
    func layout() {
        view.addSubview(nmapFView)
    }
    func bind() {
    }
}
