//
//  PlaceAddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/23.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class PlaceAddMannaViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel: AddMannaViewModelType
    
    static let shared = PlaceAddMannaViewController()
    
    let line = UIBezierPath()
    let descriptLabel = UILabel()
    let mannaPlace = UITextField()
    let searchButton = UIButton()
    let selectButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(viewModel: AddMannaViewModelType = AddMannaViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("PlaceAddMannaViewController===========")
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
        view.do {
            $0.backgroundColor = .white
        }
        line.do {
            $0.lineWidth = 2
        }
        descriptLabel.do {
            $0.text = "지번, 도로명, 건물명을 입력하세요."
            $0.textColor = .black
        }
        mannaPlace.do {
            $0.placeholder = "  예) 만나동12-3 또는 만나아파트"
        }
        searchButton.do {
            $0.setTitle("검색", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        selectButton.do {
            $0.setTitle("현위치로 주소설정", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func layout() {
        let drawLine = DrawLine(frame: self.view.frame)
        drawLine.backgroundColor = .clear
        self.view.addSubview(drawLine)
        
        view.addSubview(descriptLabel)
        view.addSubview(mannaPlace)
        view.addSubview(searchButton)
        view.addSubview(selectButton)
        
        descriptLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(40)
        }
        mannaPlace.snp.makeConstraints {
            $0.top.equalTo(descriptLabel.snp.top).offset(70)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(290)
            $0.height.equalTo(40)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalTo(mannaPlace)
            $0.leading.equalTo(mannaPlace.snp.trailing).offset(5)
            $0.trailing.equalTo(view.snp.trailing).offset(-5)
            $0.width.equalTo(50)
            $0.height.equalTo(40)
        }
        selectButton.snp.makeConstraints {
            $0.top.equalTo(mannaPlace.snp.bottom).offset(40)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(290)
            $0.height.equalTo(40)
        }
    }
    
    func bind() {
        searchButton.rx.tap
            .map({ [weak self] _ in
                (self?.mannaPlace.text)!
            })
            .do(onNext: { str in
                let view = SelectPlaceViewController()
                view.modalPresentationStyle = .overFullScreen
                view.searchText.text = str
                self.present(view, animated: true, completion: nil)
            })
            .bind(to: self.viewModel.inputs.address)
            .disposed(by: disposeBag)
    }
}
