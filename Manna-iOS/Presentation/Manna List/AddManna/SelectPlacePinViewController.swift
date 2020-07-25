//
//  SelectPlacePinViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/07/16.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import NMapsMap
import SnapKit
import Then
import RxSwift
import RxCocoa

class SelectPlacePinViewController: UIViewController {
    var addressString: String?
    var addressText = UILabel()
    
    let targetImage = UIImageView()
    let pinImage = UIImageView()
    
    var authState: NMFAuthState!
    var cameraUpdate: NMFCameraUpdate?
    var nmapFView: NMFMapView?
    var task: DispatchWorkItem?
    var markerForCenter: NMFMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        
        view.addSubview(targetImage)
        view.addSubview(pinImage)
        
//        createMapView()
        createImageView()
//        createAddressLabel()
    }
    func attribute() {
        
    }
    
    func layout() {
        
    }
    //좌표찍힐라벨(addressText)생성함수
    func createAddressLabel() {
        
    }
    //맵뷰(nmapFView)생성함수
    func createMapView() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView!.addCameraDelegate(delegate: self)
        view.addSubview(nmapFView!)
    }
    //핀(imageView)생성함수
    func createImageView() {
        //하드로 고정해놓았기때문에 후에 화면중앙에 핀의 꼭짓점이 정확히 찍히는 방법 구상해야됨
        let aiming = UIImageView()
        view.addSubview(aiming)
        aiming.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        aiming.image = #imageLiteral(resourceName: "target")

        aiming.addSubview(pinImage)
        pinImage.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY).offset(-30)
            $0.width.equalTo(35)
            $0.height.equalTo(50)
        }
        pinImage.image = #imageLiteral(resourceName: "marker")
        
    }
    
    @objc func go() {
        //        let x = 127.105401
        //        let y = 37.361859
        //        AddressAPI.getAddress(x, y)
        cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5670135, lng: 126.9783740))
        cameraUpdate!.animation = .fly
        cameraUpdate!.animationDuration = 1.5
        nmapFView!.moveCamera(cameraUpdate!)
    }
}
extension SelectPlacePinViewController: NMFMapViewCameraDelegate {
    //카메라의 움직임이끝났을때
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        //1초뒤에 task를 실행
        task = DispatchWorkItem {
            //핀 알파값 원래대로
            self.pinImage.alpha = 1
            //카메라포지션을 저장해줌(보기에편하게)
            _ = self.nmapFView!.cameraPosition
            //카메라포지션의 좌표값을 스트링으로 변환후 addressText 띄우줌
            //            self.addressText.text = String(format: "%f",position.target.lat, position.target.lng)
            //이건 후에 api 쏠때 필요한 코드여서 그냥 남겨둠
            print(self.nmapFView!.cameraPosition.target.lat)
            print(self.nmapFView!.cameraPosition.target.lng)
            
//            let x = self.nmapFView!.cameraPosition.target.lng
//            let y = self.nmapFView!.cameraPosition.target.lat
            
//            AddressAPI.getAddress(x, y)
            
            //애니메이션의 시간은 0.25초 y 10 이동
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.pinImage.transform = CGAffineTransform(translationX: 0, y: 10)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: task!)
    }
    
    //카메라가 움직일때
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        //task를 취소
        task?.cancel()
        //핀 알파값 조정
        pinImage.alpha = 0.5
        //애니메이션의 시간은 0.25초, y -10 이동
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.pinImage.transform = CGAffineTransform(translationX: 0, y: -10)
        })
    }
}
