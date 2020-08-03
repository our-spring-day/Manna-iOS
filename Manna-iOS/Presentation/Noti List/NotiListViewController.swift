//
//  NotiListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class NotiListViewController: UIViewController {

    lazy var scrollView = UIScrollView()
    lazy var tempView = UIView()
    lazy var tempView2 = UIView()
    lazy var tempView3 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        attribute()
        setup()
    }

    func attribute() {
        scrollView.backgroundColor = .red
        scrollView.do {
            $0.backgroundColor = .red
            $0.contentSize.width = self.view.frame.width * 3
        }
        tempView.backgroundColor = .gray
        tempView2.backgroundColor = .systemOrange
        tempView3.backgroundColor = .systemBlue
    }

    func setup() {
        let view1 = PeopleAddManna()
        let view2 = TimeAddManna()
        let view3 = PlaceAddManna()
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }
        scrollView.addSubview(view1)
        view1.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(self.view.safeAreaLayoutGuide.snp.height)
        }
        
        scrollView.addSubview(view2)
        view2.snp.makeConstraints {
            $0.top.equalTo(view1)
            $0.leading.equalTo(view1.snp.trailing)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(self.view.safeAreaLayoutGuide.snp.height)
        }
        scrollView.addSubview(view3)
        view3.snp.makeConstraints {
            $0.top.equalTo(view1)
            $0.leading.equalTo(view2.snp.trailing)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(self.view.frame.height)
        }
    }
}
