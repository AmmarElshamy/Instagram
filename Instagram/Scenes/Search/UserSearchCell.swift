//
//  UserSearchCell.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/12/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else {return}
            userProfileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    private let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, centerX: nil, centerY: centerYAnchor, width: 50, height: 50)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: userProfileImageView.rightAnchor, paddingLeft: 8, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0)
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: usernameLabel.leftAnchor , paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0.5)
    }
}
