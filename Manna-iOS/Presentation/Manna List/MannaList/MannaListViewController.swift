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
import RxDataSources
import SnapKit

class MannaListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let mannaList = UITableView()
    let mannaListViewModel = MannaListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<MannaSection>(
            configureCell: { _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MannaListCell.identifier, for: indexPath) as? MannaListCell else { return UITableViewCell() }
                cell.title.text = item.title
                cell.place.text = item.place
                cell.appointmentTime.text = item.appointmentTime
                cell.numberPeople.text = item.numberPeople
                return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].status
        }
        
        mannaListViewModel.allMannas
            .bind(to: mannaList.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //        // items 를 바인딩함으로써 datasource값을 가져와 tableView를 뿌려줌
        //        mannaListViewModel.allMannas
        //            .bind(to: mannaList.rx.items(cellIdentifier: MannaListCell.identifier, cellType: MannaListCell.self)) {
        //                _, item, cell in
        //                cell.title.text = item?.title
        //                cell.place.text = item?.place
        //                cell.appointmentTime.text = item?.appointmentTime
        //                cell.numberPeople.text = item?.numberPeople
        //            }
        //            .disposed(by: disposeBag)
    }
    
    func attribute() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVC))
        self.navigationItem.rightBarButtonItem = add
        self.navigationItem.title = "약속목록"
        view.backgroundColor = .white
        
        mannaList.do {
            $0.backgroundView?.isHidden = true
            $0.register(MannaListCell.self, forCellReuseIdentifier: MannaListCell.identifier)
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
        let view = TitleAddMannaViewController()
        view.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(view, animated: true)
    }
}
