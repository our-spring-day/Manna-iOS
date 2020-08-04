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

    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        attribute()
        setup()
    }

    func attribute() {
        
        scrollView.contentSize.width = self.view.frame.width * 3
        scrollView.backgroundColor = .red
    }

    func setup() {
        let people = PeopleAddManna()
        let time = TimeAddManna()
        let place = PlaceAddManna()
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        scrollView.addSubview(people)
        people.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
//            $0.width.equalTo(view.frame.width)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
//            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        scrollView.addSubview(time)
        time.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(people.snp.trailing)
            $0.width.equalToSuperview()

            $0.height.equalToSuperview()
        }
        scrollView.addSubview(place)
        place.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(time.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()

        }
    }
}
