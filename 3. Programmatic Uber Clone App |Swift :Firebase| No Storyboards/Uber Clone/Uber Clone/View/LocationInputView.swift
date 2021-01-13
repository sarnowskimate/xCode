//
//  LocationInputView.swift
//  Uber Clone
//
//  Created by Mateusz Sarnowski on 14/10/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func dismissLocationInputView()
}

class LocationInputView: UIView {

    // MARK: - Properties
    
    weak var delegate: LocationInputViewDelegate?
    
    private let backButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        b.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return b
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Full Name"
        l.textColor = .darkGray
        l.font = UIFont.systemFont(ofSize: 16)
        return l
    }()
    
    private let startLocationIndicatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    private let linkingView: UIView = {
        let v = UIView()
        v.backgroundColor = .darkGray
        return v
    }()
    
    private let destinationIndicatorViewView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    private lazy var startingLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Current Location"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .systemGroupedBackground
        tf.isEnabled = false
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var destinationLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a destination"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .lightGray
        tf.returnKeyType = .search
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadow()
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 24)
        
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
                
        addSubview(startingLocationTextField)
        startingLocationTextField.anchor(top: backButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 40, paddingRight: 40, height: 30)
        
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(top: startingLocationTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 40, paddingRight: 40, height: 30)
        
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.setDimensions(height: 6, width: 6)
        startLocationIndicatorView.layer.cornerRadius = 6 / 2
        startLocationIndicatorView.centerY(inView: startingLocationTextField)
        startLocationIndicatorView.anchor(left: leftAnchor, paddingLeft: 20)
        
        addSubview(destinationIndicatorViewView)
        destinationIndicatorViewView.setDimensions(height: 6, width: 6)
        destinationIndicatorViewView.centerY(inView: destinationLocationTextField)
        destinationIndicatorViewView.anchor(left: leftAnchor, paddingLeft: 20)
        
        addSubview(linkingView)
        linkingView.centerX(inView: startLocationIndicatorView)
        linkingView.anchor(top: startLocationIndicatorView.bottomAnchor, bottom: destinationIndicatorViewView.topAnchor, paddingTop: 4, paddingBottom: 4, width: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleBackButtonTapped() {
        print("DEBUG: handleBackButtonTapped()")
        delegate?.dismissLocationInputView()
    }
    
    // MARK: - Auxiliary functions
    

    
}
