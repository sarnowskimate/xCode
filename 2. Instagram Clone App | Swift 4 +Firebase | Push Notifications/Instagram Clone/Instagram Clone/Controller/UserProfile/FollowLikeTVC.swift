//
//  FollowLikeTVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 05/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "FollowTVCell"

class FollowLikeTVC: UITableViewController, FollowTVCellDelegate {
    
    //MARK: - Parameters
    
    // def. of enum
    enum ViewingMode: Int {
        case Following
        case Followers
        case Likes
        
        init(index: Int) {
            switch index {
            case 0:
                self = ViewingMode.Following
            case 1:
                self = ViewingMode.Followers
            case 2:
                self = ViewingMode.Likes
            default:
                self = ViewingMode.Following
            }
        }
    }
    var postId: String?
    var viewingMode: ViewingMode!
    var uid: String?
    var users = [User]()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell class
        tableView.register(FollowLikeTVCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // configure nav controller, it is no needed to check if viewingMode exist, it is checked inside functions
        configureNavTitle()
        fetchUsers()
        
        tableView.separatorColor = .clear
    }
    
    
    //MARK: - UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowLikeTVCell
        cell.delegate = self
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userProfileVC = UserProfileCVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    //MARK: - FollowTVCellDelegate Protocol
    
    func handleFollowTapped(for cell: FollowLikeTVCell) {
        print("Handle follow tapped")
        guard let user = cell.user else { fatalError() }
        if user.isFollowed {
            user.unfollow()
            cell.followButton.configure(didFollow: false)
        } else {
            user.follow()
            cell.followButton.configure(didFollow: true)
        }
    }
    
    // MARK: - Handlers
    
    func configureNavTitle() { // or with input parameter (with viewingMode: ViewingMode)
        guard let viewingMode = self.viewingMode else { return }

        switch viewingMode {
        case .Following:
            navigationItem.title = "Following"
        case .Followers:
            navigationItem.title = "Followers"
        case .Likes:
            navigationItem.title = "Likes"
        }
    }
    
    // MARK: - API
    
    func getDatabaseReference() -> DatabaseReference? {
        guard let viewingMode = self.viewingMode else { return nil }
        
        switch viewingMode {
        case .Following:
            return Database.database().reference().child("user-following")
        case .Followers:
            return Database.database().reference().child("user-followers")
        case .Likes:
            return Database.database().reference().child("post-likes")
        }
    }
    
    func fetchUserX(dataSnapshot: DataSnapshot) {
        let userId = dataSnapshot.key
        
        Database.fetchUser(withUid: userId, completion: { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        })
    }
    
    func fetchUsers() {
        guard let viewingMode = self.viewingMode else { return }
        guard let ref = getDatabaseReference() else { fatalError() }
        
        switch viewingMode {
        case .Followers, .Following:
            guard let uid = self.uid else { fatalError() } //uid is passed from UserProfileCVC and is nil in .Likes case, so it must be here and not outside this case; if so the .Likes case wont be executed because it would { return }
            ref.child(uid).observeSingleEvent(of: .value) { (dataSnapshot) in
                guard let allObjects = dataSnapshot.children.allObjects as? [DataSnapshot] else { fatalError() }
                allObjects.forEach { (dataSnapshot) in
                    self.fetchUserX(dataSnapshot: dataSnapshot)
                }
            }
        case .Likes:
            guard let postId = self.postId else { fatalError() }
            ref.child(postId).observe(.childAdded) { (dataSnapshot) in
                self.fetchUserX(dataSnapshot: dataSnapshot)
            }
        }
    }
}
