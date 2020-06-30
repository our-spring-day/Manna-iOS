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
    
    let viewModel = AddMannaViewModel()
    
    let start = UILabel()
    let on = UILabel()
    let end = UILabel()
    
    let startPicker = UIDatePicker()
    let onPicker = UIDatePicker()
    let endPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        attribute()
//        layout()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(pushPlaceView))
    }
    
    func attribute() {
        start.text = "시작시간"
        start.textColor = .black
        on.text = "약속시간"
        on.textColor = .black
        end.text = "종료시간"
        end.textColor = .black
        startPicker.datePickerMode = .time
        onPicker.do {
            $0.datePickerMode = .dateAndTime
            $0.timeZone = NSTimeZone.local
            $0.addTarget(self, action: #selector(changed), for: .valueChanged)
        }
        endPicker.datePickerMode = .time
    }
    
    func layout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(pushPlaceView))
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
        secondView.addSubview(on)
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
        on.snp.makeConstraints {
            $0.top.equalTo(secondView.snp.top)
            $0.leading.equalTo(firstView.snp.leading).offset(10)
        }
        onPicker.snp.makeConstraints {
            $0.top.equalTo(on)
            $0.bottom.equalTo(secondView.snp.bottom).offset(-10)
            $0.leading.equalTo(on.snp.trailing).offset(10)
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
    
    @objc func pushPlaceView() {
        let view = PlaceAddMannaViewController()
//        viewModel.manna.onNext("c")
        navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func changed(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        print(dateFormatter.string(from: sender.date))
    }
}
