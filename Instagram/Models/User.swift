//
//  File.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/6/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String
    
    init(userDictionary: [String: Any]) {
        self.username = userDictionary["username"] as? String ?? " "
        self.profileImageUrl = userDictionary["profileImageUrl"] as? String ?? ""
    }
}
