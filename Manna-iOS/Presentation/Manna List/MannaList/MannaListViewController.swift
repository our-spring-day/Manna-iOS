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
    
    let mannaListViewModel: MannaListViewModelType
    
    let mannaList = UITableView()
    
    // MARK: - Life Cycle

    init(viewModel: MannaListViewModelType = MannaListViewModel()) {
        self.mannaListViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        mannaListViewModel = MannaListViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    func attribute() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVC))
        navigationItem.do {
            $0.rightBarButtonItem = add
            $0.title = "약속목록"
        }
        view.do {
            $0.backgroundColor = .white
        }
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
        
        mannaListViewModel.outputs.allMannas
            .bind(to: mannaList.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    @objc func addVC() {
        let view = AddMannaViewController()
        view.hidesBottomBarWhenPushed = true
        view.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(view, animated: true)
    }
}
