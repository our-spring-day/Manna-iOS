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
    
    static let shared = SelectPlacePinViewController()
    
    let viewModel: SelectPlacePinViewModelType
    
    var viewState: Bool = true
    var initLat: Double?
    var initLng: Double?
    var lat: Double?
    var lng: Double?
    
    let marker = NMFMarker()
    let stateButton = UIButton()
    let backButton = UIButton()
    let rootView = UIView()
    let addressLable = UILabel()
    let roadAddressLable = UILabel()
    let detailAddress = UITextField()
    let completeBtn = UIButton()
    let pinSelectBtn = UIButton()
    let pinImage = UIImageView()
    let aiming = UIImageView()
    
    var authState: NMFAuthState!
    var cameraUpdate: NMFCameraUpdate?
    var nmapFView: NMFMapView?
    var task: DispatchWorkItem?
    
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
        createMapView()
        attribute()
        layout()
        keyboardAction()
        bind()
    }
    
    func createMapView() {
        nmapFView = NMFMapView(frame: view.frame)
        marker.position = NMGLatLng(lat: initLat!, lng: initLng!)
        marker.mapView = nmapFView
        nmapFView?.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat!, lng: lng!)))
        nmapFView?.zoomLevel = 18
        nmapFView!.addCameraDelegate(delegate: self)
        view.addSubview(nmapFView!)
    }
    
    func attribute() {
        
        aiming.do {
            $0.image = #imageLiteral(resourceName: "target")
            $0.isHidden = true
        }
        pinImage.do {
            $0.image = #imageLiteral(resourceName: "marker")
            $0.isHidden = true
        }
        rootView.backgroundColor = .white
        stateButton.do {
            $0.setImage(#imageLiteral(resourceName: "Image"), for: .normal)
            $0.addTarget(self, action: #selector(changeState), for: .touchUpInside)
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
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor( .white, for: .normal)
        }
        pinSelectBtn.do {
            $0.backgroundColor = .blue
            $0.setTitle("이 위치로 주소 설정", for: .normal)
            $0.setTitleColor( .white, for: .normal)
            $0.isHidden = true
            $0.addTarget(self, action: #selector(pinSelected), for: .touchUpInside)
        }
    }
    
    func layout() {
        view.addSubview(rootView)
        view.addSubview(stateButton)
        rootView.addSubview(roadAddressLable)
        rootView.addSubview(addressLable)
        rootView.addSubview(detailAddress)
        rootView.addSubview(completeBtn)
        rootView.addSubview(pinSelectBtn)
        view.addSubview(aiming)
        aiming.addSubview(pinImage)
        
        
        rootView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(view.frame.height / 4)
        }
        stateButton.snp.makeConstraints {
            $0.bottom.equalTo(rootView.snp.top).offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
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
        pinSelectBtn.snp.makeConstraints {
            $0.top.equalTo(detailAddress.snp.bottom).offset(20)
            $0.centerX.equalTo(rootView.snp.centerX)
            $0.width.equalTo(view.frame.width * 0.7)
            $0.height.equalTo(40)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind() {
        let address = completeBtn.rx.tap
            .map { Address(address: self.addressLable.text!,
                           roadAddress: self.roadAddressLable.text! + " " + self.detailAddress.text!,
                           lng: "\(self.lng!)",
                           lat: "\(self.lat!)") }
        
        Observable.just(address)
            .merge()
            .subscribe(onNext: { [weak self] in
                self?.completePlace(address: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func keyboardAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -255
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    @objc func changeState() {
        marker.hidden = true
        detailAddress.isHidden = true
        completeBtn.isHidden = true
        
        nmapFView?.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat!, lng: lng!)))
        stateButton.isHidden = true
        pinSelectBtn.isHidden = false
        aiming.isHidden = false
        pinImage.isHidden = false
        viewState = false
    }
    @objc func pinSelected() {
        marker.hidden = false
        marker.position = NMGLatLng(lat: self.lat!, lng: self.lng!)
        detailAddress.isHidden = false
        completeBtn.isHidden = false
        
        stateButton.isHidden = false
        pinSelectBtn.isHidden = true
        aiming.isHidden = true
        pinImage.isHidden = true
        viewState = true
    }
    
    func completePlace(address: Address) {
        dismiss(animated: true) { [weak self] in
            AddMannaViewController.shared.scrollView.contentOffset = CGPoint(x: self!.view.frame.width*3 ,y: 0)
            SelectPlaceViewController.shared.dismiss(animated: true, completion: nil)
            SelectPlaceViewController.shared.selectedAddressSubject.onNext(address)
            SelectPlaceViewController.shared.selectedAddressSubject.onCompleted()
        }
    }
}

extension SelectPlacePinViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        if viewState == false {
            task = DispatchWorkItem {
                self.pinImage.alpha = 1
                //카메라포지션을 저장해줌(보기에편하게)
                _ = self.nmapFView!.cameraPosition
                
                let lng = Double(self.nmapFView!.cameraPosition.target.lng)
                let lat = Double(self.nmapFView!.cameraPosition.target.lat)
                
                self.viewModel.inputs.longitude.onNext(lng)
                self.viewModel.inputs.latitude.onNext(lat)
                
                self.viewModel.outputs.address
                    .subscribe(onNext: { value in
                        self.addressLable.text = String(value.address)
                        self.roadAddressLable.text = String(value.roadAddress)
                        self.lat = Double(value.lat)
                        self.lng = Double(value.lng)
                    })
                    .disposed(by: self.disposeBag)
                
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.pinImage.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: task!)
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        task?.cancel()
        pinImage.alpha = 0.5
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.pinImage.transform = CGAffineTransform(translationX: 0, y: -10)
        })
    }
}

