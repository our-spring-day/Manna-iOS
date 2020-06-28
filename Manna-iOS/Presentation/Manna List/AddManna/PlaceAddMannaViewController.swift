//
//  PlaceAddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/23.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class PlaceAddMannaViewController: UIViewController {
    let viewModel = AddMannaViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        layout()
    }
    func layout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeManna))
    }
    
    @objc func completeManna() {
        viewModel.manna.onNext("place is most important things")
        navigationController?.popToRootViewController(animated: true)
    }
}
