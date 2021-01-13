//
//  FollowLikeTVCell.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 05/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class FollowLikeTVCell: UITableViewCell {
    
    //MARK: - Properties
    
    var delegate: FollowTVCellDelegate?
    var user: User? {
        
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { fatalError() }
            guard let username = user?.username else { fatalError() }
            guard let fullName = user?.name else { fatalError() }
            
            profileImageView.loadImage(with: profileImageUrl)
            self.textLabel?.text = username
            detailTextLabel?.text = fullName
            
            if user?.uid == Auth.auth().currentUser?.uid {
                followButton.isHidden = true
            }
            
            user?.checkIfUserIsFollowed(completion: { (followed) in
                if followed {
                    self.followButton.configure(didFollow: false)
                } else {
                    self.followButton.configure(didFollow: true)
                }
            })
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var followButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Follow", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        b.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return b
    }()

    
    //MARK: - Handlers
    
    @objc func handleFollowTapped() { // it is needed to be handled in FollowTVC, not in view
        delegate?.handleFollowTapped(for: self)
    }
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        
        // centers image in each cell
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        
        textLabel?.text = "Username"
        detailTextLabel?.text = "Full Name"
        
        addSubview(followButton)
        followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 30)
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        selectionStyle = .none
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 68, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        detailTextLabel?.frame = CGRect(x: 68, y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    

    
}
