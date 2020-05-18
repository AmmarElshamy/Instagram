//
//  CommentController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/14/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellIdentifier = "Cell"
    var post: Post?
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        navigationItem.title = "Comments"
                
        // Register cell
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        return view
    }()
    
    private let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write a Comment"
        return textField
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        get {
            setupInputAccessoryView()
            return containerView
        }
    }
    
    func setupInputAccessoryView() {
        
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: containerView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: containerView.leftAnchor, paddingLeft: 0, right: containerView.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0.5)
        
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, paddingTop: 4, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 4, left: nil, paddingLeft: 0, right: containerView.rightAnchor, paddingRight: 12, centerX: nil, centerY: nil, width: 50, height: 0)
        
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, paddingTop: 4, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 4, left: containerView.leftAnchor, paddingLeft: 12, right: submitButton.leftAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0)
    }
    
    @objc func handleSubmit() {
                
        if commentTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            commentTextField.text = ""
            return
        }

        guard let postId = self.post?.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        submitButton.isEnabled = false
        
        let values = ["text": commentTextField.text!, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to save comment", error)
                self.submitButton.isEnabled = true
                return
            }
            self.commentTextField.text = ""
            self.submitButton.isEnabled = true
        }
    }
    
    func fetchComments() {
        guard let postId = post?.id else {return}
        
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            Database.fetchUserWithUid(uid: uid) { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                
                self.comments.sort { (comment1, comment2) -> Bool in
                    return comment1.creationDate.compare(comment2.creationDate) == .orderedDescending
                }
                
                self.collectionView.reloadData()
            }
            
            
        }) { (error) in
            print("failed to fetch comments")
        }
    }
}

// MARK: UICollectionViewDataSource

extension CommentController {
    
    // number of comments
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    // dequeue reusable cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CommentCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    // horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 56)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(8 + 40 + 8, estimatedSize.height)
        
        return CGSize(width: view.frame.width, height: height)
    }
    
}
