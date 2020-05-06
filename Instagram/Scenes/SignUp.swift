//
//  SignUp.swift
//  Instagram
//
//  Created by Ammar Elshamy on 4/30/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(plusPhotoButtonPressed), for: .touchDown)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchDown)
        button.isEnabled = false
        return button
    }()
    
    private lazy var inputFieldsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField, self.usernameTextField, self.passwordTextField, self.signUpButton])
        
        // Enable Signup button when all input fields are filled
        for index in 0..<stackView.arrangedSubviews.count - 1 {
            let inputField = stackView.arrangedSubviews[index] as! UITextField
            inputField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        }
        
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    func setupViews() {
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, paddingTop: 40, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, centerX: view.centerXAnchor, centerY: nil, width: 140, height: 140)
        
        view.addSubview(inputFieldsStack)
        inputFieldsStack.anchor(top: plusPhotoButton.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 40, right: view.rightAnchor, paddingRight: 40, centerX: nil, centerY: nil, width: 0, height: 200)
        
    }
    
    @objc func signUpButtonPressed() {
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let username = usernameTextField.text, username.count > 0 else {return}
        guard let password = passwordTextField.text, password.count >= 6 else {return}
        guard let profileImage = self.plusPhotoButton.imageView?.image else {return}
        guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
        
      
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            
            if let error = error {
                print("Failed to create user", error)
                return
            }
            
            print("Successfully created user:", data?.user.uid ?? "")
            
            
            
            // Save username into DB
            guard let uid = data?.user.uid else {return}
            var userValues = ["username": username]
            var values = [uid: userValues]
            
            Database.database().reference().child("users").updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("Failed to save username into DB", error)
                    return
                }
                
                print("Successfully saved username to DB")
            }
            
            
            // Save profile image into storage and DB
            let fileName = NSUUID().uuidString
            let storage = Storage.storage().reference().child("profile_image").child(fileName)
            
            storage.putData(uploadData, metadata: nil) { (metadata, error) in
                
                if let error = error {
                    print("Failed to upload profile image", error)
                    return
                }
                
                storage.downloadURL { (url, error) in
                    if let error = error {
                        print("Failed to get profile image url", error)
                        return
                    }
                    
                    guard let profileImageUrl = url?.absoluteString else {return}
                    userValues["profileImageUrl"] = profileImageUrl
                    values[uid] = userValues
                    
                    Database.database().reference().child("users").updateChildValues(values) { (error, ref) in
                        if let error = error {
                            print("Failed to save user image url into DB", error)
                            return
                        }
                        
                        print("Successfully saved user image url to DB")
                    }
                        
                }
            }
            
        }
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    @objc func plusPhotoButtonPressed() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
            plusPhotoButton.layer.masksToBounds = true
            plusPhotoButton.layer.borderColor = UIColor.black.cgColor
            plusPhotoButton.layer.borderWidth = 3
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }

}

