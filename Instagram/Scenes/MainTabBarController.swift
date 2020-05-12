//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/3/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
            let photoSelectorNavController = UINavigationController(rootViewController: photoSelectorController)
            photoSelectorNavController.modalPresentationStyle = .fullScreen
            present(photoSelectorNavController, animated: true)
            
            return false
        }
        
        return true
    }
    
    func setupViewControllers() {
        
        // Home
        let homeNavController = templateNavController(image: UIImage(named: "home_unselected"), selectedImage: UIImage(named: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // search
        let searchNavController = templateNavController(image: UIImage(named: "search_unselected"), selectedImage: UIImage(named: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Add Photo
        let plusNavController = templateNavController(image: UIImage(named: "plus_unselected"), selectedImage: UIImage(named: "plus_unselected"), rootViewController: UIViewController())
        
        // like
        let likeNavController = templateNavController(image: UIImage(named: "like_unselected"), selectedImage: UIImage(named: "like_selected"), rootViewController: UIViewController())
        
        // User profile
        let userProfileNavController = templateNavController(image: UIImage(named: "profile_unselected"), selectedImage: UIImage(named: "profile_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // add views to tab bar
        tabBar.tintColor = .black
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, userProfileNavController]
        
        // modify tab bar items insets
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    
    func templateNavController(image: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image!
        navController.tabBarItem.selectedImage = selectedImage!
        
        return navController
    }

    
    
    
}
