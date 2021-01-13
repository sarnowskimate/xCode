//
//  CommentCVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 17/08/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommentCVCell"

class CommentCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var post: Post?
    var comments = [Comment]()
    
    var commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter comment..."
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let postCommentButton: UIButton = {
        let b = UIButton()
        b.setTitle("Post", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.addTarget(self, action: #selector(handleUploadComment), for: .touchUpInside)
        return b
    }()
    
    lazy var containerView: UIView = { // it is a container view, not a view, so the view from class doesn't get confused
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        v.backgroundColor = .white
        
        v.addSubview(postCommentButton)
        postCommentButton.anchor(top: nil, left: nil, bottom: nil, right: v.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 0)
        postCommentButton.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        v.addSubview(commentTextField)
        commentTextField.anchor(top: v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: postCommentButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
                
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        v.addSubview(separatorView)
        separatorView.anchor(top: v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        return v
    }()
    
    
    override func viewDidLoad() { // hiding tabbar in viewDidLoad would result in hiding it once, because viewDidLoad is executed only once, unless app is restarted
        super.viewDidLoad()
        
        // register cell classes
        collectionView.register(CommentCVCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        navigationItem.title = "Comments"
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCVCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    // MARK: - UICollectionViewLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 50)
        let dummyCell = CommentCVCell(frame: frame)
        dummyCell.comment = comments[indexPath.row]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: collectionView.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = comments[indexPath.row].user else { fatalError() }
        let userProfileCVC = UserProfileCVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileCVC.user = user
        navigationController?.pushViewController(userProfileCVC, animated: true)
    }
    
    // MARK: - Hanlders
    
    @objc func handleUploadComment() {
        guard let postId = self.post?.postId else { fatalError() }
        guard let commentText = commentTextField.text else { fatalError() }
        guard let uid = Auth.auth().currentUser?.uid else { fatalError() }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let dictionaryValues = ["uid": uid,
                                "commentText": commentText,
                                "creationDate": creationDate] as [String : Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(dictionaryValues) { (err, ref) in // with completion just to be safe the comment is deleted after succesful upload data
            
            self.uploadCommentNotificationToServer()
            
            self.commentTextField.text = nil
        }
    }
    
    func fetchComments() {
        guard let postId = self.post?.postId else { fatalError() }
        Database.database().reference().child("comments").child(postId).observe(.childAdded) { (dataSnapshot) in
            guard let dictionary = dataSnapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let uid = dictionary["uid"] as? String else { fatalError() }
            Database.fetchUser(withUid: uid) { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
        }
    }
    
    func uploadCommentNotificationToServer() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        guard let post = self.post else { fatalError() }
        guard let ownerUid = post.ownerUid else { fatalError() }
        guard let postId = post.postId else { fatalError() }
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let values = ["checked": 0,
                      "creationDate": creationDate,
                      "currentUid": currentUid,
                      "type": COMMENT_INT_VALUE,
                      "postId": postId] as [String : Any]
        
        if ownerUid != currentUid {
            Database.database().reference().child("notifications").child(ownerUid).childByAutoId().updateChildValues(values)
        }
    }
}
