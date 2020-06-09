//
//  MannaListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol MannaListBindable {
    //input
    
    
    //output
    var mannaObservable : BehaviorSubject<[Manna]> { get }
}

class MannaListViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let mannaList = UITableView()
    let mannaListViewModel = MannaListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        bind()
    }
    
    func bind() {
        mannaListViewModel.mannaObservable
            .bind(to: mannaList.rx.items(cellIdentifier: "cell", cellType: MannaListCell.self)) {
                _, item, cell in
                cell.title.text = item.title
                cell.place.text = item.place
                cell.appointmentTime.text = item.appointmentTime
                cell.numberPeople.text = item.numberPeople
                print("celllllllll")
        }
        .disposed(by: disposeBag)
    }
    
    func attribute() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVC))
        self.navigationItem.rightBarButtonItem = add
        self.navigationItem.title = "약속목록"
        view.backgroundColor = .white

        mannaList.do {
            $0.backgroundView?.isHidden = true
            $0.register(MannaListCell.self, forCellReuseIdentifier: "cell")
            $0.rowHeight = 90
        }
    }
    
    func layout() {
        view.addSubview(mannaList)
        
        mannaList.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func addVC() {
        let vc = AddMannaViewController()
        present(vc, animated: true, completion: nil)
        mannaListViewModel.mannaObservable.onNext([Manna(title: "name.text!",
        place: "place.text!",
        appointmentTime: "appointmentTime.text!",
        numberPeople: "numberPeople.text!")])
    }
//    func addManna() -> Observable<Manna>{
//        let vc = AddMannaViewController()
//        present(vc, animated: true, completion: nil)
//        return vc
//    }
}
