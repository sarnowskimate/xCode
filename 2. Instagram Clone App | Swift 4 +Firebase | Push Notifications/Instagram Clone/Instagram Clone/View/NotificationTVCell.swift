//
//  NotificationTVCell.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 02/09/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit

class NotificationTVCell: UITableViewCell {
    
    // MARK: - Properties
        
    var delegate: NotificationTVCellDelegate?
    
    var notification: Notification? {
        didSet {
            guard let user = notification?.user else { fatalError() }
            
            self.profileImageView.loadImage(with: user.profileImageUrl)
            
            guard let description = notification?.notificationType.description else { fatalError() }
            
            guard let notificationDate = getNotificationTimeStamp() else { fatalError() }
            
            let attributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
            attributedText.append(NSAttributedString(string: description, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
            attributedText.append(NSAttributedString(string: " \(notificationDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            notificationLabel.attributedText = attributedText
            
            configureNotificationType()
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    let notificationLabel: UILabel = {
        let l = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " commented on your post", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " 2d.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        l.attributedText = attributedText
        l.numberOfLines = 2
        return l
    }()
    
    lazy var followButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Loading", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        b.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        b.layer.cornerRadius = 3
        return b
    }()
    
    lazy var postImageView: CustomImageView = { // it cannot be let, because it would be a constant whereas we want to modify it by adding gestureRecognizer
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        tap.numberOfTapsRequired = 1
        
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    // MARK: - Handlers
    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    @objc func handlePostTapped() {
        delegate?.handlePostTapped(for: self)
    }
    
    func configureNotificationLabel() {
        
    }
    
    func configureNotificationType() {
        guard let notification = notification else { fatalError() }
                
        if notification.notificationType != .follow {
            addSubview(postImageView)
            postImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 40)
            postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            guard let post = notification.post else { fatalError() }
            postImageView.loadImage(with: post.postImageUrl)
            
        } else {
            addSubview(followButton)
            followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 30)
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            guard let user = notification.user else { fatalError() }
            user.checkIfUserIsFollowed { (followed) in
                if followed {
                    self.followButton.configure(didFollow: false)
                } else {
                    self.followButton.configure(didFollow: true)
                }
            }
        }
        
        addSubview(notificationLabel)
        notificationLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        notificationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func getNotificationTimeStamp() -> String? {
        guard let creationDate = notification?.creationDate else { return nil }
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        
        let now = Date()
        return dateFormatter.string(from: creationDate, to: now)
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
