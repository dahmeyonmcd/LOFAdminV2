//
//  ChatPageCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

class ChatPageCell: UICollectionViewCell {
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupOverView()

    }
    
    func setupOverView() {
        
        let window = UIApplication.shared.keyWindow
        let v2 = ResourcesView(frame: (window?.bounds)!)
        
        addSubview(v2)
        
        
        v2.topAnchor.constraint(equalTo: topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        v2.alpha = 1
        
    }
    
   
    
//    fileprivate func observeKeyboardNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.frame.origin.y -= keyboardSize.height
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.frame.origin.y += keyboardSize.height
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
