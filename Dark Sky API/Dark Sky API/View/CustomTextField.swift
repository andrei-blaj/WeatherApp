//
//  CustomTextField.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 14/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        self.attributedPlaceholder = placeholder
    }

}
