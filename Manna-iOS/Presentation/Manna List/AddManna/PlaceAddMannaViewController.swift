//
//  PlaceAddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/23.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class PlaceAddMannaViewController: UIViewController {
    static let shared = PlaceAddMannaViewController()
    
    let line = UIBezierPath().then {
        $0.lineWidth = 2
    }
    let descriptLabel = UILabel().then {
        $0.text = "지번, 도로명, 건물명을 입력하세요."
        $0.textColor = .black
    }
    let mannaPlace = UITextField().then {
        $0.placeholder = "  예) 만나동12-3 또는 만나아파트"
    }
    let searchButton = UIButton().then {
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.addTarget(self, action: #selector(detail), for: .touchUpInside)
    }
    let selectButton = UIButton().then {
        $0.setTitle("현위치로 주소설정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }
    
    func layout() {
        let drawLine = DrawLine(frame: self.view.frame)
        drawLine.backgroundColor = .clear
        self.view.addSubview(drawLine)
        
        view.addSubview(descriptLabel)
        descriptLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(40)
        }
        view.addSubview(mannaPlace)
        mannaPlace.snp.makeConstraints {
            $0.top.equalTo(descriptLabel.snp.top).offset(70)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(290)
            $0.height.equalTo(40)
        }
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalTo(mannaPlace)
            $0.leading.equalTo(mannaPlace.snp.trailing).offset(5)
            $0.trailing.equalTo(view.snp.trailing).offset(-5)
            $0.width.equalTo(50)
            $0.height.equalTo(40)
        }
        view.addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.top.equalTo(mannaPlace.snp.bottom).offset(40)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(290)
            $0.height.equalTo(40)
        }
    }
    
    @objc func detail() {
        let view = SelectPlaceViewController()
        print("ffdf")
        view.modalPresentationStyle = .overFullScreen 
        self.present(view, animated: true, completion: nil)
    }
}
