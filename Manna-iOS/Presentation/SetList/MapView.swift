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
    var test: NMGLatLngBounds?
    var cameraflag = 0.00001
    
    var testTargetLat = 37.478566
    var testTargetLng = 126.864476
    
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
    // x = b = 즉 위쪽 아래쪽 모서리때 사용할 함수
    func getX(x1: Double, x2: Double, y1: Double, y2: Double) -> Double {
        return (-(y2 - y1) / (x2 - x1))
    }
    
    //y = b 즉 왼쪽 오른쪽 모서리때 사용할 함수
    func getY(x1: Double, x2: Double, y1: Double, y2: Double) -> Double {
        return ((y2 - y1) / (x2 - x1) * ((x2 * y1 - x1 * y2) / (x2 - x1))) + ((x2 * y1 - x1 * y2) / (x2 - x1))
    }
    
    func testGetYFunc(x1: Double, x2: Double, y1: Double, y2: Double, key: Double) -> Double {
        //x값을 넣어 y를 알아냄
        var result = (y2-y1) / (x2-x1) * key + (y1 - ((y2-y1)/(x2-x1) * x1))
        return result
    }
    func testGetXFunc(x1: Double, x2: Double, y1: Double, y2: Double, key: Double) -> Double {
        //y값을 넣어 x를 알아냄
        var result = ((y1 - ((y2-y1)/(x2-x1) * x1)) - key) / (y2-y1) / (x2-x1)
        return result
    }
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //제 위치에용
        locationOverlay.location = NMGLatLng(lat: locValue.latitude, lng: locValue.longitude)
    }
}

