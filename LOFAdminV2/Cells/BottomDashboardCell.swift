//
//  BottomDashboardCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class BottomDashBoardCell: UICollectionViewCell {
    
    let tabHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tabHolderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let tabTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewLayout() {
        addSubview(tabHolder)
        tabHolder.addSubview(tabHolderImage)
        tabHolder.addSubview(iconImage)
        tabHolder.addSubview(tabTitle)
        
        // set constraints
        NSLayoutConstraint.activate([
            tabHolder.topAnchor.constraint(equalTo: topAnchor),
            tabHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabHolderImage.topAnchor.constraint(equalTo: tabHolder.topAnchor),
            tabHolderImage.bottomAnchor.constraint(equalTo: tabHolder.bottomAnchor),
            tabHolderImage.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor),
            tabHolderImage.trailingAnchor.constraint(equalTo: tabHolder.trailingAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 60),
            iconImage.heightAnchor.constraint(equalToConstant: 60),
            iconImage.centerYAnchor.constraint(equalTo: tabHolder.centerYAnchor),
            iconImage.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor, constant: 20),
            tabTitle.bottomAnchor.constraint(equalTo: tabHolder.bottomAnchor, constant: -15),
            tabTitle.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor, constant: 20),
            tabTitle.trailingAnchor.constraint(equalTo: tabHolder.trailingAnchor, constant: -20)
            ])
        
    }
    
}
