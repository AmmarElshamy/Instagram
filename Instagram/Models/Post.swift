//
//  Post.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/11/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    let user: User
    let caption: String
    
    init(user: User, post: [String: Any]) {
        self.user = user
        self.imageUrl = post["imageUrl"] as! String
        self.caption = post["caption"] as! String
    }
}