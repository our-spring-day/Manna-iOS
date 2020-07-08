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
    let userProfileImageView = UIImageView()
    let nameLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //        alpha가 더 자연스러운 것 같은데 프로토타입대로 일단은
        //        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.backgroundColor = UIColor.lightGray
        backgroundViewSet()
        userProfileImageViewSet()
        dismissActionSet()
        nameLabel.do {
            backgroundView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "이름이 들어갈 자리"
        }
        nameLabel.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(25)
        }
    }
    @objc func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func backgroundViewSet() {
        backgroundView.do {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
        }
        backgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.width.equalTo(350)
            $0.height.equalTo(400)
        }
    }
    func userProfileImageViewSet() {
        userProfileImageView.do {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(named: "soma")
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        userProfileImageView.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(backgroundView.snp.top).offset(25)
            $0.width.equalTo(300)
            $0.height.equalTo(300)
        }
    }
    func dismissActionSet() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        let gesture2 = UISwipeGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        let gesture3 = UIHoverGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.view.addGestureRecognizer(gesture)
        self.view.addGestureRecognizer(gesture2)
        self.view.addGestureRecognizer(gesture3)
    }
}
