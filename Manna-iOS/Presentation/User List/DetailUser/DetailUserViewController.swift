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
    let userImage = UIImageView()
    let userID = UILabel()
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layouts()
        dismissActionSet()
    }
    func attributes() {
        view.do {
            $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        backgroundView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
        }
        userImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        userID.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func layouts() {
        view.addSubview(backgroundView)
        view.addSubview(userImage)
        backgroundView.addSubview(userID)
        
        backgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.width.equalTo(350)
            $0.height.equalTo(400)
        }
        userImage.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(backgroundView.snp.top).offset(25)
            $0.width.equalTo(300)
            $0.height.equalTo(300)
        }
        userID.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(userImage.snp.bottom).offset(25)
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
