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
        static var partialViewYPosition: CGFloat { 700 }
    }
}
class BottomSheetViewController: UIView {
    let disposeBag = DisposeBag()
    var collectionView: DurringMeetingCollectionView?
    var viewModel: DurringMeetingViewModel?
    var backgroundView = UIImageView()
    var standardY = CGFloat(0)
    var expectArrivedTime = UILabel()
    var arriveTextField = UILabel()
    var remainingTimeLabel = UILabel()
    var remmainingTime = UILabel()
    var doneButton = UIButton()
    var bar = UIImageView()
    
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
        }
        bar.do {
            $0.image = #imageLiteral(resourceName: "bottomsheetbar")
        }
        backgroundView.do {
            $0.image = #imageLiteral(resourceName: "bottomsheet")
            $0.addGestureRecognizer(gesture)
            $0.isUserInteractionEnabled = true
        }
        remainingTimeLabel.do {
            $0.text = "남은 시간"
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.textColor = .gray
        }
        remmainingTime.do {
            $0.text = "50:12"
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.textColor = UIColor(named: "keyColor")
        }
        collectionView = DurringMeetingCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        collectionView?.do {
            $0.backgroundColor = .white
        }
        expectArrivedTime.do {
            $0.text = "예상 도착 순위"
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    func layout() {
        addSubview(backgroundView)
        [collectionView!, expectArrivedTime, bar, remainingTimeLabel, remmainingTime].forEach { backgroundView.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        expectArrivedTime.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(30)
            $0.width.equalTo(200)
            $0.height.equalTo(20)
        }
        collectionView?.snp.makeConstraints {
            $0.top.equalTo(expectArrivedTime.snp.bottom)
            $0.width.centerX.equalTo(self)
            $0.leading.equalTo(self).offset(30)
        }
        remainingTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(self).offset(-70)
            $0.width.equalTo(70)
            $0.centerY.equalTo(expectArrivedTime.snp.centerY)
            $0.height.equalTo(20)
        }
        remmainingTime.snp.makeConstraints {
            $0.centerY.equalTo(expectArrivedTime.snp.centerY)
            $0.leading.equalTo(remainingTimeLabel.snp.trailing)
            $0.width.equalTo(70)
            $0.height.equalTo(20)
        }
        bar.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(11.5)
            $0.centerX.equalTo(self)
            $0.width.equalTo(60)
            $0.height.equalTo(2.94)
        }
    }
    func bind() {
        self.viewModel?.meetingInfo.asObservable()
            .bind(to: (collectionView?.rx.items(cellIdentifier: CheckedFriendCell.identifier,cellType: CheckedFriendCell.self))!) {(_: Int, element: TempPeopleStruct, cell: CheckedFriendCell) in
                cell.profileImage.image = #imageLiteral(resourceName: "profile")
                cell.XImage.isHidden = true
            }.disposed(by: disposeBag)
    }
}

