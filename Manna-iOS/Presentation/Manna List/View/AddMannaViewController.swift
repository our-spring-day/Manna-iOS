//
//  AddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/05.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class AddMannaViewController: UIViewController {
    
    let button = UIButton()
    let name = UITextField()
    let place = UITextField()
    let appointmentTime = UITextField()
    let numberPeople = UITextField()
    let datePicker = UIDatePicker()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
    }
    
    func attribute() {
        button.do {
            $0.frame = CGRect(x: 200, y: 100, width: 100, height: 50)
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.addTarget(self, action: #selector(addManna), for: .touchUpInside)
        }
        name.do {
            $0.frame = CGRect(x: 10, y: 100, width: 150, height: 45)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        place.do {
            $0.frame = CGRect(x: 10, y: 150, width: 150, height: 45)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        appointmentTime.do {
            $0.frame = CGRect(x: 10, y: 200, width: 150, height: 45)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        numberPeople.do {
            $0.frame = CGRect(x: 10, y: 250, width: 150, height: 45)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        datePicker.do {
            $0.frame = CGRect(x: 10, y: 300, width: 350, height: 300)
            $0.timeZone = NSTimeZone.local
            $0.backgroundColor = UIColor.white
            $0.layer.cornerRadius = 5.0
            $0.layer.shadowOpacity = 0.5
        }
    }
    
    func layout() {
        view.do {
            $0.backgroundColor = .white
            $0.addSubview(button)
            $0.addSubview(name)
            $0.addSubview(place)
            $0.addSubview(appointmentTime)
            $0.addSubview(numberPeople)
            $0.addSubview(datePicker)
        }
    }
    
    @objc func addManna() {
        MannaProvider.addManna(manna: Manna(title: "상원", place: "이와", appointmentTime: "떠나는", numberPeople: "여행"))
        pop
    }
}
