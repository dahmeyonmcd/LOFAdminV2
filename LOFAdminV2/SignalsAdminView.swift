//
//  SignalsAdminView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/16/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class SignalsAdminView: UIView {
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
