//
//  ViewController.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/05/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    let userListViewController = UserListViewController()
    let mannaListViewController = MannaListViewController()
    let notiListViewController = NotiListViewController()
    let setListViewController = SetListViewController()
    
    enum Tab: Int{
        case userList
        case mannaList
        case notiList
        case setList
    }
    
    let tabBarItems: [Tab: UITabBarItem] = [
        .userList: UITabBarItem(
            title: "친구",
            image: #imageLiteral(resourceName: "userlistimage"),
            selectedImage: #imageLiteral(resourceName: "userlistimage")
        ),
        .mannaList: UITabBarItem(
            title: "만나",
            image: #imageLiteral(resourceName: "mannalistimage"),
            selectedImage: #imageLiteral(resourceName: "mannalistimage")
        ),
        .notiList: UITabBarItem(
            title: "알림",
            image: #imageLiteral(resourceName: "notilistimage"),
            selectedImage: #imageLiteral(resourceName: "notilistimage")
        ),
        .setList: UITabBarItem(
            title: "설정",
            image: #imageLiteral(resourceName: "setlistimage"),
            selectedImage: #imageLiteral(resourceName: "setlistimage")
        )
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    func attribute(){
        userListViewController.tabBarItem = tabBarItems[.userList]
        mannaListViewController.tabBarItem = tabBarItems[.mannaList]
        notiListViewController.tabBarItem = tabBarItems[.notiList]
        setListViewController.tabBarItem = tabBarItems[.setList]
        
        self.viewControllers = [
            UINavigationController(rootViewController: userListViewController),
            UINavigationController(rootViewController: mannaListViewController),
            UINavigationController(rootViewController: notiListViewController),
            UINavigationController(rootViewController: setListViewController)
        ]
    }
//
//    func attribute() {
//        self.do {
//            beerListViewController.tabBarItem = tabBarItems[.beerList]
//            singleBeerViewController.tabBarItem = tabBarItems[.singleBeer]
//            randomBeerViewController.tabBarItem = tabBarItems[.randomBeer]
//            $0.viewControllers = [
//                UINavigationController(rootViewController: beerListViewController),
//                UINavigationController(rootViewController: singleBeerViewController),
//                UINavigationController(rootViewController: randomBeerViewController)
//            ]
//        }
//
//        view.do {
//            $0.backgroundColor = .white
//        }
//    }
    
}
