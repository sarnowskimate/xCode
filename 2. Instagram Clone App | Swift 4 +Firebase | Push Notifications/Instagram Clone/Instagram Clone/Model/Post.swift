//
//  Post.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 12/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import Foundation
import Firebase

class Post {
    var caption: String!
    var likes: Int! // likes are updating in completion block so it can't be updated correctly here, this value from completion block cannot escape, therefore we need to make @escaping
    var postImageUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    var postId: String!
    var user: User?
    var didLike = false
    
    init(postId: String!, user: User, dictionary: Dictionary<String, AnyObject>) {
        self.postId = postId
        
        self.user = user
        
        // as? optional downcasting from AnyObject to specific type of data
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
        }
        if let postImageUrl = dictionary["postImageUrl"] as? String {
            self.postImageUrl = postImageUrl
        }
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    func adjustLikes(addLike: Bool, completion: @escaping(Int) -> ()) { // which post and whether we add or remove like
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        guard let postId = postId else { fatalError() }
//        guard let postId = postId else { fatalError() }
        if addLike {
            // updates user-likes structure
            Database.database().reference().child("user-likes").child(currentUid).updateChildValues([postId: 1]) { (err, ref) in
                
                self.sendLikeNotificationToServer()
                
                // update post-likes structure
                // completion block means: while func is working then its doing completion block
                Database.database().reference().child("post-likes").child(postId).updateChildValues([currentUid: 1]) { (err, ref) in
                    // we ensure that the values belowe are not set until the values above are finished updating in database
                    self.likes += 1
                    self.didLike = true
                    completion(self.likes)
                    Database.database().reference().child("posts").child(postId).child("likes").setValue(self.likes) // find "likes" key and set its value
                }
            }
        } else {
            //observer database for notification to remove
            Database.database().reference().child("user-likes").child(currentUid).child(postId).observeSingleEvent(of: .value) { (dataSnapshot) in
                
                // notification id to remove from server
                guard let notificationId = dataSnapshot.value as? String else { fatalError() }
                
                // remove that value from database
                Database.database().reference().child("notifications").child(self.ownerUid).child(notificationId).removeValue { (err, ref) in
                    // updates user-likes structure
                    Database.database().reference().child("user-likes").child(currentUid).child(postId).removeValue { (err, ref) in

                        // update post-likes structure
                        Database.database().reference().child("post-likes").child(self.postId).child(currentUid).removeValue { (err, ref) in

                            guard self.likes > 0 else { return }
                            self.likes -= 1
                            self.didLike = false
                            completion(self.likes)
                            Database.database().reference().child("posts").child(self.postId).child("likes").setValue(self.likes) // find "likes" key and set its value
                        }
                    }
                }
            }
        }
    }
    
    func sendLikeNotificationToServer() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        let creationDate = Int(NSDate().timeIntervalSince1970)

        // only send notification if like is for post that is not current users
        if currentUid != self.ownerUid {
            
            guard let postId = self.postId else { fatalError() }
            
            // notification values
            let values = ["checked": 0,
                          "creationDate": creationDate,
                          "currentUid": currentUid,
                          "type": LIKE_INT_VALUE,
                          "postId": postId] as [String : Any]
            
            // notification database ref
            let notificationRef = Database.database().reference().child("notifications").child(self.ownerUid).childByAutoId()
            
            // upload notification to database
            notificationRef.updateChildValues(values) { (err, ref) in
                Database.database().reference().child("user-likes").child(currentUid).child(self.postId).setValue(notificationRef.key)
            }
        }
    }
}


