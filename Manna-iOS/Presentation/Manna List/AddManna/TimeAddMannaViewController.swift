//
//  TimeAddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/23.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class TimeAddMannaViewController: UIViewController {
    static let shared = TimeAddMannaViewController()
    
    let start = UILabel().then {
        $0.text = "시작시간"
        $0.textColor = .black
    }
    let onTime = UILabel().then {
        $0.text = "약속시간"
        $0.textColor = .black
    }
    let onTimeDisplay = UILabel().then {
        $0.textColor = .black
    }
    let end = UILabel().then {
        $0.text = "종료시간"
        $0.textColor = .black
    }
    let startPicker = UIDatePicker().then {
        $0.datePickerMode = .time
    }
    let onPicker = UIDatePicker().then {
        $0.datePickerMode = .dateAndTime
        $0.timeZone = NSTimeZone.local
        $0.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    let endPicker = UIDatePicker().then {
        $0.datePickerMode = .time
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        attribute()
        layout()
    }
    
    func attribute() {
        
    }
    
    func layout() {
        let firstView = UIView()
        let secondView = UIView()
        let thirdView = UIView()
       
        firstView.backgroundColor = .darkGray
        secondView.backgroundColor = .red
        thirdView.backgroundColor = .blue

        view.addSubview(firstView)
        view.addSubview(secondView)
        view.addSubview(thirdView)
        
        firstView.addSubview(start)
        firstView.addSubview(startPicker)
        secondView.addSubview(onTime)
        secondView.addSubview(onTimeDisplay)
        secondView.addSubview(onPicker)
        thirdView.addSubview(end)
        thirdView.addSubview(endPicker)

        start.snp.makeConstraints {
            $0.top.equalTo(firstView.snp.top).offset(10)
            $0.leading.equalTo(firstView.snp.leading).offset(10)
        }
        startPicker.snp.makeConstraints {
            $0.top.equalTo(start)
            $0.bottom.equalTo(firstView.snp.bottom).offset(-10)
            $0.leading.equalTo(start.snp.trailing).offset(10)
            $0.trailing.equalTo(firstView.snp.trailing).offset(-10)
        }
        onTime.snp.makeConstraints {
            $0.top.equalTo(secondView.snp.top)
            $0.leading.equalTo(firstView.snp.leading).offset(10)
        }
        onTimeDisplay.snp.makeConstraints {
            $0.top.equalTo(secondView.snp.top).offset(10)
            $0.trailing.equalTo(secondView.snp.trailing).offset(-20)
        }
        onPicker.snp.makeConstraints {
            $0.top.equalTo(onTime)
            $0.bottom.equalTo(secondView.snp.bottom).offset(-10)
            $0.leading.equalTo(onTime.snp.trailing).offset(10)
            $0.trailing.equalTo(secondView.snp.trailing).offset(-10)
        }
        end.snp.makeConstraints {
            $0.top.equalTo(thirdView.snp.top)
            $0.leading.equalTo(thirdView.snp.leading).offset(10)
        }
        endPicker.snp.makeConstraints {
            $0.top.equalTo(end)
            $0.bottom.equalTo(thirdView.snp.bottom).offset(-10)
            $0.leading.equalTo(end.snp.trailing).offset(10)
            $0.trailing.equalTo(thirdView.snp.trailing).offset(-10)
        }
        firstView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(150)
        }
        secondView.snp.makeConstraints {
            $0.top.equalTo(firstView.snp.bottom)
            $0.leading.equalTo(firstView)
            $0.trailing.equalTo(firstView)
            $0.height.equalTo(400)
        }
        thirdView.snp.makeConstraints {
            $0.top.equalTo(secondView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(firstView)
            $0.trailing.equalTo(firstView)
        }
    }
    
    @objc func changed(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        dateFormatter.dateFormat = "MM월 dd일 hh시mm분"
        onTimeDisplay.text = dateFormatter.string(from: sender.date)
        endPicker.minimumDate = onPicker.date
        
        print(dateFormatter.string(from: sender.date))
    }
}
