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
    
    var lat: Double?
    var lng: Double?
    
    let backButton = UIButton()
    let targetImage = UIImageView()
    let pinImage = UIImageView()
    let aiming = UIImageView()
    
    var authState: NMFAuthState!
    var cameraUpdate: NMFCameraUpdate?
    var nmapFView: NMFMapView?
    var task: DispatchWorkItem?
    var markerForCenter: NMFMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createMapView()
        attribute()
        layout()
    }

    //맵뷰(nmapFView)생성함수
    func createMapView() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView?.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat!, lng: lng!)))
        nmapFView?.zoomLevel = 18
        nmapFView!.addCameraDelegate(delegate: self)
        view.addSubview(nmapFView!)
    }
    func attribute() {
        backButton.do {
            $0.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
            $0.addTarget(self, action: #selector(back), for: .touchUpInside)
        }
        aiming.image = #imageLiteral(resourceName: "target")
        pinImage.image = #imageLiteral(resourceName: "marker")
    }
    
    func layout() {
        view.addSubview(backButton)
        view.addSubview(aiming)
        aiming.addSubview(pinImage)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        aiming.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        pinImage.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY).offset(-28)
            $0.width.equalTo(35)
            $0.height.equalTo(50)
        }
    }
    @objc func back() {
        dismiss(animated: true, completion: nil)
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
            
            print(self.nmapFView!.cameraPosition.target.lat)
            print(self.nmapFView!.cameraPosition.target.lng)
            
//            let x = self.nmapFView!.cameraPosition.target.lng
//            let y = self.nmapFView!.cameraPosition.target.lat
            
//            AddressAPI.getAddress(x, y)
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.pinImage.transform = CGAffineTransform(translationX: 0, y: 0)
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
