//
//  UserSearchController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/12/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let cellIdentifier = "Cell"
    private var users = [User]()
    private var filteredUsers = [User]()

    lazy private var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Enter username"
        bar.delegate = self
        return bar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        // Register home post cell
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        
        setupViews()
        fetchUsers()
    }
    
    func setupViews() {
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, paddingTop: 0, bottom: navBar?.bottomAnchor, paddingBottom: 0, left: navBar?.leftAnchor, paddingLeft: 8, right: navBar?.rightAnchor, paddingRight: 8, centerX: nil, centerY: nil, width: 0, height: 0)
    }
    
    func fetchUsers() {
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaris = snapshot.value as? [String: Any] else {return}
            dictionaris.forEach { (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                guard let userDictionary = value as? [String: Any] else {return}
                let user = User(uid: key, userDictionary: userDictionary)
                self.users.append(user)
            }
            
            self.users.sort { (user1, user2) -> Bool in
                return user1.username.compare(user2.username) == .orderedAscending
            }
            
            self.collectionView.reloadData()
            
        }) { (error) in
            print("failed to fetch users in search screen", error)
        }
    }

}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate

extension UserSearchController {
    
    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    // dequeue reusable cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 66)
    }
    
    // did selected item
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let user = filteredUsers[indexPath.item]
        let userProfile = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfile.user = user
        navigationController?.pushViewController(userProfile, animated: true)
    }
    
}

// MARK: UISearchBarDelegate

extension UserSearchController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = users.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
    }
}
