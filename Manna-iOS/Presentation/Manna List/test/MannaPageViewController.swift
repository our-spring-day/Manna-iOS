//
//  MannaPageViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/07/07.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit

class MannaPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    static let shared = MannaPageViewController(transitionStyle: .scroll,
                                                navigationOrientation: .horizontal,
                                                options: nil)
    
    var pageControl = UIPageControl()
    let VCArr: [UIViewController] = [PeopleAddMannaViewController.shared,
                                     TimeAddMannaViewController.shared,
                                     PlaceAddMannaViewController.shared]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.isPagingEnabled = false
        if let firstVC = VCArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        configurePageControl()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = VCArr.firstIndex(of: viewController), index > 0 else { return nil }
        let previousIndex = index - 1
        return VCArr[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = VCArr.firstIndex(of: viewController), index < (VCArr.count - 1) else { return nil }
        let nextIndex = index + 1
        return VCArr[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = VCArr.firstIndex(of: pageContentViewController)!
    }
    
    func configurePageControl() {
        self.pageControl.do {
            $0.numberOfPages = VCArr.count
            $0.currentPage = 0
            $0.tintColor = UIColor.black
            $0.pageIndicatorTintColor = UIColor.gray
            $0.currentPageIndicatorTintColor = UIColor.black
        }
        
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
}

extension MannaPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}
