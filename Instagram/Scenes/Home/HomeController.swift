//
//  HomeController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/11/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    private let cellIdentifier = "Cell"
    private var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        // Register home post cell
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: SharePhotoController.updateFeedNotificationName, object: nil)
                
        setupNavigationItems()
        
        setupRefreshControl()
        
        fetchAllPosts()
    }

    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    func fetchAllPosts() {
        self.collectionView.refreshControl?.endRefreshing()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        // Fetch my posts
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
        
        // Fetch following posts
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            dictionary.forEach { (key, value) in
                Database.fetchUserWithUid(uid: key) { (user) in
                    self.fetchPostWithUser(user: user)
                }
            }
            
        }) { (error) in
            print("failed to fetch following IDs")
        }
    }
    
    func fetchPostWithUser(user: User) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapShot) in
            guard let dictionaries = snapShot.value as? [String: Any] else {return}
            
            dictionaries.forEach { (key, value) in
                guard let postDictionary = value as? [String: Any] else {return}
                
                var post = Post(user: user, post: postDictionary)
                post.id = key
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.isLiked = true
                    }
                    
                    self.posts.append(post)
                    self.posts.sort { (post1, post2) -> Bool in
                        return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                    }
                    
                    self.collectionView.reloadData()
                    
                }) { (error) in
                    print("failed to fetch post like status", error)
                }
            }
            
        }) { (error) in
            print("Failed to fetch posts ", error)
        }
    }
}

// MARK: HomePostCellDelegate

extension HomeController {
    func didTapComment(post: Post) {
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        var post = posts[indexPath.item]
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        
        let values = [uid: post.isLiked ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, _) in
            if let error = error {
                print("failed to like post", error)
                return
            }
            
            post.isLiked = !post.isLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
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
        
        cell.delegate = self
        
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
        
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

