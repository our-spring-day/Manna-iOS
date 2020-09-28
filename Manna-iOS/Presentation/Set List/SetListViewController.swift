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
    let bottomSheet = BottomSheetViewController()
    var locationManager: CLLocationManager?
    let inviteFriensViewModel = InviteFriendsViewModel()
    var locationOverlay = NMFMapView().locationOverlay
    let marker = NMFMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marker.mapView = nmapFView

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        let coor = locationManager?.location?.coordinate
    
        
        attribute()
        layout()
        bind()
        
        nmapFView.positionMode = .direction
        locationOverlay = nmapFView.locationOverlay
        locationOverlay.hidden = false
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
        
        bottomSheet.view.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height)
            $0.centerY.equalTo(view.frame.maxY)
        }
    }
    
    func bind() {
        
    }
}

extension SetListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationOverlay.location = NMGLatLng(lat: locValue.latitude, lng: locValue.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locValue.latitude, lng: locValue.longitude))
        cameraUpdate.animation = .easeOut
        nmapFView.moveCamera(cameraUpdate)
    }
}
