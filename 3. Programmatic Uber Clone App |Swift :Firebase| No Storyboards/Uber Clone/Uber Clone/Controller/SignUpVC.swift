//
//  SignUpVC.swift
//  Uber Clone
//
//  Created by Mateusz Sarnowski on 01/10/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
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
    
    private let fullNameTextField: UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "Full Name", isSecureTextEntry: false)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let v = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField)
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
     
    private let passwordTextField: UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "Password", isSecureTextEntry: true)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let v = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let v = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedControll: accountTypeSegmentedControl)
        v.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return v
    }()
    
    private let signUpButton: AuthButton = {
        let b = AuthButton(type: .system)
        b.setTitle("Sign Up", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.isEnabled = false
        b.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        return b
    }()
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let b = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Log in", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        b.setAttributedTitle(attributedTitle, for: .normal)

        b.setTitleColor(.black, for: .normal)
        b.layer.cornerRadius = 5
        b.addTarget(self, action: #selector(handleAlreadyHaveAnAccountButtonPressed), for: .touchUpInside)
        return b
    }()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .backgroundColor
        
        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Configure UI
    
    func configureUI() {
        // configure titleLabel
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        // configure stackView
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView, passwordContainerView, accountTypeContainerView, signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        
        
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        // configure stackView alreadyHaveAnAccountButton
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        alreadyHaveAnAccountButton.centerX(inView: view)
    }
    
    // MARK: - Selectors
    
    @objc func formValidation() {
        if emailTextField.hasText && passwordTextField.hasText && fullNameTextField.hasText {
            signUpButton.isEnabled = true
            signUpButton.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        } else {
            signUpButton.isEnabled = false
            signUpButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        }
    }
    
    @objc func handleSignUpButtonPressed() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let fullName = fullNameTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }

            guard let uid = authDataResult?.user.uid else { return }
            
            let dictionaryValues = ["email": email, "fullName": fullName, "accountType": self.accountTypeSegmentedControl.selectedSegmentIndex] as [String : Any]
            
            let values = [uid: dictionaryValues]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, databaseReference) in
                if let error = error {
                    print("DEBUG: Error updating user values to database: ", error.localizedDescription)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleAlreadyHaveAnAccountButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
