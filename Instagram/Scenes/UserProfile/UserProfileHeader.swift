//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/6/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToGridView()
    func didChangeToListView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            
            usernameLabel.text = self.user?.username
            
            // check current user profile or not
            if user?.uid != Auth.auth().currentUser?.uid {
                setupFollowButton()
            } else {
                editProfileOrFollowButton.setTitle("Edit Profile", for: .normal)
            }
        }
    }
    
    var postsNumber: Int = 0 {
        didSet {
            let attributerText = NSMutableAttributedString(string: "\(self.postsNumber)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributerText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            postsLabel.attributedText = attributerText
        }
    }
    
    var followersNumber: UInt = 0 {
        didSet {
            let attributerText = NSMutableAttributedString(string: "\(self.followersNumber)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributerText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            followersLabel.attributedText = attributerText
        }
    }
    
    var followingNumber: UInt = 0 {
        didSet {
            let attributerText = NSMutableAttributedString(string: "\(self.followingNumber)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributerText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            followingLabel.attributedText = attributerText
        }
    }
    
    
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var userStatsView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.postsLabel, self.followersLabel, self.followingLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let editProfileOrFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    private lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    private lazy var bottomToolbar: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.gridButton, self.listButton, self.bookmarkButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    //bottomToolbar borders
    private let topDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private let bottomDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 12, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: 80, height: 80)
        
        addSubview(userStatsView)
        userStatsView.anchor(top: topAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, left: profileImageView.rightAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: 12, centerX: nil, centerY: nil, width: 0, height: 35)
        
        addSubview(editProfileOrFollowButton)
        editProfileOrFollowButton.anchor(top: userStatsView.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: userStatsView.leftAnchor, paddingLeft: 0, right: userStatsView.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 34)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 18, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 12, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 20)
        
        addSubview(bottomToolbar)
        bottomToolbar.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 50)
        
        addSubview(topDividerView)
        topDividerView.anchor(top: bottomToolbar.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0.5)
        
        addSubview(bottomDividerView)
        bottomDividerView.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0.7)
    }
    
    func setupFollowButton() {
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userID = user?.uid else {return}
        
        // Check if following
        Database.database().reference().child("following").child(loggedInUserId).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let following = snapshot.value as? Int, following == 1 {
                self.setupUnfollowStyle()
            } else {
                self.setupFollowStyle()
            }
            
        }) { (error) in
            print("failed to check if following", error)
        }
        
    }
    
    func setupFollowStyle() {
        self.editProfileOrFollowButton.setTitle("Follow", for: .normal)
        self.editProfileOrFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileOrFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileOrFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.editProfileOrFollowButton.addTarget(self, action: #selector(self.handleFollow), for: .touchUpInside)
    }
    
    func setupUnfollowStyle() {
        self.editProfileOrFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileOrFollowButton.backgroundColor = .white
        self.editProfileOrFollowButton.setTitleColor(.black, for: .normal)
        self.editProfileOrFollowButton.layer.borderColor = UIColor.lightGray.cgColor
        self.editProfileOrFollowButton.backgroundColor = .white
        self.editProfileOrFollowButton.addTarget(self, action: #selector(self.handleUnfollow), for: .touchUpInside)
    }
    
    @objc func handleFollow() {
        editProfileOrFollowButton.isEnabled = false
        
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userID = user?.uid else {return}
        
        // add to following
        var ref = Database.database().reference().child("following").child(loggedInUserId)
        var values = [userID: 1]
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("failed to follow user", error)
                self.editProfileOrFollowButton.isEnabled = true
            } else {
                print("Successfully follow user", self.user?.username ?? "")
                self.editProfileOrFollowButton.removeTarget(self, action: #selector(self.handleFollow), for: .touchUpInside)
                self.setupUnfollowStyle()
                self.editProfileOrFollowButton.isEnabled = true
            }
        }
        
        // add to followers
        ref = Database.database().reference().child("followers").child(userID)
        values = [loggedInUserId: 1]
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("failed to follow user", error)
                self.editProfileOrFollowButton.isEnabled = true
            } else {
                print("Successfully follow user", self.user?.username ?? "")
                self.editProfileOrFollowButton.removeTarget(self, action: #selector(self.handleFollow), for: .touchUpInside)
                self.setupUnfollowStyle()
                self.editProfileOrFollowButton.isEnabled = true
            }
        }
    }
    
    @objc func handleUnfollow() {
        editProfileOrFollowButton.isEnabled = false
        
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userID = user?.uid else {return}
        
        // remove from following
        Database.database().reference().child("following").child(loggedInUserId).child(userID).removeValue { (error, ref) in
            if let error = error {
                print("failed to Unfollow user", error)
                self.editProfileOrFollowButton.isEnabled = true
            } else {
                print("Successfully Unfollow user", self.user?.username ?? "")
                self.editProfileOrFollowButton.removeTarget(self, action: #selector(self.handleUnfollow), for: .touchUpInside)
                self.setupFollowStyle()
                self.editProfileOrFollowButton.isEnabled = true
            }
        }
        
        // remove from followers
        Database.database().reference().child("followers").child(userID).child(loggedInUserId).removeValue { (error, ref) in
            if let error = error {
                print("failed to Unfollow user", error)
                self.editProfileOrFollowButton.isEnabled = true
            } else {
                print("Successfully Unfollow user", self.user?.username ?? "")
                self.editProfileOrFollowButton.removeTarget(self, action: #selector(self.handleUnfollow), for: .touchUpInside)
                self.setupFollowStyle()
                self.editProfileOrFollowButton.isEnabled = true
            }
        }
    }
    
    @objc func handleChangeToGridView() {
        gridButton.tintColor = .customeBlue
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    @objc func handleChangeToListView() {
        listButton.tintColor = .customeBlue
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
}
