//
//  DetailUserViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/19.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class DetailUserViewController: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
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
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
        backgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.width.equalTo(screenSize.width)
            $0.height.equalTo(screenSize.height)
        }
    }
    func userProfileImageViewSet() {
        userProfileImageView.do {
            backgroundView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(named: "userlistimage")
            self.view.bringSubviewToFront($0)
        }
        userProfileImageView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.width.equalTo(screenSize.width)
            $0.height.equalTo(screenSize.height)
        }
    }
}
