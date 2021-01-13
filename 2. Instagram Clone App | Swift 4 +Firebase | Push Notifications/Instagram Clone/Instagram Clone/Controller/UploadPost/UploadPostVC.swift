//
//  UploadPostVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 09/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class UploadPostVC: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    
    var selectedImage: UIImage?
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.groupTableViewBackground
        tv.font = UIFont.systemFont(ofSize: 12)
        return tv
    }()
    
    let shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Share", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleSharePost), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        configureViewCompontents()
        
        // load image after adding photoImageView component; otherwise may crash
        loadImage()
        
        captionTextView.delegate = self
    }
    
    //MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            shareButton.isEnabled = false
            shareButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        } else {
            shareButton.isEnabled = true
            shareButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }
    }
    
    //MARK: - Handlers
    
    func updateUserFeeds(withPostId postId: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { fatalError() }
        let values = [postId: 1]
        
        // update followers feed
        Database.database().reference().child("user-followers").child(currentUserUid).observe(.childAdded) { (dataSnapshot) in
            let followerUid = dataSnapshot.key
            Database.database().reference().child("user-feed").child(followerUid).updateChildValues(values)
        }
        
        // update current user feed
        Database.database().reference().child("user-feed").child(currentUserUid).updateChildValues(values)
    }
    
    @objc func handleSharePost() {
        
        guard
            let caption = captionTextView.text,
//            let postImg = photoImageView.image,
            let currentUid = Auth.auth().currentUser?.uid
            else { return }
        
        // image upload data
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.5) else { fatalError() }
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("post_images").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (storageMetadata, error) in
            if let safeError = error {
                fatalError("Failed to upload image to storage with error: \(safeError.localizedDescription)")
            }
            
            storageRef.downloadURL { (downloadUrl, error) in
                guard let postImageUrl = downloadUrl?.absoluteString else { fatalError() }

                let dictionaryValues = ["caption": caption,
                                        "creationDate": creationDate,
                                        "likes": 0,
                                        "postImageUrl": postImageUrl,
                                        "ownerUid": currentUid] as [String: Any]
                
                let postId = Database.database().reference().child("posts").childByAutoId()
                guard let postKey = postId.key else { fatalError() }

                postId.updateChildValues(dictionaryValues) { (err, dbRef) in
                    
                    Database.database().reference().child("user-posts").child(currentUid).updateChildValues([postKey: 1]) // the key attribute is an unique value of post structure
                    
                    self.updateUserFeeds(withPostId: postKey)
                    
                    self.dismiss(animated: true) {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
                }
            }
        }

    
    func configureViewCompontents() {
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 24, width: 0, height: 40)
    }
    
    func loadImage() {
        guard let selectedImage = self.selectedImage else { fatalError() }
        photoImageView.image = selectedImage
    }
}
