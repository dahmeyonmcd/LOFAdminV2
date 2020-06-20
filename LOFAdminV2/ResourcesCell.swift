//
//  ResourcesCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/16/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class ResourcesCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    let openButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("PDF", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Forex Course"
        return label
    }()
    
    let subheadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.contentMode = .top
        label.textColor = .white
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        label.numberOfLines = 6
        return label
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
