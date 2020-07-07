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
    
    let pageView = MannaPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let titleButton = UIButton()
    let titleLabel = UILabel()
    let titleInput = UITextField()
    
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
    }
    
    func bind() {
        
    }
    
    func attribute() {
        view.backgroundColor = .white

        nextButton.setTitle("완료", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nextButton.addTarget(self, action: #selector(titlebtn), for: .touchUpInside)
        
        titleButton.setTitle("완료", for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.layer.borderWidth = 1.0
        titleButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        titleButton.addTarget(self, action: #selector(titlebtn), for: .touchUpInside)
        
        titleInput.layer.borderWidth = 1.0
        titleInput.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        titleInput.textAlignment = .center
    }
    
    func layout() {
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
    }
    
    func nextBtn() {
        let currentView = pageView.VCArr
        let currentPage = pageView.pageControl.currentPage
        let nextPage = currentPage + 1
        
        if nextPage < currentView.count {
            let nextVC = currentView[nextPage]
            self.pageView.setViewControllers([nextVC], direction: .forward, animated: true) { _ in
                self.pageView.pageControl.currentPage = nextPage
            }
        }
    }
    
    @objc func titlebtn(_ sender: Any) {
        guard let text = titleInput.text,
            text.count > 0 else {
                alert(message: "타이틀을 입력하세요")
                return
        }
        titleLabel.text = text
        titleInput.text = ""
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
