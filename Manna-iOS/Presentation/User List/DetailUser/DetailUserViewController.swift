//
//  DetailUserViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/19.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class DetailUserViewController: UIViewController {
    let backgroundView = UIView()
    var userProfileImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundViewSet()
        userProfileImageViewSet()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.backgroundView.addGestureRecognizer(gesture)
    }
    @objc func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func backgroundViewSet() {
        backgroundView.do {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            $0.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    func userProfileImageViewSet() {
        userProfileImageView.do {
            backgroundView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 300).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 300).isActive = true
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            $0.image = UIImage(named: "userlistimage")
            self.view.bringSubviewToFront($0)
        }
    }
}
