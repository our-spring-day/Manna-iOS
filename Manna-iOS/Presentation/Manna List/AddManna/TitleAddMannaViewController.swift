//
//  TitleAddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/23.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit


class TitleAddMannaViewController: UIViewController {
    let viewModel = AddMannaViewModel()
    
    let mannaTitle = UITextField().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(pushPeopleView))
        view.addSubview(mannaTitle)
        mannaTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    @objc func pushPeopleView() {
        let view = PeopleAddMannaViewController()
        
        guard let text = mannaTitle.text,
            text.count > 0 else {
                alert(message: "타이틀을 입력하세요")
                return
        }
//        viewModel.title.onNext(text)
        viewModel.title.onNext("fdffdfdfdfd")
        viewModel.title.onNext("fdffdfd")
        
        navigationController?.pushViewController(view, animated: true)
    }
}
