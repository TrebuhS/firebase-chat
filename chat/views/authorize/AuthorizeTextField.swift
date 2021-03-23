//
//  AuthorizeTextField.swift
//  chat
//
//  Created by Hubert Sośnicki on 19/01/2021.
//

import UIKit

class AuthorizeTextField: UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.frame.size.height = 63
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        self.layer.borderWidth = 2
    }
}
