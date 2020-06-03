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
                index, item, cell in
                cell.title.text = item.title
                cell.place.text = item.place
                cell.appointmentTime.text = item.appointmentTime
                cell.numberPeople.text = item.numberPeople
        }
        .disposed(by: disposeBag)
    }
    
    func attribute() {
        self.navigationItem.title = "만나리스트"
        view.backgroundColor = .white
//        navigationController?.navigationBar.prefersLargeTitles = true

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
}
