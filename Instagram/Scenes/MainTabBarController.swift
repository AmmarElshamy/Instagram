//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/3/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if not logged in
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
            return
        }
        
        setupViewControllers()
        
    }
    
    
    func setupViewControllers() {
        let userProfilelayout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: userProfilelayout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
    

    
}
