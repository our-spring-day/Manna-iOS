//
//  PeopleAddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/25.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PeopleAddMannaViewController: UIViewController {
    static let shared = PeopleAddMannaViewController()
    let viewModel: AddMannaViewModelType
    
    lazy var mannaPeople = UITextField()
    
    let disposeBag = DisposeBag()
    init(viewModel: AddMannaViewModelType = AddMannaViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = AddMannaViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    func attribute() {
        mannaPeople.do {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func layout() {
        view.addSubview(mannaPeople)
        mannaPeople.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    func bind() {
        AddMannaViewController.shared.nextButton.rx.tap
            .map { [weak self] _ in
                (self?.mannaPeople.text)!
            }
            .bind(to: viewModel.inputs.people)
            .disposed(by: disposeBag)
    }
}
