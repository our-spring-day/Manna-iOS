//
//  UserListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Toaster
import Then

class UserListViewController: UIViewController {
    var disposeBag = DisposeBag()
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFriends: [String] = []
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        layout()
        tableViewAttribute()
        bind()
        searchBarAttribute()
    }
    func tableViewAttribute() {
        navigationItem.title = "친구"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.do {
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            $0.register(UserListCell.self, forCellReuseIdentifier: "UserListCell")
            $0.separatorStyle = .singleLine
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 160
        }
    }
    func layout() {
        tableView.do {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    //1. searchResultupdater는 UISearchResultsUpdating 프로토콜을 따르는 UISearchController기반의 새로운 속성 입니다. 이 프로토콜은 UISearchBar 내의 텍스트가 변경되는것을 알립니다.
    //2. 기본적으로, UISearchController는 표시된 뷰를 흐리게(obscure) 만듭니다. 이것은 searchResultsController를 위해 다른 뷰 컨트롤러를 사용한다면 유용합니다. 여기에서는 결과를 표시하는것을 현재뷰로 설정했기 때문에 흐려지는걸 원하지 않습니다.
    //4. iOS11의 새로운 기능에서, NavigationItem으로 searchBar를 추가합니다. 이것은 Interface Builder가 UIsearchController와 아직 호환되지 않기 때문에 필요합니다.
    //5. 마지막으로 뷰 컨트롤러의 definesPresentationContext를 true로 설정하여 UISearchController가 활성화되어있는 동안 사용자가 다른 뷰 컨트롤러로 이동하면 search bar가 화면에 남아 있지 않도록 합니다.
    func searchBarAttribute() {
        searchController.do {
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "친구 검색"
            navigationItem.searchController = $0
            definesPresentationContext = true
        }
    }
    func bind() {
        let input = UserListViewModel.Input(searchKeyword: searchController.searchBar.rx.text.orEmpty.asObservable(),tableView: tableView)
        let userListViewModel = UserListViewModel(input: input)
        filteredFriends = (userListViewModel.outputs?.showFriends)!
//        Observable.of(userListViewModel.outputs!.showFriends)
//            .distinctUntilChanged()
//            .observeOn(MainScheduler.instance)
//            .bind(to: tableView.rx.items) {(tableView, row, item) -> UITableViewCell in
//                let cell = (tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: IndexPath.init(row: row, section: 0)) as? UserListCell)!
//                cell.textLabel?.text = item
////                print(item)
////                print("tablereload")
//                //print(userListViewModel.showFriends)
//                return cell
//        }.disposed(by: disposeBag)
//        searchBar
//                .rx.text // RxCocoa의 Observable 속성
//                .orEmpty // 옵셔널이 아니도록 만듭니다.
//                .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // 0.5초 기다립니다.
//                .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인합니다.
//                .filter { !$0.isEmpty } // 새로운 값이 정말 새롭다면, 비어있지 않은 쿼리를 위해 필터링합니다.
//                .subscribe(onNext: { [unowned self] query in // 이 부분 덕분에 모든 새로운 값에 대한 알림을 받을 수 있습니다.
//                    self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // 도시를 찾기 위한 “API 요청” 작업을 합니다.
//                    self.tableView.reloadData() // 테이블 뷰를 다시 불러옵니다.
//                })
//                .addDisposableTo(disposeBag)
//        }
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
        
    }
}
extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath)
        cell.textLabel?.text = filteredFriends[indexPath.row]
        return cell
    }
}
extension UserListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(filteredFriends)
//        filteredFriends.removeAll(keepingCapacity: false)
//        tableView.reloadData()
//        if(searchController.searchBar.text?.count)!>0{
//            searchResults.removeAll(keepingCapacity: false)
//            searchResults = items.filter { $0.name.localizedCaseInsensitiveContains(searchController.searchBar.text!) } //이건ts이런식으로 쳐도 test가 나옴
//            //searchResults = items.filter { $0.name.localizedStandardContains(searchController.searchBar.text!) }//이건 순서대로 쳐야 나옴 뭘로할지는 고민고민
//            myTableView.reloadData()
//        }else{
//            searchResults.removeAll(keepingCapacity: false)
//            searchResults = items
//            myTableView.reloadData()
//        }
    }
}
