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
            print("No User")
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
        //view1.navigationItem.title = "Profile"
        let nav1 = UINavigationController(rootViewController: view1)
        nav1.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 1)
        let view2 = PhotoCollectionViewController(collectionViewLayout: layout)
        let nav2 = UINavigationController(rootViewController: view2)
        nav2.tabBarItem = UITabBarItem(title: "Photo", image: nil, tag: 2)
        let view3 = FeedController(collectionViewLayout: layout)
        let nav3 = UINavigationController(rootViewController: view3)
        nav3.tabBarItem = UITabBarItem(title: "Feed", image: nil, tag: 3)
        viewControllers = [nav1,nav2,nav3]
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 1 {
            let layout = UICollectionViewFlowLayout()
            let photoview = PhotoCollectionViewController(collectionViewLayout: layout)
            let nav = UINavigationController(rootViewController: photoview)
            self.present(nav, animated: true, completion: nil)
            return false
        }
        return true
    }
}
