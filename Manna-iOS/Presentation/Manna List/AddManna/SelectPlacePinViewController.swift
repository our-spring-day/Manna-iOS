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
    let disposeBag = DisposeBag()
    
    let viewModel: SelectPlacePinViewModelType
    
    var lat: Double?
    var lng: Double?
    
    let backButton = UIButton()
    let pinImage = UIImageView()
    let aiming = UIImageView()
    
    var authState: NMFAuthState!
    var cameraUpdate: NMFCameraUpdate?
    var nmapFView: NMFMapView?
    var task: DispatchWorkItem?
    var markerForCenter: NMFMarker?
    
    init(viewModel: SelectPlacePinViewModelType = SelectPlacePinViewModel()) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder aDecoder: NSCoder) {
           viewModel = SelectPlacePinViewModel()
           super.init(coder: aDecoder)
       }
    
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
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        task = DispatchWorkItem {
            self.pinImage.alpha = 1
            //카메라포지션을 저장해줌(보기에편하게)
            _ = self.nmapFView!.cameraPosition
            //카메라포지션의 좌표값을 스트링으로 변환후 addressText 띄우줌
            
            print(self.nmapFView!.cameraPosition.target.lng)
//            print(self.nmapFView!.cameraPosition.target.lat)
            
            let lng = Double(self.nmapFView!.cameraPosition.target.lng)
            let lat = Double(self.nmapFView!.cameraPosition.target.lat)
            
            self.viewModel.inputs.longitude.onNext(lng)
            self.viewModel.inputs.latitude.onNext(lat)
        
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.pinImage.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: task!)
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        task?.cancel()
        pinImage.alpha = 0.5
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.pinImage.transform = CGAffineTransform(translationX: 0, y: -10)
        })
    }
}
