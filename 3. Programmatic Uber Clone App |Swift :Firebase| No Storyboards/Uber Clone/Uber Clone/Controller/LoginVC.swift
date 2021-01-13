//
//  LoginVC.swift
//  Uber Clone
//
//  Created by Mateusz Sarnowski on 29/09/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "UBER"
        l.textColor = UIColor(white: 1, alpha: 0.8)
        l.font = UIFont(name: "Avenir-Light", size: 36)
        return l
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "Email", isSecureTextEntry: false)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    private lazy var emailContainerView: UIView = {
        let v = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "Password", isSecureTextEntry: true)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let v =  UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
    
    private let loginButton: AuthButton = {
        let b = AuthButton(type: .system)
        b.setTitle("Log In", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.isEnabled = false
        b.addTarget(self, action: #selector(handleLoginButtonPressed), for: .touchUpInside)
        return b
    }()
        
    private let dontHaveAccountButton: UIButton = {
        let b = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        b.setAttributedTitle(attributedTitle, for: .normal)

        b.setTitleColor(.black, for: .normal)
        b.layer.cornerRadius = 5
        b.addTarget(self, action: #selector(handleDontHaveAnAccountButtonPressed), for: .touchUpInside)
        return b
    }()
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .backgroundColor
        
        configureUI()
        
        configureNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Configure UI
    
    func configureUI() {
        print("LoginVC.swift -> configureUI()")
        // configure title label
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)

        // configure stackView
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)

        // configure dontHaveAccountButton
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        dontHaveAccountButton.centerX(inView: view)
    }
    
    // MARK: - Auxiliary functions
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
        
    // MARK: - Selectors
    
    @objc func formValidation() {
        print("LoginVC.swift -> formValidation()")
        if emailTextField.hasText && passwordTextField.hasText {
            loginButton.isEnabled = true
            loginButton.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        } else {
            loginButton.isEnabled = false
            loginButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        }
    }
    
    @objc func handleLoginButtonPressed() {
        print("LoginVC.swift -> handleLoginButtonPressed()")
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            guard let homeVC = UIApplication.shared.keyWindow?.rootViewController as? HomeVC else { return }
//            let homeVC = HomeVC()
            homeVC.configureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleDontHaveAnAccountButtonPressed() {
        print("LoginVC.swift -> handleDontHaveAccountButtonPressed()")
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}
