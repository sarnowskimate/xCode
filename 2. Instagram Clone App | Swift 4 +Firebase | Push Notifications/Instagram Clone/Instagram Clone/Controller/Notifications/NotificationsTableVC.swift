//
//  NotificationsVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 09/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "NotificationTVCell"

class NotificationsVC: UITableViewController, NotificationTVCellDelegate {
    
    
    // MARK: - Properties
    
    var timer: Timer?
    
    var notifications = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = .clear
        
        // register cell class
        tableView.register(NotificationTVCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        configureNavController()
        
        fetchNotifications()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationTVCell // dequeueReusableCell is about performace, the memory management; when cell is hiding it will dequeue
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = notifications[indexPath.row].user else { return }
        let userProfileCVC = UserProfileCVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileCVC.user = user
        navigationController?.pushViewController(userProfileCVC, animated: true)
    }
    
    // MARK: - Handlers
    
    func configureNavController() {
        navigationItem.title = "Notifications"
    }
    
    func handleFollowTapped(for cell: NotificationTVCell) {
        guard let user = cell.notification?.user else { fatalError() }
        
        if user.isFollowed {
            user.unfollow()
            cell.followButton.configure(didFollow: false)
            
        } else {
            user.follow()
            cell.followButton.configure(didFollow: true)
        }
    }
    
    func handlePostTapped(for cell: NotificationTVCell) {
        guard let post = cell.notification?.post else { fatalError() }
        let feedCVC = FeedCVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedCVC.viewSinglePost = true
        feedCVC.post = post
        navigationController?.pushViewController(feedCVC, animated: true)
    }
    
    func handleReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleSortNotifications), userInfo: nil, repeats: false)
    }
    
    @objc func handleSortNotifications() {
        notifications.sort { (notification1, notification2) -> Bool in
            return notification1.creationDate > notification2.creationDate
        }
        self.tableView.reloadData()
    }
    
    // MARK: - API
    
    
    func fetchNotifications() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        Database.database().reference().child("notifications").child(currentUid).observe(.childAdded) { (dataSnapshot) in
            
            let notificationId = dataSnapshot.key
            guard let dictionary = dataSnapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let ownerUid = dictionary["currentUid"] as? String else { fatalError() }
            Database.fetchUser(withUid: ownerUid) { (user) in
                if let postId = dictionary["postId"] as? String {
                    Database.fetchPost(withPostId: postId) { (post) in
                        let notification = Notification(user: user, post: post, dictionary: dictionary)
                        self.notifications.append(notification)
                        self.handleReloadTable()
                    }
                    
                } else {
                    let notification = Notification(user: user, dictionary: dictionary)
                    self.notifications.append(notification)
                    self.handleReloadTable()
                }
            }
            
            Database.database().reference().child("notifications").child(currentUid).child(notificationId).child("checked").setValue(1)
        }
    }
}
