//
//  HomeController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/11/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellIdentifier = "Cell"
    private var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        // Register home post cell
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        setupNavigationItems()
        
        fetchPosts()
    }

    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
    }
    
    func fetchPostWithUser(user: User) {
    
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observe(.value, with: { (snapShot) in
            guard let dictionaries = snapShot.value as? [String: Any] else {return}
            
            
            dictionaries.forEach { (key, value) in
                guard let postDictionary = value as? [String: Any] else {return}
                
                let post = Post(user: user, post: postDictionary)
                self.posts.insert(post, at: 0)
            }
            
            self.collectionView.reloadData()

        }) { (error) in
            print("Failed to fetch posts ", error)
        }
    }

}

// MARK: UICollectionViewDataSource

extension HomeController {
    
    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // dequeue reusable cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        return cell
    }
    
    // horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = 56 + view.frame.width + 50 + 70
        return CGSize(width: width, height: height)
    }
    
}

