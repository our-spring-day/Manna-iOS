//
//  AddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/08/05.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddMannaViewController: UIViewController, UITextFieldDelegate {
    let disposeBag = DisposeBag()
    
    let viewModel: AddMannaViewModelType
    static let shared = AddMannaViewController()
    
    let people = PeopleAddManna()
    let time = TimeAddManna()
    let place = PlaceAddManna()
    let finalAdd = FinalAddManna()

    let scrollView = UIScrollView()
    let titleLabel = UILabel()
    let titleInput = UITextField()
    let titleButton = UIButton()
    
    let prevButton = UIButton(type: .custom)
    let nextButton = UIButton()
    
    init(viewModel: AddMannaViewModelType = AddMannaViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = AddMannaViewModel()
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
    }
    
    func bind() {
        place.searchButton.rx.tap
            .flatMap(selectedPlace)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] address in
                self?.finalAdd.finalPlace.text = address.address
            })
            .disposed(by: disposeBag)
    }

    func attribute() {
        navigationController?.isNavigationBarHidden = true
        
        place.searchButton.addTarget(self, action: #selector(gogogo), for: .touchUpInside)
        
        people.mannaPeople.delegate = people
        scrollView.do {
            $0.isHidden = true
            $0.backgroundColor = .red
            $0.bounces = false
        }
        titleLabel.do {
            $0.isHidden = true
        }
        titleInput.do {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.textAlignment = .center
            $0.delegate = self
        }
        titleButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.addTarget(self, action: #selector(titleBtn), for: .touchUpInside)
        }
        prevButton.do {
            $0.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
            $0.addTarget(self, action: #selector(prevBtn), for: .touchUpInside)
        }
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.isHidden = true
            $0.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
        }
    }

    func layout() {
        view.addSubview(titleButton)
        view.addSubview(titleInput)
        view.addSubview(scrollView)
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        scrollView.addSubview(people)
        scrollView.addSubview(time)
        scrollView.addSubview(place)
        scrollView.addSubview(finalAdd)
        
        titleInput.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        titleButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        prevButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(10)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        people.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        time.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(people.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        place.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(time.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        finalAdd.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(place.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    func selectedPlace() -> Observable<Address> {
        let view = SelectPlaceViewController.shared
        view.searchText.text = place.mannaPlace.text
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
        return view.selectedAddress
    }
    
    @objc func titleBtn(_ sender: Any) {
        guard let text = titleInput.text,
            text.count > 0 else {
                alert(message: "타이틀을 입력하세요")
                return
        }
        
        scrollView.isHidden = false
        nextButton.isHidden = false
        titleButton.isHidden = true
    }
    
    @objc func prevBtn(_ sender: Any) {
        if scrollView.isHidden == true {
            navigationController?.popViewController(animated: true)
        } else if scrollView.isHidden == false && scrollView.contentOffset.x == 0 {
            scrollView.isHidden = true
        } else if scrollView.isHidden == false {
            let minWidth = max(scrollView.contentOffset.x - view.frame.width, 0)
            let newOffset = CGPoint(x: minWidth, y: 0)
            scrollView.contentOffset = newOffset
        }
    }
    
    @objc func nextBtn(_ sender: Any) {
        if scrollView.isHidden == false {
            let maxWidth = min(scrollView.contentOffset.x + view.frame.width, view.frame.width * 2)
            let newOffset = CGPoint(x: maxWidth, y: 0)
            scrollView.contentOffset = newOffset
        }
    }
    @objc func gogogo(_ sender: Any) {
        let view = SelectPlaceViewController.shared
        view.searchText.text = place.mannaPlace.text
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
    }
}

extension AddMannaViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
