//
//  User.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 23/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//
import UIKit
import Firebase

class User {
    var username: String!
    var name: String!
    var profileImageUrl: String!
    var uid: String!
    var isFollowed = false
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        self.uid = uid
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let profileImageUrl = dictionary["profileImageURL"] as? String {
            self.profileImageUrl = profileImageUrl
        }
    }
    
    // similarly in Post class there is adjustLikes() func
    func follow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        guard let uid = uid else { return }
        isFollowed = true
        Database.database().reference().child("user-following").child(currentUid).updateChildValues([uid: 1]) // add followed user to user-following structure
        Database.database().reference().child("user-followers").child(uid).updateChildValues([currentUid: 1]) // add current user to followed user-followers structure
        
        // upload follow notification to server
        uploadFollowNotificationToServer()
        
        // add followers user posts to user-feed
        Database.database().reference().child("user-posts").child(self.uid).observe(.childAdded) { (dataSnapshot) in
            let postId = dataSnapshot.key
            Database.database().reference().child("user-feed").child(currentUid).updateChildValues([postId: 1])
            
        }
    }
    
    func unfollow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        guard let uid = uid else { return }
        isFollowed = false
        Database.database().reference().child("user-following").child(currentUid).child(uid).removeValue()
        Database.database().reference().child("user-followers")
        
        // remove unfollowed user posts from current user-feed
        Database.database().reference().child("user-posts").child(self.uid).observe(.childAdded) { (dataSnapshot) in
            let postId = dataSnapshot.key
            Database.database().reference().child("user-feed").child(currentUid).child(postId).removeValue()
            
        }
    }
    
    func checkIfUserIsFollowed(completion: @escaping(Bool) ->()) { // completion block is used when we want to perform one action only after another ended; so when we are waiting for API call back about whether the user is followed or not
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("user-following").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChild(self.uid) {
                self.isFollowed = true
                completion(true)
            } else {
                self.isFollowed = false
                completion(false)
            }
        }
    }
    
    func uploadFollowNotificationToServer() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        guard let uid = self.uid else { fatalError() }
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // notification values
        let values = ["checked": 0,
                      "creationDate": creationDate,
                      "currentUid": currentUid,
                      "type": FOLLOW_INT_VALUE] as [String : Any]
        
        // upload comment notification to server
        if uid != currentUid {
            Database.database().reference().child("notifications").child(uid).childByAutoId().updateChildValues(values)
        }
    }
    
    
}
