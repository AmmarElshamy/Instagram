//
//  File.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/6/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, userDictionary: [String: Any]) {
        self.uid = uid
        self.username = userDictionary["username"] as? String ?? " "
        self.profileImageUrl = userDictionary["profileImageUrl"] as? String ?? ""
    }
}
