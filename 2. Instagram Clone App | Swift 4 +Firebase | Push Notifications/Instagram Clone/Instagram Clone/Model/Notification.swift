//
//  Notification.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 02/09/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import Foundation
import Firebase

class Notification {
    
    enum NotificationType: Int, Printable {
        case like
        case comment
        case follow
        
        var description: String { // when we call notificationType.description it will give description properly, if it is .like then return " liked your post." and so on
            switch self {
            case .like: return " liked your post"
            case .comment: return " commented on your post"
            case .follow: return " started following you"
            }
        }
        init(index: Int) {
            switch index {
            case 0: self = .like
            case 1: self = .comment
            case 2: self = .follow
            default: self = .like
            }
        }
    }
    var user: User!
    var post: Post? // notification is not always linked to a post
    var creationDate: Date!
    var currentUid: String?
    var postId: String? // it is nil when we follow an user
    var didCheck: Bool!
    var type: Int!
    var notificationType: NotificationType!

    // each notification is from certain user
    init(user: User, post: Post? = nil, dictionary: Dictionary<String, AnyObject>) {
        self.user = user
        self.post = post
        if let checked = dictionary["checked"] as? Int {
            if checked == 0 {
                self.didCheck = false
            } else {
                self.didCheck = true
            }
        }
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        if let postId = dictionary["postId"] as? String {
            self.postId = postId
        }
        if let type = dictionary["type"] as? Int {
            self.notificationType = NotificationType(index: type) // getting a value from database and then initializing notification type, enum, with this value
        }
        if let currentUid = dictionary["uid"] as? String {
            self.currentUid = currentUid
        }
        
    }
}
