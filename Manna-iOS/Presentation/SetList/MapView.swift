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
    let testmarker = NMFMarker()
    var viewModel = DurringMeetingViewModel()
    
    var testTargetLat = 37.478566
    var testTargetLng = 126.864476
    
    
    var centerLat: Double = 0
    var centerLng: Double = 0
    var latValue: Double = 0
    var lngValue: Double = 0
    
    var aLine = NMFPath()
    var bLine = NMFPath()
    var cLine = NMFPath()
    
    
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
    
    func getLinearEquation(x1: Double, x2: Double, y1: Double, y2: Double)  -> [Double] {
        let inclination = ((y2-y1) / (x2-x1))
        let constant = (y1 - ((y2-y1)/(x2-x1) * x1))
        return [inclination, constant]
    }
    
    func getCrossPoint(centerLng: Double,
                       centerLat: Double,
                       targetLng: Double,
                       targetLat: Double,
                       frameLng1: Double,
                       frameLat1: Double,
                       frameLng2: Double,
                       frameLat2: Double) -> [Double] {
        //a1,b1
        var first = getLinearEquation(x1: centerLng, x2: targetLng, y1: centerLat, y2: targetLat)
        //a2,b2
        var second = getLinearEquation(x1: frameLng1, x2: frameLng2, y1: frameLat1, y2: frameLat2)
        
        if second[0].isInfinite {
            //x = b 일때 분기
            return [frameLng1, (first[0] * frameLng1) + first[1]]
        }
//             (- (b1       -        b2) / (a1       -       a2), a1       * ( -(b1       -        b2) / (a1       -        a2)) +       b1)
        var newLng = -((first[1] - second[1]) / (first[0] - second[0]))
        var newLat = first[0] * ( -(first[1] - second[1]) / (first[0] - second[0]))
        
        return [newLng, newLat + first[1]]
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
        
        var southWest = nmapFView.projection.latlng(from: CGPoint(x: 0, y: view.frame.height))
        var northEast = nmapFView.projection.latlng(from: CGPoint(x: view.frame.width, y: 0))
        var northWest = nmapFView.projection.latlng(from: CGPoint(x: 0, y: 0))
        var southEast = nmapFView.projection.latlng(from: CGPoint(x: view.frame.width, y: view.frame.height))
        
        aLine.path = NMGLineString(points: [
            NMGLatLng(lat: southWest.lat, lng: southWest.lng),
            NMGLatLng(lat: northEast.lat, lng: northEast.lng)
        ])
        aLine.color = .blue
        aLine.mapView = nmapFView
        
        bLine.path = NMGLineString(points: [
            NMGLatLng(lat: northWest.lat, lng: northWest.lng),
            NMGLatLng(lat: southEast.lat, lng: southEast.lng)
        ])
        bLine.color = .blue
        bLine.mapView = nmapFView

        var test = NMGLatLngBounds(southWest: southWest, northEast: northEast)
        nmapFView.projection.latlngBounds(fromViewBounds: view.frame)
        
        cLine.path = NMGLineString(points: [
            NMGLatLng(lat: nmapFView.projection.latlngBounds(fromViewBounds: view.frame).southWestLat, lng: nmapFView.projection.latlngBounds(fromViewBounds: view.frame).southWestLng),
            NMGLatLng(lat: nmapFView.projection.latlngBounds(fromViewBounds: view.frame).northEastLat, lng: nmapFView.projection.latlngBounds(fromViewBounds: view.frame).northEastLng)
        ])
        cLine.color = .red
        cLine.mapView = nmapFView
        
        
        if nmapFView.projection.point(from: NMGLatLng(lat: testTargetLat, lng: testTargetLng)).x < view.frame.width &&
            0 < nmapFView.projection.point(from: NMGLatLng(lat: testTargetLat, lng: testTargetLng)).x &&
            nmapFView.projection.point(from: NMGLatLng(lat: testTargetLat, lng: testTargetLng)).y < view.frame.height &&
            0 < nmapFView.projection.point(from: NMGLatLng(lat: testTargetLat, lng: testTargetLng)).y
            {
            marker.position = NMGLatLng(lat: testTargetLat, lng: testTargetLng)
            marker.mapView = nmapFView
        } else {
            if testTargetLat < getY(x1: southWest.lng, x2: northEast.lng, y1: southWest.lat, y2: northEast.lat, key: testTargetLng) {
                print("A보다 밑이야")
                if testTargetLat < getY(x1: northWest.lng, x2: southEast.lng, y1: northWest.lat, y2: southEast.lat, key: testTargetLng) {
                    //밑
                    print("밑")
                    var newLatLng = getCrossPoint(centerLng: centerLng,
                                                 centerLat: centerLat,
                                                 targetLng: testTargetLng,
                                                 targetLat: testTargetLat,
                                                 frameLng1: southWest.lng,
                                                 frameLat1: southWest.lat,
                                                 frameLng2: southEast.lng,
                                                 frameLat2: southEast.lat)
                    marker.position = NMGLatLng(lat: newLatLng[1], lng: newLatLng[0])
                    marker.mapView = nmapFView
                } else {
                    //오른
                    print("오른")
                    var newLatLng = getCrossPoint(centerLng: centerLng,
                                                  centerLat: centerLat,
                                                  targetLng: testTargetLng,
                                                  targetLat: testTargetLat,
                                                  frameLng1: northEast.lng,
                                                  frameLat1: northEast.lat,
                                                  frameLng2: southEast.lng,
                                                  frameLat2: southEast.lat)
                    marker.position = NMGLatLng(lat: newLatLng[1], lng: newLatLng[0])
                    marker.mapView = nmapFView
                }
            } else {
                //A 보다 위야
                print("A보다 위야")
                if testTargetLat < getY(x1: northWest.lng, x2: southEast.lng, y1: northWest.lat, y2: southEast.lat, key: testTargetLng) {
                    //왼
                    print("왼")
                    var newLatLng = getCrossPoint(centerLng: centerLng,
                                                  centerLat: centerLat,
                                                  targetLng: testTargetLng,
                                                  targetLat: testTargetLat,
                                                  frameLng1: northWest.lng,
                                                  frameLat1: northWest.lat,
                                                  frameLng2: southWest.lng,
                                                  frameLat2: southWest.lat)
                    marker.position = NMGLatLng(lat: newLatLng[1], lng: newLatLng[0])
                    marker.mapView = nmapFView
                } else {
                    //위
                    print("위")
                    var newLatLng = getCrossPoint(centerLng: centerLng,
                                                  centerLat: centerLat,
                                                  targetLng: testTargetLng,
                                                  targetLat: testTargetLat,
                                                  frameLng1: northWest.lng,
                                                  frameLat1: northWest.lat,
                                                  frameLng2: northEast.lng,
                                                  frameLat2: northEast.lat)
                    marker.position = NMGLatLng(lat: newLatLng[1], lng: newLatLng[0])
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
