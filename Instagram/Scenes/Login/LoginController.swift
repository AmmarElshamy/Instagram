//
//  LoginController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/7/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    private let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchDown)
        button.isEnabled = false
        return button
    }()
    
    private lazy var inputFieldsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField, self.loginButton])
        
        // Enable Login button when all input fields are filled
        for index in 0..<stackView.arrangedSubviews.count - 1 {
            let inputField = stackView.arrangedSubviews[index] as! UITextField
            inputField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        }
        
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchDown)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.isNavigationBarHidden = true
        
        setupViews()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupViews() {
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 150)
        
        logoContainerView.addSubview(logoImageView)
        logoImageView.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, centerX: logoContainerView.centerXAnchor, centerY: logoContainerView.centerYAnchor, width: 200, height: 50)
        
        view.addSubview(inputFieldsStack)
        inputFieldsStack.anchor(top: logoContainerView.bottomAnchor, paddingTop: 40, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 40, right: view.rightAnchor, paddingRight: 40, centerX: nil, centerY: nil, width: 0, height: 180)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 20, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 50)
        
    }
    
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    @objc func loginButtonPressed() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("Failed to sign in with this email and password", error)
                return
            }
            
            print("Successfully logged back in with user: ", data?.user.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            
            mainTabBarController.setupViewControllers()
            
            self.dismiss(animated: true)
        }
    }
    
    @objc func handleShowSignUp() {
          let signUpController = SignUpController()
          navigationController?.pushViewController(signUpController, animated: true)
      }
    
}
