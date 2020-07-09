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
    
    let completeButton = UIButton().then {
        $0.frame = CGRect(x: 50, y: 50, width: 70, height: 30)
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.addTarget(self, action: #selector(completeBtn), for: .touchUpInside)
    }
    
    let titleButton = UIButton()
    let titleLabel = UILabel()
    let titleInput = UITextField()
    
    let prevButton = UIButton(type: .custom)
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        
    }
    @objc func completeBtn() {
        bind()
    }
    
    func bind() {
        titleInput.rx.text.orEmpty
            .bind(to: viewModel.input.title)
            .disposed(by: disposeBag)
        
        peopleVC.mannaPeople.rx.text.orEmpty
            .bind(to: viewModel.input.people)
            .disposed(by: disposeBag)
        
        timeVC.mannaTime.rx.text.orEmpty
            .bind(to: viewModel.input.time)
            .disposed(by: disposeBag)
        
        placeVC.mannaPlace.rx.text.orEmpty
            .bind(to: viewModel.input.place)
            .disposed(by: disposeBag)
        
        dismiss(animated: true, completion: nil)
    }
    
    func attribute() {
        view.backgroundColor = .white
        
        prevButton.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        prevButton.addTarget(self, action: #selector(prevBtn), for: .touchUpInside)
        
        nextButton.setTitle("완료", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nextButton.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
        
        titleButton.setTitle("완료", for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.layer.borderWidth = 1.0
        titleButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        titleButton.addTarget(self, action: #selector(titleBtn), for: .touchUpInside)
        
        titleInput.layer.borderWidth = 1.0
        titleInput.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        titleInput.textAlignment = .center
    }
    
    func layout() {
        view.addSubview(completeButton)
        view.addSubview(titleButton)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        titleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        titleButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        titleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(titleInput)
        titleInput.translatesAutoresizingMaskIntoConstraints = false
        titleInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        titleInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleInput.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleInput.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(prevButton)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }
    
    func prevPage() {
        let currentView = pageView.VCArr
        let currentPage = pageView.pageControl.currentPage
        let prevPage = currentPage - 1
        
        if currentPage == 0 {
            self.pageView.view.removeFromSuperview()
            self.titleLabel.removeFromSuperview()
            self.nextButton.removeFromSuperview()
//            view.addSubview(titleInput)
            titleInput.translatesAutoresizingMaskIntoConstraints = false
            titleInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            titleInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleInput.widthAnchor.constraint(equalToConstant: 200).isActive = true
            titleInput.heightAnchor.constraint(equalToConstant: 30).isActive = true

//            view.addSubview(titleButton)
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
        print("\(nextPage)")
        if nextPage < currentView.count {
            let nextVC = currentView[nextPage]
            self.pageView.setViewControllers([nextVC], direction: .forward, animated: true) { _ in
                self.pageView.pageControl.currentPage = nextPage
                print("현재 페이지는 : \(nextPage)Page 입니다.")
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
