//
//  TimeAddManna.swift
//  Manna-iOS
//
//  Created by once on 2020/08/01.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class TimeAddManna: UIView {
    
    lazy var startLabel = UILabel()
    lazy var onTimeLabel = UILabel()
    lazy var endLabel = UILabel()
    lazy var onTimeDisplay = UILabel()
    lazy var startPicker = UIDatePicker()
    lazy var onPicker = UIDatePicker()
    lazy var endPicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        self.backgroundColor = .white
        
        startLabel.do {
            $0.text = "시작시간"
            $0.textColor = .black
        }
        onTimeLabel.do {
            $0.text = "약속시간"
            $0.textColor = .black
        }
        endLabel.do {
            $0.text = "종료시간"
            $0.textColor = .black
        }
        onTimeDisplay.do {
            $0.text = "현재시간"
            $0.textColor = .black
        }
        startPicker.do {
            $0.datePickerMode = .time
            $0.minuteInterval = 5
        }
        onPicker.do {
            $0.datePickerMode = .dateAndTime
            $0.timeZone = NSTimeZone.local
            $0.minuteInterval = 5
            $0.locale = Locale(identifier: "ko_KR")
            $0.addTarget(self, action: #selector(changed), for: .valueChanged)
        }
        endPicker.do {
            $0.datePickerMode = .time
            $0.minuteInterval = 5
        }
    }
    
    func layout() {
        let view1 = UIView().then {
            $0.backgroundColor = .systemTeal
        }
        let view2 = UIView().then {
            $0.backgroundColor = .systemOrange
        }
        let view3 = UIView().then {
            $0.backgroundColor = .systemBlue
        }
        addSubview(view1)
        addSubview(view2)
        addSubview(view3)
        
        view1.addSubview(startLabel)
        view1.addSubview(startPicker)
        view2.addSubview(onTimeLabel)
        view2.addSubview(onTimeDisplay)
        view2.addSubview(onPicker)
        view3.addSubview(endLabel)
        view3.addSubview(endPicker)
        
        view1.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(self).multipliedBy(0.25)
        }
        view2.snp.makeConstraints {
            $0.top.equalTo(view1.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(self).multipliedBy(0.5)
        }
        view3.snp.makeConstraints {
            $0.top.equalTo(view2.snp.bottom)
            $0.bottom.equalTo(snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(self).multipliedBy(0.25)
        }
        startLabel.snp.makeConstraints {
            $0.top.equalTo(view1.snp.top).offset(10)
            $0.leading.equalTo(view1.snp.leading).offset(10)
        }
        startPicker.snp.makeConstraints {
            $0.top.equalTo(view1.snp.top)
            $0.bottom.equalTo(view1.snp.bottom)
            $0.leading.equalTo(startLabel.snp.trailing)
            $0.trailing.equalTo(view1.snp.trailing).offset(-10)
        }
        onTimeLabel.snp.makeConstraints {
            $0.top.equalTo(view2.snp.top).offset(10)
            $0.leading.equalTo(view2.snp.leading).offset(10)
        }
        onTimeDisplay.snp.makeConstraints {
            $0.top.equalTo(view2.snp.top).offset(10)
            $0.trailing.equalTo(view2.snp.trailing).offset(-20)
        }
        onPicker.snp.makeConstraints {
            $0.top.equalTo(onTimeLabel)
            $0.bottom.equalTo(view2.snp.bottom)
            $0.leading.equalTo(onTimeLabel.snp.trailing)
            $0.trailing.equalTo(view2.snp.trailing).offset(-10)
        }
        endLabel.snp.makeConstraints {
            $0.top.equalTo(view3.snp.top).offset(10)
            $0.leading.equalTo(view3.snp.leading).offset(10)
        }
        endPicker.snp.makeConstraints {
            $0.top.equalTo(view3.snp.top)
            $0.bottom.equalTo(view3.snp.bottom)
            $0.leading.equalTo(endLabel.snp.trailing)
            $0.trailing.equalTo(view3.snp.trailing).offset(-10)
        }
    }
    
    @objc func changed(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 hh시mm분"
        onTimeDisplay.text = dateFormatter.string(from: sender.date)
        startPicker.minimumDate = Calendar.current.date(byAdding: .hour, value: -2, to: onPicker.date)
        startPicker.maximumDate = onPicker.date
        endPicker.minimumDate = onPicker.date
        endPicker.maximumDate = Date(timeInterval: 60*60*3, since: onPicker.date)
        print(dateFormatter.string(from: sender.date))
    }
}
