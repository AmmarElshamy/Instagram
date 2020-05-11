//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/6/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            
            usernameLabel.text = self.user?.username
        }
    }
    
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postsLabel: UILabel = {
        let label = UILabel()
        let attributerText = NSMutableAttributedString(string: "100\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributerText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributerText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        let attributerText = NSMutableAttributedString(string: "100\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributerText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributerText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        let attributerText = NSMutableAttributedString(string: "100\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributerText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributerText
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
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
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
    
    private let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    private let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
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
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: userStatsView.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: userStatsView.leftAnchor, paddingLeft: 0, right: userStatsView.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 34)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 18, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 12, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 20)
        
        addSubview(bottomToolbar)
        bottomToolbar.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 50)
        
        addSubview(topDividerView)
        topDividerView.anchor(top: bottomToolbar.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0.5)
        
        addSubview(bottomDividerView)
        bottomDividerView.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0.7)
    }
 
}
