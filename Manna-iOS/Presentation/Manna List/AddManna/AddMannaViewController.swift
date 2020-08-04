//
//  AddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/08/05.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class AddMannaViewController: UIViewController {
    
    let people = PeopleAddManna()
    let time = TimeAddManna()
    let place = PlaceAddManna()
    
    
    let scrollView = UIScrollView()
    let titleLabel = UILabel()
    let titleInput = UITextField()
    let titleButton = UIButton()
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }

    func attribute() {
        navigationController?.isNavigationBarHidden = true
        
        place.searchButton.addTarget(self, action: #selector(gogogo), for: .touchUpInside)
        
        scrollView.do {
            $0.isHidden = true
            $0.backgroundColor = .red
            $0.bounces = false
        }
        titleLabel.do {
            $0.isHidden = true
        }
        titleInput.do {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.textAlignment = .center
        }
        titleButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.addTarget(self, action: #selector(titleBtn), for: .touchUpInside)
        }
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.isHidden = true
            $0.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
        }
    }

    func layout() {
        view.addSubview(titleButton)
        view.addSubview(titleInput)
        view.addSubview(scrollView)
        view.addSubview(nextButton)
        scrollView.addSubview(people)
        scrollView.addSubview(time)
        scrollView.addSubview(place)
        
        titleInput.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        titleButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        people.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        time.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(people.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        place.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(time.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    @objc func titleBtn(_ sender: Any) {
        guard let text = titleInput.text,
            text.count > 0 else {
                alert(message: "타이틀을 입력하세요")
                return
        }
        
        scrollView.isHidden = false
        nextButton.isHidden = false
        titleButton.isHidden = true
    }
    
    @objc func nextBtn(_ sender: Any) {
        if scrollView.isHidden == false {
            let maxWidth = min(scrollView.contentOffset.x + view.frame.width, view.frame.width * 2)
            let newOffset = CGPoint(x: maxWidth, y: 0)
            scrollView.contentOffset = newOffset
        }
    }
    @objc func gogogo(_ sender: Any) {
        let view = SelectPlaceViewController()
        view.modalPresentationStyle = .overFullScreen
        view.searchText.text = place.mannaPlace.text
        present(view, animated: true, completion: nil)
    }

}
