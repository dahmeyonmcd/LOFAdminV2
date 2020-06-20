//
//  AffiliatePageCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class AffiliatePageCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupOverView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupOverView() {
        
        let window = UIApplication.shared.keyWindow
        let v2 = AffiliatesView(frame: (window?.bounds)!)
        
        addSubview(v2)
        
        
        v2.topAnchor.constraint(equalTo: topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        v2.alpha = 1
        
    }
    
    
    
}
