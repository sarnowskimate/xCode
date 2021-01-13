//
//  SignUpVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 06/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

// UIImagePickerControllerDelegate and UINavigationControllerDelegate are needed to choose picture

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageSelected = false
    
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleSelectPhotoProfile), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureView()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let b = UIButton()
        b.setTitle("Sign Up", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        b.layer.cornerRadius = 5
        b.isEnabled = false
        b.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return b
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let b = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        
        b.setAttributedTitle(attributedTitle, for: .normal)
        b.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return b
    }()
    
    @objc func handleShowLogin() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { fatalError() }
        guard let password = passwordTextField.text else { fatalError() }
        guard let fullName = fullNameTextField.text else { fatalError() }
        guard let username = usernameTextField.text?.lowercased() else { fatalError() }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if let safeError = error {
                print("DEBUG: Failed to create user with error: ", safeError.localizedDescription)
                return
            }
            
            guard let profileImage = self.plusPhotoButton.imageView?.image else { fatalError() }
            
            guard let uploadData = profileImage.jpeDgData(compressionQuality: 0.3) else { fatalError() }
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                
                if let safeError = error {
                    print("Failed to upload image into Firebase Storage with error: ", safeError.localizedDescription)
                    return
                }
                
                storageRef.downloadURL { (downloadUrl, error) in
                    guard let profileImageURL = downloadUrl?.absoluteString else {
                        print("DEBUG: profile image URL is nil")
                        return
                    }
                    
                    guard let uid = authResult?.user.uid else { fatalError() }
                    
                    let dictionaryValues = ["name": fullName,
                                            "username": username,
                                            "profileImageURL": profileImageURL]
                    
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values) { (error, ref) in
                        print("Succesfuly created user and saved information to database.")
                        
                        guard let mainTBC = UIApplication.shared.keyWindow?.rootViewController as? MainTBC else { fatalError() }
                        mainTBC.configureViewControllers()
                        
                        self.dismiss(animated: true, completion: nil)
    
                    }
                }
                print("Succesfully created user with Firebase.")
            }
            print("Email is \(email), password is \(password)")
        }
    }
    
    @objc func formValidation() {
        guard emailTextField.hasText, fullNameTextField.hasText, usernameTextField.hasText, passwordTextField.hasText, imageSelected == true else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    @objc func handleSelectPhotoProfile() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        
        imageSelected = true
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 240)
    }
}
