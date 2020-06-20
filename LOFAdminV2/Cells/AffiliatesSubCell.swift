//
//  AffiliatesSubCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class AffiliatesSubCell: UICollectionViewCell {
    
    let tabHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 5
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
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let tabTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
    }
    
    func setupViewLayout() {
        addSubview(tabHolder)
        tabHolder.addSubview(tabHolderImage)
        tabHolder.addSubview(iconImage)
        tabHolder.addSubview(tabTitle)
        tabHolder.addSubview(amountLabel)
        
        // set constraints
        NSLayoutConstraint.activate([
            tabHolder.topAnchor.constraint(equalTo: topAnchor),
            tabHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            tabHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            tabHolderImage.topAnchor.constraint(equalTo: tabHolder.topAnchor),
            tabHolderImage.bottomAnchor.constraint(equalTo: tabHolder.bottomAnchor),
            tabHolderImage.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor),
            tabHolderImage.trailingAnchor.constraint(equalTo: tabHolder.trailingAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 60),
            iconImage.heightAnchor.constraint(equalToConstant: 60),
            iconImage.centerYAnchor.constraint(equalTo: tabHolder.centerYAnchor),
            iconImage.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor, constant: 13),
            amountLabel.heightAnchor.constraint(equalToConstant: 60),
            amountLabel.centerYAnchor.constraint(equalTo: tabHolder.centerYAnchor, constant: -5),
            amountLabel.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor, constant: 15),
            amountLabel.trailingAnchor.constraint(equalTo: tabHolder.trailingAnchor, constant: -20),
            tabTitle.heightAnchor.constraint(equalToConstant: 10),
            tabTitle.trailingAnchor.constraint(equalTo: tabHolder.trailingAnchor, constant: -9),
            tabTitle.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor, constant: 15),
            tabTitle.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 3),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
