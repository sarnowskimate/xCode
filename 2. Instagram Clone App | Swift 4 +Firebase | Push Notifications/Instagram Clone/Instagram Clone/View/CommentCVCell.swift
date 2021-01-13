//
//  CommentCVCell.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 17/08/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class CommentCVCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var comment: Comment? {
        didSet {
            guard let user = comment?.user else { fatalError() }
            guard let profileImageUrl = user.profileImageUrl else { fatalError() }
            profileImageView.loadImage(with: profileImageUrl)
            guard let username = user.username else { fatalError() }
            guard let commentText = comment?.commentText else { fatalError() }
            guard let commentDate = getCommentTimeStamp() else { fatalError()}
            
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
            attributedText.append(NSMutableAttributedString(string: " \(commentText)", attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
            attributedText.append(NSMutableAttributedString(string: " \(commentDate)", attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSMutableAttributedString.Key.foregroundColor: UIColor.lightGray]))
            
            commentTextView.attributedText = attributedText
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40/2
        return iv
    }()
    
    let commentTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 12)
        tv.isScrollEnabled = false
        return tv
    }()
    
    func getCommentTimeStamp() -> String? {
        guard let creationDate = comment?.creationDate else { return nil }
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        
        let now = Date()
        return dateFormatter.string(from: creationDate, to: now)
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