extension MapView: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
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
        
        //좌표가 카메라 안에 들어와 있을 때
        //두선분의 교차점이 없을 때
        if leftTopLng < testTargetLng && testTargetLng < rightTopLng && leftBottomLat < testTargetLat && testTargetLat < leftTopLat {
            marker.position = NMGLatLng(lat: testTargetLat, lng: testTargetLng)
            marker.mapView = nmapFView
        }
        //좌표가 카메라 밖에 있을 때
        //교차점이 있을 때
        else if testTargetLng < leftBottomLng {
            //좌표가 카메라보다 왼쪽에 있을 때
            if testTargetLat < leftBottomLat {
                let getYResult = testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftBottomLng)
                if getYResult < leftBottomLat {
                    marker.position = NMGLatLng(lat: leftBottomLat, lng: testGetXFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftBottomLat))
                    marker.mapView = nmapFView
                } else {
                    marker.position = NMGLatLng(lat: getYResult, lng: leftBottomLng)
                    marker.mapView = nmapFView
                }
            }else if testTargetLat < leftTopLat && leftBottomLat < testTargetLat {
                marker.position = NMGLatLng(lat: testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLng), lng: leftTopLng)
                marker.mapView = nmapFView
            }
            
            
            
            
            
            
            
            else {
                //2
                //좌표가 카메라보다 왼쪽에 있고 위에 있을 때
                let getYResult = testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLng)
                if getYResult < leftTopLat {
                    marker.position = NMGLatLng(lat: getYResult, lng: leftTopLng)
                    marker.mapView = nmapFView
                }else {
                    marker.position = NMGLatLng(lat: leftTopLat, lng: testGetXFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLat))
                    marker.mapView = nmapFView
                }
            }
            
            
            
            
            
            
            
            
        }else {
            
            if testTargetLat < rightBottomLat {
                let getYResult = getY(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng)
                
                if getYResult < rightBottomLat {
                    marker.position = NMGLatLng(lat: rightBottomLat, lng: getX(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng))
                    marker.mapView = nmapFView
                }else {
                    marker.position = NMGLatLng(lat: getYResult, lng: rightBottomLng)
                    marker.mapView = nmapFView
                }
            }else if testTargetLat < rightTopLat && rightBottomLat < testTargetLat {
                //끝 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                marker.position = NMGLatLng(lat: testGetYFunc(x1: centerLng, x2: testTargetLng, y1: centerLat, y2: testTargetLat, key: rightBottomLng), lng: rightBottomLng)
                marker.mapView = nmapFView
            }
            
            else {
                //4
                //좌표가 카메라보다 오른쪽에 있고 위에 있을 때
                let getYResult = getY(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng)
        
                if getYResult < rightTopLat {
                    marker.position = NMGLatLng(lat: getYResult, lng: rightTopLng)
                    marker.mapView = nmapFView
                }else {
                    marker.position = NMGLatLng(lat: rightTopLng, lng: getX(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng))
                    marker.mapView = nmapFView
                }
            }
        }
    }
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
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
        
        //좌표가 카메라 안에 들어와 있을 때
        //두선분의 교차점이 없을 때
        if leftTopLng < testTargetLng && testTargetLng < rightTopLng && leftBottomLat < testTargetLat && testTargetLat < leftTopLat {
            marker.position = NMGLatLng(lat: testTargetLat, lng: testTargetLng)
            marker.mapView = nmapFView
        }
        //좌표가 카메라 밖에 있을 때
        //교차점이 있을 때
        else if testTargetLng < leftBottomLng {
            if testTargetLat < leftBottomLat {
                let getYResult = testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftBottomLng)
                if getYResult < leftBottomLat {
                    marker.position = NMGLatLng(lat: leftBottomLat, lng: testGetXFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftBottomLat))
                    marker.mapView = nmapFView
                } else {
                    marker.position = NMGLatLng(lat: getYResult, lng: leftBottomLng)
                    marker.mapView = nmapFView
                }
            }else if testTargetLat < leftTopLat && leftBottomLat < testTargetLat {
                marker.position = NMGLatLng(lat: testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLng), lng: leftTopLng)
                marker.mapView = nmapFView
            }
            
            
            
            
            
            
            
            
            
            else {
                //2
                //좌표가 카메라보다 왼쪽에 있고 위에 있을 때
                let getYResult = testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLng)
                if getYResult < leftTopLat {
                    marker.position = NMGLatLng(lat: getYResult, lng: leftTopLng)
                    marker.mapView = nmapFView
                }else {
                    marker.position = NMGLatLng(lat: leftTopLat, lng: testGetXFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLat))
                    marker.mapView = nmapFView
                }
            }
            
            
            
            
            
            
            
            
            
            
            
            
        }else {
            
            if testTargetLat < rightBottomLat {
                let getYResult = getY(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng)
                
                if getYResult < rightBottomLat {
                    marker.position = NMGLatLng(lat: rightBottomLat, lng: getX(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng))
                    marker.mapView = nmapFView
                }else {
                    marker.position = NMGLatLng(lat: getYResult, lng: rightBottomLng)
                    marker.mapView = nmapFView
                }
            }else if testTargetLat < rightTopLat && rightBottomLat < testTargetLat {
                
                marker.position = NMGLatLng(lat: testGetYFunc(x1: centerLng, x2: testTargetLng, y1: centerLat, y2: testTargetLat, key: rightBottomLng), lng: rightBottomLng)
                marker.mapView = nmapFView
            }
            
            else {
                //4
                //좌표가 카메라보다 오른쪽에 있고 위에 있을 때
                let getYResult = getY(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng)
        
                if getYResult < rightTopLat {
                    marker.position = NMGLatLng(lat: getYResult, lng: rightTopLng)
                    marker.mapView = nmapFView
                }else {
                    marker.position = NMGLatLng(lat: rightTopLng, lng: getX(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng))
                    marker.mapView = nmapFView
                }
            }
        }
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
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
        
        //좌표가 카메라 안에 들어와 있을 때
        //두선분의 교차점이 없을 때
        if leftTopLng < testTargetLng && testTargetLng < rightTopLng && leftBottomLat < testTargetLat && testTargetLat < leftTopLat {
            marker.position = NMGLatLng(lat: testTargetLat, lng: testTargetLng)
            marker.mapView = nmapFView
        }
        else if testTargetLng < leftBottomLng {
            if testTargetLat < leftBottomLat {
                let getYResult = testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftBottomLng)
                if getYResult < leftBottomLat {
                    marker.position = NMGLatLng(lat: leftBottomLat, lng: testGetXFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftBottomLat))
                    marker.mapView = nmapFView
                } else {
                    marker.position = NMGLatLng(lat: getYResult, lng: leftBottomLng)
                    marker.mapView = nmapFView
                }
            }else if testTargetLat < leftTopLat && leftBottomLat < testTargetLat {
                marker.position = NMGLatLng(lat: testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLng), lng: leftTopLng)
                marker.mapView = nmapFView
            }
            
            
            
            
            
            
            
            
            
            
            else {
                //2
                //좌표가 카메라보다 왼쪽에 있고 위에 있을 때
                let getYResult = testGetYFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLng)
                if getYResult < leftTopLat {
                    marker.position = NMGLatLng(lat: getYResult, lng: leftTopLng)
                    marker.mapView = nmapFView
                } else {
                    marker.position = NMGLatLng(lat: leftTopLat, lng: testGetXFunc(x1: testTargetLng, x2: centerLng, y1: testTargetLat, y2: centerLat, key: leftTopLat))
                    marker.mapView = nmapFView
                }
            }
            
            
            
            
            
            
            
            
            
            
        } else {
            
            if testTargetLat < rightBottomLat {
                let getYResult = getY(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng)
                
                if getYResult < rightBottomLat {
                    marker.position = NMGLatLng(lat: rightBottomLat, lng: getX(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng))
                    marker.mapView = nmapFView
                }else {
                    marker.position = NMGLatLng(lat: getYResult, lng: rightBottomLng)
                    marker.mapView = nmapFView
                }
            }else if testTargetLat < rightTopLat && rightBottomLat < testTargetLat {
                
                marker.position = NMGLatLng(lat: testGetYFunc(x1: centerLng, x2: testTargetLng, y1: centerLat, y2: testTargetLat, key: rightBottomLng), lng: rightBottomLng)
                marker.mapView = nmapFView
            }
            
            else {
                //4
                //좌표가 카메라보다 오른쪽에 있고 위에 있을 때
                let getYResult = getY(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng)
        
                if getYResult < rightTopLat {
                    marker.position = NMGLatLng(lat: getYResult, lng: rightTopLng)
                    marker.mapView = nmapFView
                }else {
                    marker.position = NMGLatLng(lat: rightTopLng, lng: getX(x1: testTargetLat, x2: testTargetLng, y1: centerLat, y2: centerLng))
                    marker.mapView = nmapFView
                }
            }
        }
    }
}
