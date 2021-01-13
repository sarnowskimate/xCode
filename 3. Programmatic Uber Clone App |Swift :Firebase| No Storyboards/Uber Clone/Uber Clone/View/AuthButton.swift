//
//  AuthButton.swift
//  Uber Clone
//
//  Created by Mateusz Sarnowski on 04/10/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainBlueTint
        setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
