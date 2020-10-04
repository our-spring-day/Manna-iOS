//
//  SetListViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import CoreLocation
import NMapsMap
import RxSwift
import RxCocoa
import SnapKit

class SetListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var authState: NMFAuthState!
    var nmapFView = NMFMapView()
    let cameraPosition = NMFCameraPosition()
    var bottomSheet: BottomSheetViewController?
    var locationManager: CLLocationManager?
    let inviteFriensViewModel = InviteFriendsViewModel()
    var locationOverlay = NMFMapView().locationOverlay
    let marker = NMFMarker()
    var viewModel = DurringMeetingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheet = BottomSheetViewController(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2),viewModel: viewModel)
        attribute()
        layout()
        bind()
    }
    
    func attribute() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView.do {
            $0.mapType = .basic
            $0.symbolScale = 0.7
            marker.mapView = $0
            $0.positionMode = .direction
        }
        bottomSheet?.do {
            $0.backgroundColor = .white
            $0.alpha = 0.9
        }
        locationManager = CLLocationManager()
        locationManager?.do {
            $0.delegate = self
            $0.requestWhenInUseAuthorization()
            $0.desiredAccuracy = kCLLocationAccuracyBest
            $0.startUpdatingLocation()
        }
        locationOverlay = nmapFView.locationOverlay
        locationOverlay.do {
            $0.hidden = false
        }
    }
    
    func layout() {
        view.addSubview(nmapFView)
        view.addSubview(bottomSheet!)
        
        bottomSheet?.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height)
            $0.centerY.equalTo(view.frame.maxY)
        }
    }
    
    func bind() {
        //나중에 bind를 통해서 컬렉션뷰에 뿌려줄 item 현재는 되는지 만 확인 했고 됨
        viewModel.meetingInfo.subscribe(onNext: {
            print("이거 탑니까>???????",$0)
        }).disposed(by: disposeBag)
    }
}

extension SetListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationOverlay.location = NMGLatLng(lat: locValue.latitude, lng: locValue.longitude)
        //해당 Update 안 파라미터 값으로 이동할 값주면 카메라 이동
//        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locValue.latitude, lng: locValue.longitude))
//        cameraUpdate.animation = .easeOut
//        nmapFView.moveCamera(cameraUpdate)
    }
}
