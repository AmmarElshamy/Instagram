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
    
    init(post: [String: Any]) {
        imageUrl = post["imageUrl"] as! String
    }
}
