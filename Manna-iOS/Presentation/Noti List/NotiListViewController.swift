//
//  NotiListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift

class NotiListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = UserListViewModel()
    var collectionView: UICollectionView!
    let layoutValue: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    func attribute() {
        view.do {
            $0.backgroundColor = .white
        }
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutValue)
        collectionView.do {
            $0.backgroundColor = .white
            $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
        layoutValue.do {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
            $0.itemSize = CGSize(width: 40, height: 40)
            $0.scrollDirection = .horizontal
        }
    }
    
    func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(100)
            $0.width.equalTo(400)
            $0.height.equalTo(40)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    func bind() {
        viewModel.filteredFriendsList
            .bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: UICollectionViewCell.self)) {
                (index: Int, element: UserTestStruct, cell: UICollectionViewCell) in
                cell.backgroundColor = .lightGray
                print(index)
                print(element)
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(UserTestStruct.self)
            .subscribe(onNext: { str in
                print(str)
            }).disposed(by: disposeBag)
    }
}
