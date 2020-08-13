//
//  SetListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NMapsMap

class SetListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var authState: NMFAuthState!
    var nmapFView = NMFMapView()
    let cameraPosition = NMFCameraPosition()
    let bottomSheet = BottomSheetViewController()
    let collectionView = DuringMeetingCollectionView()
    let inviteFriensViewModel = InviteFriendsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
        //현재 카메라의 포지션이고 유용하게 사용할듯
        let cameraPosition2 = nmapFView.cameraPosition
        inviteFriensViewModel.outputs.checkedFriendList
            .bind(to: self.collectionView.baseCollectionView.rx.items(cellIdentifier: CheckedFriendCell.identifier, cellType: CheckedFriendCell.self)) { (_: Int, element: UserTestStruct, cell: CheckedFriendCell) in
                cell.profileImage.image = UIImage(named: "\(element.profileImage)")
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
        }.disposed(by: self.disposeBag)
    }
    
    func attribute() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView.do {
            $0.mapType = .basic
            $0.symbolScale = 0.7
        }
        bottomSheet.do {
            $0.didMove(toParent: self)
            $0.view.backgroundColor = .white
            $0.view.alpha = 0.9
        }
    }
    
    func layout() {
        view.addSubview(nmapFView)
        view.addSubview(bottomSheet.view)
        self.addChild(bottomSheet)
        bottomSheet.view.addSubview(collectionView)
        
        bottomSheet.view.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height)
            $0.centerY.equalTo(view.frame.maxY)
        }
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bind() {
        
    }
}
