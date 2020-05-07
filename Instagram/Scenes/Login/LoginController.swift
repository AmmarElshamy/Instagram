//
//  LoginController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/7/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account?  Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchDown)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.isNavigationBarHidden = true
        
        setupViews()

    }
    
    func setupViews() {
        
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 20, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 50)
        
    }
    
    @objc func signUpButtonPressed() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
}
