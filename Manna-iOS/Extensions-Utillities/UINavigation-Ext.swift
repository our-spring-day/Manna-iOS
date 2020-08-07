//
//  UINavigation-Ext.swift
//  Manna-iOS
//
//  Created by once on 2020/08/07.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion:@escaping (() -> Void)) {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
     
    func popViewController(animated: Bool, completion:@escaping (() -> Void)) -> UIViewController? {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        let poppedViewController = self.popViewController(animated: animated)
        CATransaction.commit()
        return poppedViewController
    }
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
    func popToViewController(ofClass: AnyClass, animated: Bool = true, completion: (() -> Void)?) {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        if let viewController = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(viewController, animated: animated)
        }
        CATransaction.commit()
    }
}
