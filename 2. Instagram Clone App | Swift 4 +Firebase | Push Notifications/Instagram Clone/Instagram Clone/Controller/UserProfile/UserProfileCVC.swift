//
//  UserProfileVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 09/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "UserPostCell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    //MARK: - Properties
    
    var user: User?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell classes
        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UserProfileHeaderCVCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        self.collectionView.backgroundColor = .white
        
        if self.user == nil {
            fetchCurrentUserData()
        }
        
        fetchPosts()
    }
    
    //MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    //MARK: - UICollectionView
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeaderCVCell
        
        header.delegate = self
        
        header.user = self.user
        navigationItem.title = user?.username

        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedCVC = FeedCVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedCVC.viewSinglePost = true
        let post = posts[indexPath.row]
        feedCVC.post = post
        navigationController?.pushViewController(feedCVC, animated: true)
    }
    
    //MARK: - UserProfileHeader Protocol
    
    func handleFollowersTapped(for header: UserProfileHeaderCVCell) {
        let followLikeTVC = FollowLikeTVC()
        followLikeTVC.viewingMode = FollowLikeTVC.ViewingMode(index: 1)
        followLikeTVC.uid = user?.uid
        navigationController?.pushViewController(followLikeTVC, animated: true)
    }
    
    func handleFollowingTapped(for header: UserProfileHeaderCVCell) {
        let followLikeTVC = FollowLikeTVC()
        followLikeTVC.viewingMode = FollowLikeTVC.ViewingMode(index: 0)
        followLikeTVC.uid = user?.uid
        navigationController?.pushViewController(followLikeTVC, animated: true)
    }
    
    func handleEditFollowTapped(for header: UserProfileHeaderCVCell) {
        guard let user = header.user else { fatalError() }
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            print("Unfinished: handleEditFollowTapeped() in UserProfileCVC.swift")
        } else {
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                user.follow()
            } else {
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
            }
        }
    }
    
    func setUsersStat(for header: UserProfileHeaderCVCell) {
        guard let uid = header.user?.uid else { return } // !fatalError()
        
        var numberOfFollowers: Int = 0
        var numberOfFollowing: Int = 0
        
        // get number of followers
        Database.database().reference().child("user-followers").child(uid).observe(.value) { (dataSnapshot) in // observe(.value) is observing for every change, real time observing 
            if let snapshot = dataSnapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowers = snapshot.count
            } else {
                numberOfFollowers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowers)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.followersLabel.attributedText = attributedText
        }
        
        // get number of following
        Database.database().reference().child("user-following").child(uid).observe(.value) { (dataSnapshot) in
            if let snapshot = dataSnapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowing = snapshot.count
            } else {
                numberOfFollowing = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.followingLabel.attributedText = attributedText
        }
        
        // get number of posts
        Database.database().reference().child("user-posts").child(uid).observe(.value) { (dataSnapshot) in
            guard let snapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { fatalError() }
            let postCount = snapshot.count
            
            let attributedText = NSMutableAttributedString(string: "\(postCount)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.postLabel.attributedText = attributedText
        }
    }
    
    //MARK: - API
    
    func fetchPosts() {
        var uid: String!
        
        if let user = self.user {
            uid = user.uid
        } else {
            uid = Auth.auth().currentUser?.uid
        }
        
        // childAdded so the post is going to be added without refreshing
        Database.database().reference().child("user-posts").child(uid).observe(.childAdded) { (dataSnapshot) in
            
            let postId = dataSnapshot.key
            Database.fetchPost(withPostId: postId) { (post) in
                self.posts.append(post)
                self.posts.sort { (post1, post2) -> Bool in
                    return post1.creationDate > post2.creationDate
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchCurrentUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let dictionary = dataSnapshot.value as? Dictionary<String, AnyObject> else { fatalError() }
            let user = User(uid: currentUid, dictionary: dictionary)
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        }
    }
}
