//
//  UserProfileController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/3/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellIdentifier = "Cell"
    private let headerIdentifier = "Header"
    private var user: User?
    private var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Register header
        self.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        //Register imageCell
        self.collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.backgroundColor = .white
        
        setupLogOutButton()

        fetchUser()
    }
    
    func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
                
            } catch let error{
                print("Failed to sign out", error)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true)
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
            self.fetchOrderedPosts()
        }
        
    }
    
    func fetchOrderedPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let user = self.user else {return}

        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapShot) in
            guard let dictionary = snapShot.value as? [String: Any] else {return}
                        
            let post = Post(user: user, post: dictionary)
            self.posts.insert(post, at: 0)
            self.collectionView.reloadData()

        }) { (error) in
            print("Failed to fetch posts ", error)
        }
    }
    
    
}



// MARK: UICollectionViewDataSource

extension UserProfileController {
    
    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // dequeue reusable cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UserProfileCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    // vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width )
    }
    
    // header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.postsNumber = self.posts.count
            
         return header
    }
    
    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
}
