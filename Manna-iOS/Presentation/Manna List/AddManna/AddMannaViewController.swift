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
        view.do {
            $0.backgroundColor = .white
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
            $0.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
        }
    }
    
    func layout() {
        view.addSubview(titleButton)
        view.addSubview(titleInput)
        view.addSubview(titleLabel)
        view.addSubview(prevButton)
        
        titleButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(30)
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
        }
        prevButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(10)
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
        
        if currentPage == 0 {
            self.pageView.view.removeFromSuperview()
            self.titleLabel.removeFromSuperview()
            self.nextButton.removeFromSuperview()
            view.addSubview(titleInput)
            titleInput.translatesAutoresizingMaskIntoConstraints = false
            titleInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            titleInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleInput.widthAnchor.constraint(equalToConstant: 200).isActive = true
            titleInput.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            view.addSubview(titleButton)
            titleButton.translatesAutoresizingMaskIntoConstraints = false
            titleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            titleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            titleButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            titleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.titleInput.transform = self.titleInput.transform.translatedBy(x: 0, y: 40)
            })
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.titleButton.transform = self.titleButton.transform.translatedBy(x: 0, y: 40)
            })
        } else {
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
        titleLabel.text = text
        titleInput.removeFromSuperview()
        titleButton.removeFromSuperview()
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -40)
        })
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.nextButton.transform = self.nextButton.transform.translatedBy(x: 0, y: -40)
        })
        
        view.addSubview(pageView.view)
        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        pageView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        pageView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
