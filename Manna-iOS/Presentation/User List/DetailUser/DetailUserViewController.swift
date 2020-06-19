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
    var userProfileImage = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 300).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 300).isActive = true
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            $0.image = UIImage(named: "userlistimage")
        }
        view.addSubview(userProfileImage)
    }

}
