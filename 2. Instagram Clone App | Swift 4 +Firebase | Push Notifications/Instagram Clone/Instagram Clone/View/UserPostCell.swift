//
//  UserPostCell.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 14/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit

class UserPostCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.postImageUrl else { fatalError() }
            postImageView.loadImage(with: postImageUrl)
        }
    }
    
    let postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
