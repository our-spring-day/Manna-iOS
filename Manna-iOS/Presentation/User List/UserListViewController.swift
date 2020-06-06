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

class UserListViewController: UIViewController{
    var disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    var friends : [String] = ["고영찬","김건년","곽하민","고마워","방구끼","고도망","가야디","콜드","길구","봉구","은하수","1960","블랙","컨테이너","체크남방","휴지조각","넘어로","커피","빨대","핸드폰","케이블"]
    var filteredFriends :[String] = []
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchBar()
        attribute()
        layout()
        setNavigationBar()
        let friends = Observable.just(
            (1...20).map { "\($0)" }
        )
        

        
        //        friends
        //            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
        //                cell.textLabel?.text = "\(element)"
        //            }
        //            .disposed(by: disposeBag)
        //
        //        // 셀을 클릭했을 때 데이터 값을 출력한다.
        //        tableView.rx
        //            .modelSelected(String.self)
        //            .subscribe(onNext:  { item in
        //                print("\(item)")
        //            })
        //            .disposed(by: disposeBag)
    }
    func attribute() {
        //        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.do {
            
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            //            view.addSubview($0)
            $0.register(UserListTableViewCell.self, forCellReuseIdentifier: "UserListTableViewCell")
            $0.separatorStyle = .singleLine
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 160
            //            $0.translatesAutoresizingMaskIntoConstraints = false
            //            $0.topAnchor.constraint(equalTo: self.searchController.searchBar.bottomAnchor, constant: 0).isActive = true
            
            //        self.view.addSubview(tableView)
            //        tableView.translatesAutoresizingMaskIntoConstraints = false
            //        tableView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor).isActive = true
            //        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            //        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            //        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        }
    }
    func createSearchBar() {
        searchController.do{
            view.addSubview($0.searchBar)
            $0.searchBar.setImage(UIImage(named: "user.png"), for: .search, state: .normal)
            $0.searchBar.sizeToFit()
            $0.searchBar.placeholder = "친구 검색"
            $0.searchResultsUpdater = self
            $0.hidesNavigationBarDuringPresentation = false
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
        }
    }
    func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func setNavigationBar(){
        let userListNavigationTitleLabel = UILabel()
        userListNavigationTitleLabel.do{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "친구"
            $0.textAlignment = .left
            navigationItem.titleView = $0
            if let navigationBar = navigationController?.navigationBar {
                $0.widthAnchor.constraint(equalTo: navigationBar.widthAnchor, constant: -100).isActive = true
            }
        }
        //        let addFriendButtonItem = UIBarButtonItem(image: UIImage(named: "searchimage"), style: .plain, target: self, action: #selector(done))
        let addFriendButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = addFriendButtonItem
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.hidesBarsOnSwipe = true//이거 검색창까지 완벽하게 안없어짐 해결 해야됨
    }
    @objc func done() {
        let addUserViewController = AddUserViewController()
        self.navigationController?.pushViewController(addUserViewController, animated: true)
    }
    //    func bind() {
    //            searchController.searchBar.rx.text.orEmpty
    //                //        .debounce(0.5, scheduler: MainScheduler.instance) // 0.5초 기다림. 안 줄 경우, 모든 입력을 받음. (API의 과도한 호출을 방지)
    //                //        .distinctUntilChanged() // 새로운 값이 이전과 같은지 체크 (O -> Oc -> O 값이 이전과 같으므로 다음으로 안넘어감)
    //                .filter({ !$0.isEmpty })
    //                .subscribe(onNext: { query in
    //                    if query == ""{
    //                        self.filteredFriends = self.friends
    //                    }
    //                    else{
    //                        self.filteredFriends = self.friends.filter({ $0.hasPrefix(query) })
    //                        self.tableView.reloadData()
    //    //                    print(self.filteredFriends)
    //
    //                    }
    //                })
    //        }
}
extension UserListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //후에 추가
    }
}
extension UserListViewController: UIScrollViewDelegate{
    override func viewDidAppear(_ animated: Bool) {
        tableView.rx
        .setDelegate(self)
        .disposed(by: disposeBag)
    }
}

