//
//  LocationInputActivationView.swift
//  Uber Clone
//
//  Created by Mateusz Sarnowski on 09/10/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit

protocol LocationInputActivationViewDelegate: class {
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LocationInputActivationViewDelegate?
    
    private let indicatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.text = "Where to?"
        l.textColor = .darkGray
        l.font = UIFont.systemFont(ofSize: 18)
        return l
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()

        addSubview(indicatorView)
        indicatorView.centerY(inView: self, left: leftAnchor, paddingLeft: 16)
        indicatorView.setDimensions(height: 6, width: 6)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, left: indicatorView.rightAnchor, paddingLeft: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowLocationInputView))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleShowLocationInputView() {
        delegate?.presentLocationInputView()
    }
}
