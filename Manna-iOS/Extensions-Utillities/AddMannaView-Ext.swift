//
//  UIView-Ext.swift
//  Manna-iOS
//
//  Created by once on 2020/06/25.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

extension AddMannaViewController {
    func alert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func viewFlag(_ view: UIView, _ flag: Int) {
        
    }
}
