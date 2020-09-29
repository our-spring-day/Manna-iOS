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
    let bottomSheet = BottomSheetViewController(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2))
    var locationManager: CLLocationManager?
    let inviteFriensViewModel = InviteFriendsViewModel()
    var locationOverlay = NMFMapView().locationOverlay
    let marker = NMFMarker()
    var viewModel = DurringMeetingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
        viewModel.meetingInfo.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
    func attribute() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView.do {
            $0.mapType = .basic
            $0.symbolScale = 0.7
            marker.mapView = $0
            $0.positionMode = .direction
        }
        bottomSheet.do {
            $0.backgroundColor = .white
            $0.alpha = 0.9
            $0.collectionView?.delegate = self
            $0.collectionView?.dataSource = self
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
        view.addSubview(bottomSheet)
        
        bottomSheet.snp.makeConstraints {
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

extension SetListViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedFriendCell.identifier, for: indexPath) as! CheckedFriendCell
        cell.XImage.image = UIImage(named: "Image-2")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.searchMeetingInfo()
    }
}
