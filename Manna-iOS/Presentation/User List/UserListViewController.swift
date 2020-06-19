//
//  UserListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import Toaster
import UIKit

class UserListViewController: UIViewController {
    var disposeBag = DisposeBag()
    let tableView = UITableView()
    let showFriendsList: [String] = []
    let searchController = UISearchController(searchResultsController: nil)
    let testButton = UIBarButtonItem()
    var viewModel: UserListViewModel!

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableViewSet() {
        tableView.do {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
            $0.separatorStyle = .singleLine
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 160
        }
    }
    func navigationBarSet() {
        navigationItem.title = "친구"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true
        //searchController 세팅
        searchController.do {
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 검색"
            navigationItem.searchController = $0
            definesPresentationContext = true
        }
        testButton.title = "test"
        navigationItem.rightBarButtonItem = testButton
    }
    func bind() {
        let dataSource = BehaviorRelay(value: viewModel.output.showFriendsList)
        dataSource
            .bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) {(index: Int, element: String, cell: UITableViewCell) in
                cell.textLabel!.text = element
        }.disposed(by: disposeBag)
        let newSearchResultModels: [String] = viewModel.output.showFriendsList
        dataSource.accept(newSearchResultModels)
    }
    func selectCell() {
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { model in
                print("\(model) was selected")
            })
            .disposed(by: disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSet()
        navigationBarSet()
        let input = UserListViewModel.Input(text: searchController.searchBar.rx.text.orEmpty.asObservable())
        viewModel = UserListViewModel(input: input)
        bind()
        selectCell()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
extension UserListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.tableView.reloadData()
        print(viewModel.output.showFriendsList)
    }
}
