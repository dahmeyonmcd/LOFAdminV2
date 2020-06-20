//
//  LessonsCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class LessonsCell: UICollectionViewCell {
    
    let tabHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    let tabDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.contentMode = .topLeft
        label.numberOfLines = 0
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
        tabHolder.addSubview(tabTitle)
        tabHolder.addSubview(tabDescription)
        
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
            tabTitle.heightAnchor.constraint(equalToConstant: 30),
            tabTitle.topAnchor.constraint(equalTo: tabHolder.topAnchor, constant: 20),
            tabTitle.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor, constant: 20),
            tabTitle.trailingAnchor.constraint(equalTo: tabHolder.trailingAnchor, constant: -20),
            tabDescription.heightAnchor.constraint(equalToConstant: 50),
            tabDescription.topAnchor.constraint(equalTo: tabTitle.bottomAnchor, constant: 5),
            tabDescription.leadingAnchor.constraint(equalTo: tabHolder.leadingAnchor, constant: 20),
            tabDescription.trailingAnchor.constraint(equalTo: tabHolder.trailingAnchor, constant: -20),
            ])
        
    }
    
}
