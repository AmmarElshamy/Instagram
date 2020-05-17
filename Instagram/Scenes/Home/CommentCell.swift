//
//  CommentCell.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/16/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
        
    var comment: Comment? {
        didSet {
            guard let comment = self.comment else {return}
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            userProfileImageView.loadImage(urlString: comment.user.profileImageUrl)
            textView.attributedText = attributedText
            
        }
    }
    
    private let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: topAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: 40, height: 40)
        
        addSubview(textView)
        textView.anchor(top: topAnchor, paddingTop: 4, bottom: bottomAnchor, paddingBottom: 4, left: userProfileImageView.rightAnchor, paddingLeft: 4, right: rightAnchor, paddingRight: 4, centerX: nil, centerY: nil, width: 0, height: 0)
    }
}
