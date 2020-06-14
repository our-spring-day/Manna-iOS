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
            let cell = tableView.dequeueReusableCell(withIdentifier: MannaListCell.identifier, for: indexPath) as! MannaListCell
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
    
    @objc func addVC() {
        let view = AddMannaViewController()
        self.navigationController?.pushViewController(view, animated: true)
//        MannaProvider.addManna(manna: Manna(title: "상원", place: "이와", appointmentTime: "떠나는", numberPeople: "여행"))
    }
}

//
//private func bindTableView() {
//    let cities = ["London", "Vienna", "Lisbon"]
//
//    let configureCell: (TableViewSectionedDataSource<SectionModel<String, String>>, UITableView,IndexPath, String) -> UITableViewCell = { (datasource, tableView, indexPath,  element) in
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as? NameCell else { return UITableViewCell() }
//        cell.textLabel?.text = element
//        return cell
//    }
//
//    let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>.init(configureCell: configureCell)
//    datasource.titleForHeaderInSection = { datasource, index in
//        return datasource.sectionModels[index].model
//    }
//    let sections = [
//        SectionModel<String, String>(model: "first section", items: cities),
//        SectionModel<String, String>(model: "second section", items: cities)
//    ]
//    Observable.just(sections)
//        .bind(to: tableView.rx.items(dataSource: datasource))
//        .disposed(by: bag)
//}
