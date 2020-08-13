//
//  File.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/21.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class CheckedFriendCell: UICollectionViewCell {
    static  let identifier = "cell"
    
    var profileImage = UIImageView()
    var XImage = UIImageView()
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    func attribute() {
        profileImage.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        XImage.image = UIImage(named: "Xmark")
    }
    
    func layout() {
        self.addSubview(self.profileImage)
        self.addSubview(self.XImage)
        
        self.profileImage.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(0)
        }
        self.XImage.snp.makeConstraints {
            $0.top.equalTo(-5)
            $0.trailing.equalTo(10)
            $0.width.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
