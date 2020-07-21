//
//  AddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/06/05.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class AddMannaViewController: UIViewController {
    let disposeBag = DisposeBag()
    var pageflag: Bool = false
    
    let viewModel = AddMannaViewModel()
    let pageView = MannaPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let peopleVC = PeopleAddMannaViewController.shared
    let timeVC = TimeAddMannaViewController.shared
    let placeVC = PlaceAddMannaViewController.shared
    
    let titleLabel = UILabel()
    let titleInput = UITextField()
    let titleButton = UIButton()
    let prevButton = UIButton(type: .custom)
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleInput.rx.text.orEmpty
            .subscribe(onNext: { [weak self] str in
                self?.titleLabel.text = str
            })
            .disposed(by: disposeBag)
        
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func attribute() {
        pageView.view.do {
            $0.isHidden = true
        }
        view.do {
            $0.backgroundColor = .white
        }
        titleLabel.do {
            $0.isHidden = true
        }
        titleInput.do {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.textAlignment = .center
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
            $0.setTitle("완료", for: .normal)
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
        view.addSubview(titleLabel)
        view.addSubview(prevButton)
        view.addSubview(pageView.view)
        view.addSubview(nextButton)
        
        titleButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        titleInput.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
        }
        prevButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(10)
        }
        pageView.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
    }
    
    func bind() {
        titleInput.rx.text.orEmpty
            .bind(to: viewModel.input.title)
            .disposed(by: disposeBag)
        
        peopleVC.mannaPeople.rx.text.orEmpty
            .bind(to: viewModel.input.people)
            .disposed(by: disposeBag)
        
        timeVC.onPicker.rx.date
            .map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM월 dd일 hh시mm분"
                return dateFormatter.string(from: $0)
        }
        .bind(to: viewModel.input.time)
        .disposed(by: disposeBag)
        
        placeVC.mannaPlace.rx.text.orEmpty
            .bind(to: viewModel.input.place)
            .disposed(by: disposeBag)
        
        peopleVC.mannaPeople.text = ""
        placeVC.mannaPlace.text = ""
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func prevPage() {
        let currentView = pageView.VCArr
        let currentPage = pageView.pageControl.currentPage
        let prevPage = currentPage - 1
        
        if pageView.view.isHidden == true && pageflag == false {
            self.navigationController?.popViewController(animated: true)
        }
        
        if currentPage == 0 {
            self.pageView.view.isHidden = true
            self.pageflag = false
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.titleLabel.transform = CGAffineTransform.identity
                self.nextButton.transform = CGAffineTransform.identity
            }) { _ in
                self.titleLabel.isHidden = true
                self.nextButton.isHidden = true
                
                self.titleInput.isHidden = false
                self.titleButton.isHidden = false
            }
        } else if currentPage >= 1 {
            let prevVC = currentView[prevPage]
            self.pageView.setViewControllers([prevVC], direction: .reverse, animated: true) { _ in
                self.pageView.pageControl.currentPage = prevPage
            }
        }
    }
    
    func nextPage() {
        let currentView = pageView.VCArr
        let currentPage = pageView.pageControl.currentPage
        let nextPage = currentPage + 1
        if currentPage == 2 {
            bind()
        }
        if nextPage < currentView.count {
            let nextVC = currentView[nextPage]
            self.pageView.setViewControllers([nextVC], direction: .forward, animated: true) { _ in
                self.pageView.pageControl.currentPage = nextPage
            }
        }
    }
    
    @objc func prevBtn(_ sender: Any) {
        prevPage()
    }
    
    @objc func nextBtn(_ sender: Any) {
        nextPage()
    }
    
    @objc func titleBtn(_ sender: Any) {
        guard let text = titleInput.text,
            text.count > 0 else {
                alert(message: "타이틀을 입력하세요")
                return
        }

        titleInput.isHidden = true
        titleButton.isHidden = true
        titleLabel.isHidden = false
        nextButton.isHidden = false
        
        UIView.animate(withDuration: 0.7, animations: {
            let move = CGAffineTransform(translationX: 0, y: -40)
            self.titleLabel.transform = move
        })
        
        UIView.animate(withDuration: 0.7, animations: {
            let move = CGAffineTransform(translationX: 0, y: -40)
            self.nextButton.transform = move
        }) { _ in
            self.pageView.view.isHidden = false
            self.pageflag = true
        }
    }
}
