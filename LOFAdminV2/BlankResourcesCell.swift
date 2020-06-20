//
//  ResourcesCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/16/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class BlankResourcesCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 255/255,green: 255/255,blue: 255/255,alpha: 0.2)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
//        view.layer.borderColor = UIColor.white.cgColor
//        view.layer.borderWidth = 2
        return view
    }()
    
    let openButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let subheadingLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(containerView)
        contentView.addSubview(openButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subheadingLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            openButton.widthAnchor.constraint(equalToConstant: 80),
            openButton.heightAnchor.constraint(equalToConstant: 40),
            openButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            openButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            
            subheadingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subheadingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            subheadingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            subheadingLabel.bottomAnchor.constraint(equalTo: openButton.topAnchor, constant: -20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
