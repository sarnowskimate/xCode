//
//  UserProfileHeaderCollectionViewCell.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 16/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeaderCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    // handler comes from Protocol; UserProfileHeaderDelegate is of Protocol type; a link between user profileVC and user profileHeader
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        
        didSet {
            configureEditProfileFollowButton()
            
            setUserStats(for: user)
            
            let fullName = user?.name
            nameLabel.text = fullName
            
            guard let profileImageUrl = user?.profileImageUrl else { return }

            profileImageView.loadImage(with: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "writtenName"
        l.font = UIFont.boldSystemFont(ofSize: 12)
        return l
    }()
    
    let postLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        l.attributedText = attributedText
        return l
    }()
    
    lazy var followersLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        l.attributedText = attributedText
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        followTap.numberOfTapsRequired = 1
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(followTap)
        
        return l
    }()
    
    lazy var followingLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        l.attributedText = attributedText
        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        followingTap.numberOfTapsRequired = 1
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(followingTap)
        
        return l
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Loading", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.setTitleColor(.black, for: .normal)
        b.layer.cornerRadius = 3
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.borderWidth = 0.5
        b.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return b
    }()
    
    let gridButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return b
    }()
    
    let listButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        return b
    }()
    
    let bookmarksButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        return b
    }()
    
    //MARK: - Handlers
    
    @objc func handleEditProfileFollow() {
        print("Handle EditFollow tapped from UserProfileHeader")
        delegate?.handleEditFollowTapped(for: self)
    } 
    
    @objc func handleFollowersTapped() {
        print("Handle followers tapped from UserProfileHeader")
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func handleFollowingTapped() {
        print("Handle following tapped from UserProfileHeader")
        delegate?.handleFollowingTapped(for: self)
    }
    
    func configureBottomToolBars() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
    
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarksButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    func configureUserStats() {
        let sv = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        sv.axis = .horizontal
        sv.distribution = .fillEqually

        addSubview(sv)
        sv.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    func setUserStats(for user: User?) {
        delegate?.setUsersStat(for: self)
    }
    
    func configureEditProfileFollowButton() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        guard let user = self.user else { return }
        if currentUid == user.uid {
            editProfileFollowButton.setTitle("Edit profile", for: .normal)
        } else {
            editProfileFollowButton.setTitle("Follow", for: .normal)
            editProfileFollowButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            editProfileFollowButton.setTitleColor(.white, for: .normal)
            user.checkIfUserIsFollowed(completion: { (followed) in
                if followed {
                    self.editProfileFollowButton.setTitle("Following", for: .normal)
                } else {
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                }
            })
        }
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        configureUserStats()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        configureBottomToolBars()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
