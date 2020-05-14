//
//  HomePostCell.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/11/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: postImageUrl)
            
            guard let userProfileImageUrl = post?.user.profileImageUrl else {return}
            userProfileImageView.loadImage(urlString: userProfileImageUrl)
            
            guard let username = post?.user.username else {return}
            usernameLabel.text = username
            
            setupAttributedCaption(post: post)
        }
    }
    
    private let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "options")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var actionButtonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.likeButton, self.commentButton, self.sendMessageButton])
        stackView.distribution = .equalSpacing
        stackView.tintColor = .black
        return stackView
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
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
        userProfileImageView.anchor(top: topAnchor, paddingTop:  8, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: 40, height: 40)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, left: userProfileImageView.rightAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 50, centerX: nil, centerY: nil, width: 0, height: 40)
        
        addSubview(optionsButton)
        optionsButton.anchor(top: usernameLabel.centerYAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 8, centerX: nil, centerY: nil, width: 20, height: 6)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1).isActive = true
        
        addSubview(actionButtonsStack)
        actionButtonsStack.anchor(top: photoImageView.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: 120, height: 50)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 40, height: 50)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: actionButtonsStack.bottomAnchor, paddingTop: 4, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 8, centerX: nil, centerY: nil, width: 0, height: 0)
    }
    
        func setupAttributedCaption(post: Post?) {
        
            guard let username = post?.user.username else {return}
            guard let caption = post?.caption else {return}
            guard let creationDate = post?.creationDate else {return}
        
        let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: caption, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
            attributedText.append(NSAttributedString(string: "\(creationDate.timeAgo())", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    }

    
}
