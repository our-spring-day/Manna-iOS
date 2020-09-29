//
//  BottomSheetViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/08/05.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

extension BottomSheetViewController {
    private enum State {
        case partial
        case full
    }
    
    private enum Constant {
        static let fullViewYPosition: CGFloat = 500
        static var partialViewYPosition: CGFloat { 750 }
    }
}
class BottomSheetViewController: UIView {
    let disposeBag = DisposeBag()
    var collectionView: DuringMeetingCollectionView?
    var standardY = CGFloat(0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
        self.frame = CGRect(x: 0,
                            y: yPosition,
                            width: self.frame.width,
                            height: self.frame.height)
    }
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let minY = self.frame.minY
        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
            self.frame = CGRect(x: 0,
                                y: minY,
                                width: self.frame.width,
                                height: self.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .began {
            standardY = recognizer.location(in: self).y
        } else if recognizer.state == .changed {
            self.center.y = (self.center.y + recognizer.location(in: self).y) - standardY
            
        } else if recognizer.state == .ended {
            self.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: .allowUserInteraction,
                           animations: {
                            let state: State = recognizer.velocity(in: self).y >= 0 ?
                                .partial : .full
                            self.moveView(state: state)},
                           completion: { _ in
                self.isUserInteractionEnabled = true }
            )
        }
    }
    
    func attribute() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        self.do {
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.addGestureRecognizer(gesture)
        }
        collectionView = DuringMeetingCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        collectionView?.do {
            $0.backgroundColor = .red
        }
    }
    func layout() {
        addSubview(collectionView!)
        
        collectionView?.snp.makeConstraints {
            $0.top.width.centerX.equalTo(self)
        }
    }
}
//class BottomSheetViewController: UIView {
//    let disposeBag = DisposeBag()
//    var collectionView: DuringMeetingCollectionView?
//    var standardY = CGFloat(0)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
//        view.addGestureRecognizer(gesture)
//
//        roundViews()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 0.1, animations: { self.moveView(state: .partial)
//        })
//    }
//
//    private func moveView(state: State) {
//        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
//        view.frame = CGRect(x: 0,
//                            y: yPosition,
//                            width: view.frame.width,
//                            height: view.frame.height)
//    }
//
//    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: view)
//        let minY = view.frame.minY
//        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
//            view.frame = CGRect(x: 0,
//                                y: minY,
//                                width: view.frame.width,
//                                height: view.frame.height)
//            recognizer.setTranslation(CGPoint.zero, in: view)
//        }
//    }
//
//    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
//        moveView(panGestureRecognizer: recognizer)
//
//        if recognizer.state == .began {
//            standardY = recognizer.location(in: view).y
//        } else if recognizer.state == .changed {
//            view.center.y = (view.center.y + recognizer.location(in: view).y) - standardY
//
//        } else if recognizer.state == .ended {
//            self.view.isUserInteractionEnabled = false
//            UIView.animate(withDuration: 0.3,
//                           delay: 0.0,
//                           options: .allowUserInteraction,
//                           animations: {
//                            let state: State = recognizer.velocity(in: self.view).y >= 0 ?
//                                .partial : .full
//                            self.moveView(state: state)},
//                           completion: { _ in
//                self.view.isUserInteractionEnabled = true }
//            )
//        }
//    }
//
//    func roundViews() {
//        view.layer.cornerRadius = 20
//        view.clipsToBounds = true
//    }
//}
