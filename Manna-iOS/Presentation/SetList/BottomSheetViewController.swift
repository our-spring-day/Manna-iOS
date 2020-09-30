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
    var collectionView: DurringMeetingCollectionView?
    var standardY = CGFloat(0)
    var viewModel: DurringMeetingViewModel?
    
    init(frame: CGRect, viewModel: DurringMeetingViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        attribute()
        layout()
        bind()
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
        collectionView = DurringMeetingCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
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
    func bind() {
        self.viewModel?.meetingInfo.asObservable()
            .bind(to: (collectionView?.rx.items(cellIdentifier: CheckedFriendCell.identifier,cellType: CheckedFriendCell.self))!) {(_: Int, element: TempPeopleStruct, cell: CheckedFriendCell) in
                cell.profileImage.image = UIImage(named: "Image-2")
            }
        //추후에 아이템 뿌려놓고나서 테스트해야합니다.
        collectionView?.rx.modelSelected(TempPeopleStruct.self)
            .debug()
            .subscribe(onNext: { _ in
                self.viewModel?.searchMeetingInfo()
            }).disposed(by: disposeBag)
    }
}