//    // MARK: - Property
//    var disposBag = DisposeBag()
//    let screensize: CGRect = UIScreen.main.bounds
//    let searchController = UISearchController(searchResultsController: nil)
//    let tableView: UITableView = {
//        let tableview = UITableView()
//        return tableview
//    }()
//    var friends : [String] = ["고영찬","김건년","곽하민","고마워","방구끼","고도망","가야디","콜드","길구","봉구","은하수","1960","블랙","컨테이너","체크남방","휴지조각","넘어로","커피","빨대","핸드폰","케이블"]
//    var filteredFriends :[String] = []
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        friends = friends.sorted()
//        filteredFriends = friends
//        createSearchBar()
//        setConstraint()
//        setNavigationBar()
//        bind()
//    }
//    func setConstraint() {
//        self.view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "UserListTableViewCell")
//    }
//    func createSearchBar() {
//        view.addSubview(searchController.searchBar)
//        searchController.searchBar.setImage(UIImage(named: "user.png"), for: .search, state: .normal)
//        searchController.searchResultsUpdater = self
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.sizeToFit()
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "친구 검색"
//    }
//    func setNavigationBar(){
//        let userListNavigationTitleLabel = UILabel()
//        userListNavigationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        userListNavigationTitleLabel.text = "친구"
//        userListNavigationTitleLabel.textAlignment = .left
//        navigationItem.titleView = userListNavigationTitleLabel
//        if let navigationBar = navigationController?.navigationBar {
//            userListNavigationTitleLabel.widthAnchor.constraint(equalTo: navigationBar.widthAnchor, constant: -100).isActive = true
//        }
//        let addFriendButtonItem = UIBarButtonItem(image: UIImage(named: "searchimage"), style: .plain, target: self, action: #selector(done))
//        navigationController?.navigationBar.isTranslucent = false
//        navigationItem.rightBarButtonItem = addFriendButtonItem
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.hidesBarsOnSwipe = true//이거 검색창까지 완벽하게 안없어짐 해결 해야됨
//    }
//
//    func bind() {
//        searchController.searchBar.rx.text.orEmpty
//            //        .debounce(0.5, scheduler: MainScheduler.instance) // 0.5초 기다림. 안 줄 경우, 모든 입력을 받음. (API의 과도한 호출을 방지)
//            //        .distinctUntilChanged() // 새로운 값이 이전과 같은지 체크 (O -> Oc -> O 값이 이전과 같으므로 다음으로 안넘어감)
//            .filter({ !$0.isEmpty })
//            .subscribe(onNext: { query in
//                if query == ""{
//                    self.filteredFriends = self.friends
//                }
//                else{
//                    self.filteredFriends = self.friends.filter({ $0.hasPrefix(query) })
//                    self.tableView.reloadData()
////                    print(self.filteredFriends)
//                    self.tableView.reloadData()
//                }
//            })
//    }

//extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
//    //set cell height(다른 메신져 앱을 참고했습니다.)
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return screensize.height/13
//    }
//    //numberOfRowsInSection(현재는 예시로 30명만 후에 수정될 부분)
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredFriends.count
//    }
//    //cellForRowAt
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as? UserListTableViewCell else { return UITableViewCell() }
//
//        cell.label.text = filteredFriends[indexPath.row]
//        print("when cellForRowAt entered")
//        print(filteredFriends[indexPath.row])
//        return cell
//    }
//    //didSelectRowAt
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //프로필 디테일 뷰 띄워주면 됨
//    }
//    //trailingSwipeActions
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            success(true)
//        })
//        //            return UISwipeActionsConfiguration(actions:[deleteAction,shareAction])
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
//}
//extension UserListViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
////        filteredFriends.removeAll()
////        print("when updateSearchesults entered")
////        print(filteredFriends)
//        tableView.reloadData()
//    }
//}
