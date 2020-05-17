//
//  Comment.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/16/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import Foundation

struct Comment {
    let user: User
    let id: String
    let text: String
    let creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user 
        self.id = dictionary["id"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        
        let timeSince1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: timeSince1970)
    }
}
