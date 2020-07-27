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
    var selectedFriend: UserTestStruct?
    let backgroundView = UIView()
    let userImage = UIImageView()
    let userID = UILabel()
    let screenSize: CGRect = UIScreen.main.bounds
    let mannaButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layouts()
        dismissActionSet()
        bind()
    }
    func attributes() {
        view.do {
            $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        backgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
        }
        userImage.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.image = UIImage(named: selectedFriend!.profileImage)
        }
        userID.do {
            $0.font = UIFont.systemFont(ofSize: 20.0)
            $0.text = selectedFriend!.name
        }
        mannaButton.do {
            $0.setImage(UIImage(named: "detailviewmanna"), for: .normal)
            $0.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
    }
    func layouts() {
        view.addSubview(backgroundView)
        view.addSubview(userImage)
        backgroundView.addSubview(userID)
        backgroundView.addSubview(mannaButton)
        
        backgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.width.equalTo(350)
            $0.height.equalTo(450)
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
        mannaButton.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.top.equalTo(userID.snp.bottom).offset(25)
        }
    }
    
    func bind() {
        mannaButton.rx.tap
            .map { self.selectedFriend?.name }
            .subscribe(onNext: {
                let tempViewController = TempViewController()
                tempViewController.welcomeMessage.text = $0
                self.present(tempViewController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    func dismissActionSet() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
