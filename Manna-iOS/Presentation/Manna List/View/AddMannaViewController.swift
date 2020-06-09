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
    
    private let setData = BehaviorSubject<[Manna]>(value: [])
    var setManna: Observable<[Manna]> {
      return setData.asObservable()
    }
    
    let button = UIButton().then {
        $0.frame = CGRect(x: 200, y: 50, width: 100, height: 50)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.addTarget(self, action: #selector(complete), for: .touchUpInside)
    }

        let name = UITextField().then {
        $0.frame = CGRect(x: 10, y: 50, width: 150, height: 45)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    let place = UITextField().then {
        $0.frame = CGRect(x: 10, y: 100, width: 150, height: 45)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    let appointmentTime = UITextField().then {
        $0.frame = CGRect(x: 10, y: 150, width: 150, height: 45)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    let numberPeople = UITextField().then {
        $0.frame = CGRect(x: 10, y: 200, width: 150, height: 45)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    let datePicker = UIDatePicker().then {
        $0.frame = CGRect(x: 10, y: 250, width: 350, height: 300)
        $0.timeZone = NSTimeZone.local
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 5.0
        $0.layer.shadowOpacity = 0.5
    }
    
    let disposeBag = DisposeBag()
    
    let viewModel = MannaListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        
    }
    
    func layout() {
        view.addSubview(button)
        view.addSubview(name)
        view.addSubview(place)
        view.addSubview(appointmentTime)
        view.addSubview(numberPeople)
        view.addSubview(datePicker)
    }
    
    @objc func complete() {
        dismiss(animated: true)
        viewModel.mannaObservable
            .onNext([Manna(title: "name.text!",
                           place: "place.text!",
                           appointmentTime: "appointmentTime.text!",
                           numberPeople: "numberPeople.text!")])
        print("ADDad")
    }
}
