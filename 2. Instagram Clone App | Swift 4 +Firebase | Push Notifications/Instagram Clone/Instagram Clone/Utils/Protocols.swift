//
//  Protocols.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 05/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import Foundation

protocol UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: UserProfileHeaderCVCell)
    func setUsersStat(for header: UserProfileHeaderCVCell)
    
    // then going to UserProfileVC and implementing those functions
    func handleFollowersTapped(for header: UserProfileHeaderCVCell)
    func handleFollowingTapped(for header: UserProfileHeaderCVCell)
}

protocol FollowTVCellDelegate {
    func handleFollowTapped(for cell: FollowLikeTVCell)
}

protocol FeedCVCellDelegate {
    func handleUsernameTapped(for cell: FeedCVCell)
    func handleOptionsTapped(for cell: FeedCVCell)
    func handleLikeTapped(for cell: FeedCVCell, isDoubleTap: Bool)
    func handleCommentTapped(for cell: FeedCVCell)
    func handleConfigureLikeButton(for cell: FeedCVCell)
    func handleShowLikes(for cell: FeedCVCell)
}

protocol CommentCVCellDelegate {
    func somefunc(for cell: CommentCVCell)
}

protocol NotificationTVCellDelegate {
    func handleFollowTapped(for cell: NotificationTVCell)
    func handlePostTapped(for cell: NotificationTVCell)
}

protocol Printable {
    var description: String { get }
}
