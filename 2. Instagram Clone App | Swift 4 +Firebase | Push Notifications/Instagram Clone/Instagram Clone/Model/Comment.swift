//
//  Comment.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 19/08/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    var uid: String!
    var commentText: String!
    var creationDate: Date!
    var user: User?
    
    init(user: User, dictionary: Dictionary<String, AnyObject>) {
           
        self.user = user
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        }
        if let commentText = dictionary["commentText"] as? String {
            self.commentText = commentText
        }
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
}
