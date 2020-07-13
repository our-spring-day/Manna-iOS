//
//  DetailUserViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/19.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailUserViewController: UIViewController {
    let disposeBag = DisposeBag()
    let screenSize: CGRect = UIScreen.main.bounds
    let backgroundView = UIView()
    let userProfileImageView = UIImageView()
    let nameLabel = UILabel()
    let userListViewController = UserListViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        userListViewController.delegate = self
        view.backgroundColor = UIColor.lightGray
        backgroundViewSet()
        userProfileViewSet()
        dismissActionSet()
        userListViewController.delegate = self
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
    func userProfileViewSet() {
        userProfileImageView.do {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        userProfileImageView.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(backgroundView.snp.top).offset(25)
            $0.width.equalTo(300)
            $0.height.equalTo(300)
        }
        nameLabel.do {
            backgroundView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        nameLabel.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(25)
        }
    }
    func dismissActionSet() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.view.addGestureRecognizer(gesture)
    }
}

extension DetailUserViewController: SendDataDelegate {
    func sendData(data: UserTestStruct) {
        userProfileImageView.image = UIImage(named: data.profileImage)
        nameLabel.text = data.name
    }
}
