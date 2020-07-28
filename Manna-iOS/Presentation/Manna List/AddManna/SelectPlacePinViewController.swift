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

class SelectPlacePinViewController: UIViewController, UITextFieldDelegate {
    let disposeBag = DisposeBag()
    
    let viewModel: SelectPlacePinViewModelType
    
    var lat: Double?
    var lng: Double?
    
    let backButton = UIButton()
    let rootView = UIView()
    let addressLable = UILabel()
    let roadAddressLable = UILabel()
    let detailAddress = UITextField()
    let completeBtn = UIButton()
    let pinImage = UIImageView()
    let aiming = UIImageView()
    
    var authState: NMFAuthState!
    var cameraUpdate: NMFCameraUpdate?
    var nmapFView: NMFMapView?
    var task: DispatchWorkItem?
    var markerForCenter: NMFMarker?
    
    // MARK: - Life cycle
    
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
        detailAddress.delegate = self
        createMapView()
        attribute()
        layout()
        keyboardAction()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
    }
    
    func createMapView() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView?.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat!, lng: lng!)))
        nmapFView?.zoomLevel = 18
        nmapFView!.addCameraDelegate(delegate: self)
        view.addSubview(nmapFView!)
    }
    func attribute() {
        aiming.image = #imageLiteral(resourceName: "target")
        pinImage.image = #imageLiteral(resourceName: "marker")
        rootView.backgroundColor = .white
        
        backButton.do {
            $0.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
            $0.addTarget(self, action: #selector(back), for: .touchUpInside)
        }
        roadAddressLable.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: CGFloat(20))
        }
        addressLable.do {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: CGFloat(15))
        }
        detailAddress.do {
            $0.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            $0.layer.borderWidth = 1.0
            $0.placeholder = "상세주소를 입력하세요(건물명, 동/호수 등)"
        }
        completeBtn.do {
            $0.backgroundColor = .blue
            $0.setTitle("이 위치로 주소 설정", for: .normal)
            $0.setTitleColor( .white, for: .normal)
        }
    }
    
    func layout() {
        view.addSubview(rootView)
        rootView.addSubview(roadAddressLable)
        rootView.addSubview(addressLable)
        rootView.addSubview(detailAddress)
        rootView.addSubview(completeBtn)
        view.addSubview(backButton)
        view.addSubview(aiming)
        aiming.addSubview(pinImage)
        
        rootView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(view.frame.height / 4)
        }
        roadAddressLable.snp.makeConstraints {
            $0.top.equalTo(rootView.snp.top).offset(20)
            $0.leading.equalTo(rootView.snp.leading).offset(20)
        }
        addressLable.snp.makeConstraints {
            $0.top.equalTo(roadAddressLable.snp.bottom).offset(15)
            $0.leading.equalTo(roadAddressLable)
        }
        detailAddress.snp.makeConstraints {
            $0.top.equalTo(addressLable.snp.bottom).offset(20)
            $0.centerX.equalTo(rootView.snp.centerX)
            $0.width.equalTo(view.frame.width * 0.9)
            $0.height.equalTo(40)
        }
        completeBtn.snp.makeConstraints {
            $0.top.equalTo(detailAddress.snp.bottom).offset(20)
            $0.centerX.equalTo(rootView.snp.centerX)
            $0.width.equalTo(view.frame.width * 0.7)
            $0.height.equalTo(40)
        }
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
    
    func keyboardAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -255 // Move view 150 points upward
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
}





extension SelectPlacePinViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        task = DispatchWorkItem {
            self.pinImage.alpha = 1
            //카메라포지션을 저장해줌(보기에편하게)
            _ = self.nmapFView!.cameraPosition
            //카메라포지션의 좌표값을 스트링으로 변환후 addressText 띄우줌
            
            let lng = Double(self.nmapFView!.cameraPosition.target.lng)
            let lat = Double(self.nmapFView!.cameraPosition.target.lat)
            
            self.viewModel.inputs.longitude.onNext(lng)
            self.viewModel.inputs.latitude.onNext(lat)
            
            self.viewModel.outputs.address
                .subscribe(onNext: { value in
                    self.addressLable.text = String(value.address)
                    self.roadAddressLable.text = String(value.roadAddress)
                })
                //                .bind(to: self.addressLable.rx.text)
                .disposed(by: self.disposeBag)
            
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
