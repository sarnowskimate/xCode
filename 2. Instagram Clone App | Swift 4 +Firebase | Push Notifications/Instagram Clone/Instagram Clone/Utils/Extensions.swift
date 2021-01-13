//
//  Extensions.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 06/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

extension UIButton {
    func configure(didFollow: Bool) {
        if didFollow {
            // handle follow user
            self.setTitle("Following", for: .normal)
            self.setTitleColor(.black, for: .normal)
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.backgroundColor = .white
        } else {
            // handle unfollow user
            self.setTitle("Follow", for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.layer.borderWidth = 0
            self.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension Database {
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let dictionary = dataSnapshot.value as? Dictionary<String, AnyObject> else { fatalError() }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchPost(withPostId postId: String, completion: @escaping(Post) -> ()) { // -> () means return void
        Database.database().reference().child("posts").child(postId).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let dictionary = dataSnapshot.value as? Dictionary<String, AnyObject> else { fatalError() }
            guard let ownerUid = dictionary["ownerUid"] as? String else { fatalError() }
            Database.fetchUser(withUid: ownerUid) { (user) in
                let post = Post(postId: postId, user: user, dictionary: dictionary)
                completion(post)
            }
        })
    }
    
//    static func fetchComment(withCommentId commentId: String, completion: @escaping(Comment) -> ()) {
//        Database.database().reference().child("comments").child(commentId).observeSingleEvent(of: .value) { (dataSnapshot) in
//            guard let dictionary = dataSnapshot.value as? Dictionary<String, AnyObject> else { return }
//            let comment = Comment(dictionary: dictionary)
//            completion(comment)
//        }
//    }
   
}

//var imageCache = [String: UIImage]()
//
//extension UIImageView {
//    func loadImage(with urlString: String) {
//        // check if image exists in cache - if so, RETURN and skip all lines of code below
//        if let cachedImage = imageCache[urlString] {
//            image = cachedImage
//            return
//        }
//
//        // url for image location
//        guard let url = URL(string: urlString) else { fatalError() }
//
//        // fetch data of url
//        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
//            // handle error
//            if let safeError = error {
//                print("Failed to fetch data out of url image with error: \(safeError.localizedDescription)")
//            }
//            guard let imageData = data else { fatalError() }
//            let photoImage = UIImage(data: imageData)
//
//            // set key and value for image cache
//            imageCache[url.absoluteString] = photoImage
//
//            // set image
//            DispatchQueue.main.async {
//                self.image = photoImage
//            }
//        }.resume() // calling resume to ensure if for some reason fetching would be interrupted, so that it will continue until it fetches the data
//        print("The image is cached now.")
//    }
//}
