//
//  RoundedButton.swift
//  Smack
//
//  Created by Philip on 3/4/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cournerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cournerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setUpView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    
    func setUpView(){
        self.layer.cornerRadius = cournerRadius
    }
}
