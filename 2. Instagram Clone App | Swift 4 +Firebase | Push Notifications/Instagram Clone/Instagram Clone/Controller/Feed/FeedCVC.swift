//
//  FeedCVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 09/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "FeedCVCell" // what about its name, can it be different than the swift filename

class FeedCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCVCellDelegate {
    
    //MARK: - Properties
    
    var posts = [Post]()
    var viewSinglePost = false
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(FeedCVCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        refreshCVC()
        configureNavigationBar()
        
        if !viewSinglePost {
            fetchPosts()
        }
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 50 + 60
        return CGSize(width: width, height: height)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewSinglePost {
            return 1
        } else {
            return posts.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCVCell
        
        // Configure the cell
        cell.delegate = self
        
        if viewSinglePost {
            cell.post = post
            
        } else {
            cell.post = posts[indexPath.row]
        }
        return cell
    }
    
    // MARK: - FeedCVCellDelegate Protocol
    
    func handleUsernameTapped(for cell: FeedCVCell) {
        print("handleUsernameTapped()")
        guard let user = cell.post?.user else { fatalError() }
        let userProfileCVC = UserProfileCVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileCVC.user = user
        navigationController?.pushViewController(userProfileCVC, animated: true)
    }
    
    func handleOptionsTapped(for cell: FeedCVCell) {
        print("handleOptionsTapped()")
    }
    
    func handleLikeTap() {
        
    }
    
    func handleLikeTapped(for cell: FeedCVCell, isDoubleTap: Bool) {
        guard let post = cell.post else { return }
        
        if post.didLike { // post has a like and isDoubleTap is false, then unlike
            if !isDoubleTap {
                post.adjustLikes(addLike: false) { (likes) in
                    if likes == 1 {
                        cell.likesLabel.text = "\(likes) like"
                    } else {
                        cell.likesLabel.text = "\(likes) likes"
                    }
                    cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                }
            }
        } else { // post has no like, then add like
            post.adjustLikes(addLike: true) { (likes) in
                if likes == 1 {
                    cell.likesLabel.text = "\(likes) like"
                } else {
                    cell.likesLabel.text = "\(likes) likes"
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
            }
        }
    }
    
    func handleCommentTapped(for cell: FeedCVCell) {
        let commentCVC = CommentCVC(collectionViewLayout: UICollectionViewFlowLayout())
        guard let post = cell.post else { fatalError() }
        commentCVC.post = post
        navigationController?.pushViewController(commentCVC, animated: true)
    }
    
    func handleConfigureLikeButton(for cell: FeedCVCell) {
        guard let post = cell.post else { fatalError()}
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        Database.database().reference().child("user-likes").child(currentUid).observeSingleEvent(of: .value) { (dataSnapshot) in
            if dataSnapshot.hasChild(post.postId) {
                post.didLike = true
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
            }
        }
    }
    
    func handleShowLikes(for cell: FeedCVCell) {
        let followLikeTVC = FollowLikeTVC()
        followLikeTVC.viewingMode = FollowLikeTVC.ViewingMode(index: 2)
        guard let postId = cell.post?.postId else { return }
        followLikeTVC.postId = postId
        navigationController?.pushViewController(followLikeTVC, animated: true)
    }
    
    
    //MARK: - Handlers
    
    func refreshCVC() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl
    }
    
    func configureNavigationBar() {
        if !viewSinglePost {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        self.navigationItem.title = "Feed"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(handleShowMessages))
    }
    
    @objc func handleLogout() {
        print("handle logout here")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                
                let navController = UINavigationController(rootViewController: LoginVC())
                self.present(navController, animated: true, completion: nil)
                print("Succesfuly loged user out")
            } catch {
                print("Failed to sing out with error: ", error.localizedDescription)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleShowMessages() {
        print("FeedCVC, handleShowMessages()")
    }
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        fetchPosts()
        collectionView.reloadData()
    }
    
    
    // MARK: - API
    
    func fetchPosts() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("user-feed").child(currentUserUid).observe(.childAdded) { (dataSnapshot) in
            let postId = dataSnapshot.key
            Database.fetchPost(withPostId: postId) { (post) in
                self.posts.append(post)
                self.posts.sort { (post1, post2) -> Bool in
                    return post1.creationDate > post2.creationDate
                }
                // end refreshing
                self.collectionView.refreshControl?.endRefreshing()
                
                self.collectionView.reloadData()
            }
        }
    }
    
        // temporary func to update user-feed structure; for users in user log in and call this func
    //    func updateUserFeeds() {
    //        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
    //        Database.database().reference().child("user-following").child(currentUid).observe(.childAdded) { (dataSnapshot) in
    //            let followingUid = dataSnapshot.key
    //
    //            Database.database().reference().child("user-posts").child(followingUid).observe(.childAdded) { (dataSnapshot) in
    //                let postId = dataSnapshot.key
    //                Database.database().reference().child("user-feed").child(currentUid).updateChildValues([postId: 1])
    //            }
    //        }
    //
    //        Database.database().reference().child("user-posts").child(currentUid).observe(.childAdded) { (dataSnapshot) in
    //            let postId = dataSnapshot.key
    //            Database.database().reference().child("user-feed").child(currentUid).updateChildValues([postId: 1])
    //        }
    //    }
}

