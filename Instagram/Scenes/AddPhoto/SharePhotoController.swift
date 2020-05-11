//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/11/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            imageView.image = self.selectedImage
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        setupNavigationButtons()
        
        setupViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleShare() {
        guard let image = selectedImage else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let fileName = NSUUID().uuidString
        let storage = Storage.storage().reference().child("posts").child(fileName)
        
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload image ", error)
                return
            }
            
            storage.downloadURL { (url, error) in
                if let error = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("failed to get image url", error)
                    return
                }
                
                guard let imageUrl = url?.absoluteString else {return}
                print("successfully uploaded the image ", imageUrl)
                
                self.saveToDatabase(withImageUrl: imageUrl)
                
            }
        }
    }
    
    func saveToDatabase(withImageUrl url: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let postImage = self.selectedImage else {return}
        guard let caption = textView.text else {return}
        
        let userPostsRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostsRef.childByAutoId()
        
        let values = ["imageUrl": url, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "date": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("failed to save post to db", error)
                return
            }
            
            print("sucessfully saved post to db")
            self.dismiss(animated: true)
        }
    }
   
    func setupViews() {
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, paddingTop: 8, bottom: containerView.bottomAnchor, paddingBottom: 8, left: containerView.leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, paddingTop: 0, bottom: containerView.bottomAnchor, paddingBottom: 0, left: imageView.rightAnchor, paddingLeft: 4, right: containerView.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0)
    }
}
