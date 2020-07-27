//
//  File.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/07/21.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class CheckedFriendCell: UICollectionViewCell {
    static  let identifier = "cell"
    
    var bottomImageView: UIImageView?
    var testImageView: UIImageView?
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bottomImageView = UIImageView()
        bottomImageView?.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        self.testImageView = UIImageView()
//        self.testImageView?.contentMode = .scaleAspectFill
        
        self.addSubview(self.bottomImageView!)
        self.addSubview(self.testImageView!)
        
        testImageView?.image = UIImage(named: "Xmark")
        
        self.bottomImageView?.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(0)
        }
        self.testImageView?.snp.makeConstraints {
//            make.leading.top.trailing.bottom.equalTo(30)
            $0.top.equalTo(-5)
            $0.trailing.equalTo(10)
            $0.width.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
