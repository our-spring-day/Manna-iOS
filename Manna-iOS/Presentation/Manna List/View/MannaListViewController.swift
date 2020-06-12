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

class MannaListViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let mannaList = UITableView()
    let mannaListViewModel = MannaListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mannaList.delegate = nil
        mannaList.dataSource = nil
        attribute()
        layout()
        bind()
    }
    
    func bind() {
        mannaListViewModel.allMannas
            .observeOn(MainScheduler.instance)
            .bind(to: mannaList.rx.items(cellIdentifier: MannaListCell.identifier,                                 cellType: MannaListCell.self)) { _, item, cell in
                cell.onData.onNext(item)
            }
            .disposed(by: disposeBag)
    }
    
    func attribute() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        add.rx.tap
            .flatMap(addVC)
            .observeOn(MainScheduler.instance)
            .bind(to: mannaList.rx.items(cellIdentifier: MannaListCell.identifier,                                 cellType: MannaListCell.self)) { _, item, cell in
                cell.onData.onNext(item)
            }
            .disposed(by: disposeBag)

        
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
        mannaList.register(MannaListCell.self, forCellReuseIdentifier: MannaListCell.identifier)
        mannaList.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addVC() -> Observable<[MannaListModel]>{
        let view = AddMannaViewController()
//        self.navigationController?.pushViewController(view, animated: true)
        present(view, animated: true)
        return view.addManna
    }
}
