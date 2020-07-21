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

class BottomMenuCell: UICollectionViewCell {
    static  let identifier = "cell"
    
    var bottomImageView: UIImageView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bottomImageView = UIImageView()
        self.bottomImageView?.contentMode = .scaleAspectFill
        
        self.addSubview(self.bottomImageView!)
        
        self.bottomImageView?.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
