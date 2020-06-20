//
//  TextFieldVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class TextFieldVC: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
        
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
        
    }
    
}
