//
//  FinalAddManna.swift
//  Manna-iOS
//
//  Created by once on 2020/08/05.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class FinalAddManna: UIView {
    
    let finalTimeLabel = UILabel()
    let finalTime = UILabel()
    let finalPlaceLabel = UILabel()
    let finalPlace = UILabel()
    let finalPeopleLabel = UILabel()
    var finalPeople: UICollectionView!
    let layoutValue = UICollectionViewFlowLayout()
//    var baseCollectionView: UICollectionView!
//    let layoutValue: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let completeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func attribute() {
        self.backgroundColor = .white
        finalTimeLabel.do {
            $0.text = "시간 : "
            $0.textColor = .black
        }
        finalTime.do {
            $0.textColor = .black
        }
        finalPlaceLabel.do {
            $0.text = "장소 : "
            $0.textColor = .black
        }
        finalPlace.do {
            $0.textColor = .black
        }
        finalPeopleLabel.do {
            $0.text = "참여 인원"
            $0.textColor = .black
        }
        layoutValue.do {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
            $0.itemSize = CGSize(width: 50, height: 50)
        }
        finalPeople = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutValue)
        finalPeople.do {
//            $0.collectionViewLayout = layoutValue
            $0.backgroundColor = .white
            $0.register(CheckedFriendCell.self, forCellWithReuseIdentifier: CheckedFriendCell.identifier)
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
        completeButton.do {
            $0.setTitle("약속추가!!", for: .normal)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func layout() {
        addSubview(finalTimeLabel)
        addSubview(finalTime)
        addSubview(finalPlaceLabel)
        addSubview(finalPlace)
        addSubview(completeButton)
        addSubview(finalPeopleLabel)
        addSubview(finalPeople)
        
        finalTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(40)
        }
        finalTime.snp.makeConstraints {
            $0.top.equalTo(finalTimeLabel)
            $0.leading.equalTo(finalTimeLabel.snp.trailing).offset(20)
        }
        finalPlaceLabel.snp.makeConstraints {
            $0.top.equalTo(finalTimeLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(40)
        }
        finalPlace.snp.makeConstraints {
            $0.top.equalTo(finalPlaceLabel)
            $0.leading.equalTo(finalPlaceLabel.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        finalPeopleLabel.snp.makeConstraints {
            $0.top.equalTo(finalPlace.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(40)
        }
        finalPeople.snp.makeConstraints {
            $0.top.equalTo(finalPeopleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-70)
        }
        completeButton.snp.makeConstraints {
            $0.top.equalTo(finalPeople.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
    }
}
