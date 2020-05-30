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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
    }
    
    func attribute(){
        title = "맥주리스트"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    func layout() {
        view.addSubview(mannaList)
        
        mannaList.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }

}
