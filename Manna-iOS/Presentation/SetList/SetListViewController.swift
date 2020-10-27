//
//  SetListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/10/09.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class SetListViewController: UIViewController {
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute() {
        view.backgroundColor = .cyan
        
        button.do {
            $0.setTitle("네이버 맵 ㄱㄱ", for: .normal)
            $0.backgroundColor = .black
            $0.addTarget(self, action: #selector(goToMapView), for: .touchUpInside)
            $0.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        }
    }
    
    func layout() {
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button .centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func goToMapView() {
        let mapView = MapView()
        mapView.modalPresentationStyle = .fullScreen
        self.present(mapView, animated: true, completion: nil)
    }
}
