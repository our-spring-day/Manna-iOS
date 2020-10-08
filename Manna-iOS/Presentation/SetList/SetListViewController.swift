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
    var test: NMGLatLngBounds?
    var cameraflag = 0.00001
    var x: Double?
    var y: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind()
        nmapFView.addCameraDelegate(delegate: self)
    }
    
    func attribute() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView.do {
            $0.mapType = .basic
            $0.symbolScale = 0.7
            $0.positionMode = .direction
        }
        marker.do {
            $0.width = 30
            $0.height = 40
            $0.position = NMGLatLng(lat: 37.411677, lng: 127.128621)
            $0.mapView = nmapFView
        }
        bottomSheet = BottomSheetViewController(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: UIScreen.main.bounds.width,
                                                              height: UIScreen.main.bounds.height/2), viewModel: viewModel)
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
            print("이거 탑니까>???????", $0)
            
        }).disposed(by: disposeBag)
        
        bottomSheet?.collectionView?.rx.modelSelected(TempPeopleStruct.self)
            .subscribe(onNext: { [self] in
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: $0.currentLocation.lat, lng: $0.currentLocation.lng))
                cameraUpdate.animation = .easeOut
                self.nmapFView.moveCamera(cameraUpdate)
                //                cameraflag.toggle()
            }).disposed(by: disposeBag)
    }
    @objc func compareLatLng() {
        
    }
}

extension SetListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationOverlay.location = NMGLatLng(lat: locValue.latitude, lng: locValue.longitude)
    }
}

extension SetListViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        //lng = x lat = y
        
        
        //테스트 좌표
        //(lat: 37.478566, lng: 126.864476)
        
        
        //이게 중앙 좌표
        var centerLat = nmapFView.cameraPosition.target.lat
        var centerLng = nmapFView.cameraPosition.target.lng
        
        //왼쪽 위
        var leftTopLng = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lng
        var leftTopLat = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).northEast.lat
        
        //왼쪽 밑
        var leftBottomLng = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lng
        var leftBottomLat = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lat
        
        //오른쪽 위
        var rightTopLng = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).northEast.lng
        var rightTopLat = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).northEast.lat
        
        //오른쪽 밑
        var rightBottomLng = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).northEast.lng
        var rightBottomLat = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lat
        
        
        
        
        

        marker.position = NMGLatLng(
            lat: nmapFView.projection.latlng(from: CGPoint.init(x: view.frame.maxX - (marker.width / 2), y: 200)).lat,
            lng: nmapFView.projection.latlng(from: CGPoint.init(x: view.frame.maxX - (marker.width / 2), y: 200)).lng
        )
        marker.mapView = nmapFView
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
//        marker.position = NMGLatLng(
//            lat: nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lat - nmapFView.projection.latlng(from: CGPoint.init(x: 100, y: 100)).lat,
//            lng: nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lng - nmapFView.projection.latlng(from: CGPoint.init(x: 100, y: 100)).lng
//        )
//        marker.position = NMGLatLng(
//            lat: nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lat + 0.001,
//            lng: nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lng + 0.001
//        )
        
        marker.position = NMGLatLng(
            lat: nmapFView.projection.latlng(from: CGPoint.init(x: view.frame.maxX - (marker.width / 2), y: 200)).lat,
            lng: nmapFView.projection.latlng(from: CGPoint.init(x: view.frame.maxX - (marker.width / 2), y: 200)).lng
        )
        marker.mapView = nmapFView
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//        marker.position = NMGLatLng(
//            lat: nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lat - nmapFView.projection.latlng(from: CGPoint.init(x: 100, y: 100)).lat,
//            lng: nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lng - nmapFView.projection.latlng(from: CGPoint.init(x: 100, y: 100)).lng
//        )
//        marker.position = NMGLatLng(
//            lat: nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lat + 0.001,
//            lng: nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest.lng + 0.001
//        )
        marker.position = NMGLatLng(
            lat: nmapFView.projection.latlng(from: CGPoint.init(x: view.frame.maxX - (marker.width / 2), y: 200)).lat,
            lng: nmapFView.projection.latlng(from: CGPoint.init(x: view.frame.maxX - (marker.width / 2), y: 200)).lng
        )
        marker.mapView = nmapFView
    }
}
