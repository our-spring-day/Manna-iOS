//
//  MapView.swift
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

class MapView: UIViewController {
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
    
    var testTargetLat = 37.478566
    var testTargetLng = 126.864476
    
    
    var centerLat: Double = 0
    var centerLng: Double = 0
    
    var southWest = NMGLatLng()
    var northEast = NMGLatLng()
    
    var latValue: Double = 0
    var lngValue: Double = 0
    
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
            }).disposed(by: disposeBag)
        
    }
    
    func getX(x1: Double, x2: Double, y1: Double, y2: Double, key: Double) -> Double {
        return (key - (y1 - (y2-y1) / (x2-x1) * x1)) / ((y2-y1) / (x2-x1))
    }
    
    func getY(x1: Double, x2: Double, y1: Double, y2: Double, key: Double) -> Double {
        return (y2-y1) / (x2-x1) * key + (y1 - ((y2-y1)/(x2-x1) * x1))
    }
    
    func result(yPosition: Double? = nil, xPosition: Double? = nil) -> Double {
        if let key = yPosition {
            return getX(x1: centerLng, x2: testTargetLng, y1: centerLat, y2: testTargetLat, key: key)
        } else {
            return getY(x1: centerLng, x2: testTargetLng, y1: centerLat, y2: testTargetLat, key: xPosition!)
        }
    }
    
    func dynamicMarkerLocation(marker: NMFMarker) {
        centerLat = nmapFView.cameraPosition.target.lat
        centerLng = nmapFView.cameraPosition.target.lng
        
        southWest = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest
        northEast = nmapFView.projection.latlngBounds(fromViewBounds: self.view.frame).northEast
        
        if southWest.lng < testTargetLng && testTargetLng < northEast.lng && southWest.lat < testTargetLat && testTargetLat < northEast.lat {
            marker.position = NMGLatLng(lat: testTargetLat, lng: testTargetLng)
            marker.mapView = nmapFView
        } else {
            if testTargetLat < getY(x1: southWest.lng, x2: northEast.lng, y1: southWest.lat, y2: northEast.lat, key: testTargetLng) {
                if testTargetLat < getY(x1: southWest.lng, x2: northEast.lng, y1: northEast.lat, y2: southWest.lat, key: testTargetLng) {
                    //밑

                    marker.position = NMGLatLng(lat: southWest.lat, lng: result(yPosition: southWest.lat))
                    marker.mapView = nmapFView
                } else {
                    //오른
                    marker.position = NMGLatLng(lat: result(xPosition: northEast.lng), lng: northEast.lng)
                    marker.mapView = nmapFView
                    
                }
            } else {
                if testTargetLat < getY(x1: southWest.lng, x2: northEast.lng, y1: northEast.lat, y2: southWest.lat, key: testTargetLng) {
                    //왼
                    marker.position = NMGLatLng(lat: result(xPosition: southWest.lng), lng: southWest.lng)
                    marker.mapView = nmapFView
                } else {
                    //위
                    marker.position = NMGLatLng(lat: nmapFView.projection.latlng(from: CGPoint(x: 0, y: view.bounds.minY + marker.height)).lat, lng: result(yPosition: northEast.lat))
                    marker.mapView = nmapFView
                }
            }
        }
    }
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationOverlay.location = NMGLatLng(lat: locValue.latitude, lng: locValue.longitude)
    }
}

extension MapView: NMFMapViewCameraDelegate {
    //같은 코드가 세 함수에 총 세번 써져있습니다.
    //카메라를 움직이는 모든 순간에 호출을 해줘야하는데 방법이 더 있었으면 좋겠네요
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        dynamicMarkerLocation(marker: marker)
    }
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        dynamicMarkerLocation(marker: marker)
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        dynamicMarkerLocation(marker: marker)
    }
}
