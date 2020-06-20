//
//  ActivePageCell.swift
//  LionsofForexAdminApp
//
//  Created by UnoEast on 5/30/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class InactivePageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupOverview()
    }
    
    func setupOverview() {
        let view = InactivePageView(frame: self.frame)
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
