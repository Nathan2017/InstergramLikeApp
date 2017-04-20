//
//  MainTabController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/17/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class MainTabController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if FIRAuth.auth()?.currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                self.present(nav, animated: true, completion: nil)
                
            }
            
            return
            
        }
        setupview()
        
    }
    func setupview(){
        let layout = UICollectionViewFlowLayout()
        let view1 = ProfileViewController(collectionViewLayout: layout)
        let nav1 = UINavigationController(rootViewController: view1)
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile"), tag: 1)
        let layout2 = UICollectionViewFlowLayout()
        let view2 = PhotoCollectionViewController(collectionViewLayout: layout2)
        let nav2 = UINavigationController(rootViewController: view2)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "photo"), tag: 2)
        let layout3 = UICollectionViewFlowLayout()
        let view3 = FeedController(collectionViewLayout: layout3)
        let nav3 = UINavigationController(rootViewController: view3)
        
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "news"), tag: 3)
        let layout4 = UICollectionViewFlowLayout()
        let view4 = SearchController(collectionViewLayout: layout4)
        let nav4 = UINavigationController(rootViewController: view4)
        
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "search"), tag: 4)
        UITabBar.appearance().tintColor = UIColor.black
        viewControllers = [nav3,nav4,nav2,nav1]
        guard let tabbaritem = tabBar.items else {return}
        for item in tabbaritem {
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoview = PhotoCollectionViewController(collectionViewLayout: layout)
            let nav = UINavigationController(rootViewController: photoview)
            self.present(nav, animated: true, completion: nil)
            return false
        }
        return true
    }
}
