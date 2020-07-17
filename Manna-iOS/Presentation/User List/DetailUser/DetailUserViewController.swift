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
    
    let userListViewController = UserListViewController()
    
    let backgroundView = UIView()
    let userProfileImageView = UIImageView()
    let nameLabel = UILabel()
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layouts()
        dismissActionSet()
    }
    func attributes() {
        userListViewController.delegate = self
        view.do {
            $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        backgroundView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
        }
        userProfileImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        nameLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func layouts() {
        view.addSubview(backgroundView)
        view.addSubview(userProfileImageView)
        backgroundView.addSubview(nameLabel)
        
        backgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.width.equalTo(350)
            $0.height.equalTo(400)
        }
        userProfileImageView.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(backgroundView.snp.top).offset(25)
            $0.width.equalTo(300)
            $0.height.equalTo(300)
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
    
    @objc func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailUserViewController: SendDataDelegate {
    func sendData(data: UserTestStruct) {
        userProfileImageView.image = UIImage(named: data.profileImage)
        nameLabel.text = data.name
    }
}
