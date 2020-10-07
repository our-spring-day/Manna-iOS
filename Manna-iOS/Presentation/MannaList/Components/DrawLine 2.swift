//
//  DrawLine.swift
//  Manna-iOS
//
//  Created by once on 2020/07/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class DrawLine: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.do {
            $0.move(to: CGPoint(x: 40, y: 140))
            $0.addLine(to: CGPoint(x: 315, y: 140))
            $0.close()
            $0.stroke()
        }
        
    }
}
