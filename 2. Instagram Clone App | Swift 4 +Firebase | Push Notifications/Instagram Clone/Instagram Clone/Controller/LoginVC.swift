//
//  LoginVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 06/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    let loginContainerView: UIView = {
        let v = UIView()
        
        let logoImageView = UIImageView()
        logoImageView.image = #imageLiteral(resourceName: "Instagram_logo_white")
        logoImageView.contentMode = .scaleAspectFill
        
        v.addSubview(logoImageView)
        
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        v.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
        return v
    }()

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Login", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        b.layer.cornerRadius = 5
        b.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        b.isEnabled = false
        return b
    }()
    
    let dontHaveAccountButton: UIButton = {
        let b = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        
        b.setAttributedTitle(attributedTitle, for: .normal)
        b.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(loginContainerView)
        loginContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        configureViewComponents()
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    @objc func handleShowSignUp() {
        let signUpVC = SignUpVC()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if let safeError = error {
                print("Failed to sign in with error: ", safeError.localizedDescription)
                return
            }
            
            guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTBC else { fatalError() }
            mainTabVC.configureViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func formValidation() {
        guard emailTextField.hasText, passwordTextField.hasText else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    func configureViewComponents() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: loginContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 140)
    }

}
