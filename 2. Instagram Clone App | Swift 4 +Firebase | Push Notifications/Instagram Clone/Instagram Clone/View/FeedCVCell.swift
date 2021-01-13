//
//  FeedCVCell.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 22/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class FeedCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var delegate: FeedCVCellDelegate?
    
    var post: Post? {
        didSet {
            guard let owneUid = post?.ownerUid else { fatalError() }
            guard let postImageUrl = post?.postImageUrl else { fatalError() }
            guard let likes = post?.likes else { fatalError() }

            Database.fetchUser(withUid: owneUid) { (user) in
                self.profileImageView.loadImage(with: user.profileImageUrl)
                self.usernameButton.setTitle(user.username, for: .normal)
                self.configurePostCaption(user: user)
            }
            
            if likes == 1 {
                likesLabel.text = "\(likes) like"
            } else {
                likesLabel.text = "\(likes) likes"
            }
            
            postImageView.loadImage(with: postImageUrl)
            configureLikeButton()
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
     
    lazy var usernameButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Loading...", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        b.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var optionsButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("•••", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.addTarget(self, action: #selector(handleOptionsTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapToLike))
        likeTap.numberOfTapsRequired = 2
        
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        return iv
    }()
    
    lazy var likeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        b.tintColor = .black
        b.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var commentButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        b.tintColor = .black
        b.addTarget(self, action: #selector(handleCommentsTapped), for: .touchUpInside)
        return b
    }()
    
    let messageButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        b.tintColor = .black
        return b
    }()
    
    let savePostButton: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        b.tintColor = .black
        return b
    }()
    
    lazy var likesLabel: UILabel = {
        let l = UILabel()
        l.text = "3 likes"
        l.font = UIFont.boldSystemFont(ofSize: 12)
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(likeTap)
        return l
    }()
    
    let captionLabel: UILabel = {
        let l = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Username ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "Some test caption for now", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        
        l.attributedText = attributedText
        return l
    }()
    
    let postTimeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = UIFont.boldSystemFont(ofSize: 10)
        l.text = "2 DAYS AGO"
        return l
    }()
    
    // MARK: - Handlers
    
    @objc func handleUsernameTapped() {
        delegate?.handleUsernameTapped(for: self)
    }
    
    @objc func handleOptionsTapped() {
        delegate?.handleOptionsTapped(for: self)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(for: self, isDoubleTap: false)
    }
    
    @objc func handleCommentsTapped() {
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleShowLikes() {
        delegate?.handleShowLikes(for: self)
    }
    
    func configureLikeButton() {
        delegate?.handleConfigureLikeButton(for: self)
    }
    
    @objc func handleDoubleTapToLike() {
        delegate?.handleLikeTapped(for: self, isDoubleTap: true)
    }
    
    // MARK: - Delegate
    
    func configreActionButtons() {
        let sv = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        addSubview(sv)
        
        sv.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        
        addSubview(savePostButton)
        savePostButton.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 20, height: 24)
    }
    
    func configurePostCaption(user: User) {
        guard let caption = self.post?.caption else { return }
        let attributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " \(caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        captionLabel.attributedText = attributedText
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(usernameButton)
        usernameButton.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        addSubview(optionsButton)
        optionsButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        optionsButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configreActionButtons()
        
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
