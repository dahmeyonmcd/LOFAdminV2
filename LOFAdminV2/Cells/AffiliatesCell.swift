//
//  AffiliatesCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class AffiliatesCell: UICollectionViewCell {
    
    let backgroundColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 72/255, green: 76/255, blue: 91/255, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SignalsCard_Background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let affiliateActivityIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.init(red: 126/255, green: 211/255, blue: 33/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AffiliatePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 80
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "SignalsMoreButton_Icon"), for: .normal)
        button.tintColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        button.addTarget(self, action: #selector(handleMoreButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let packageTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Amount Earned"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let joinedTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Status"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.text = "New Affiliate!"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameStringLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let joinedStringLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let packageValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(backgroundColorView)
        backgroundColorView.addSubview(backgroundImageView)
        backgroundColorView.addSubview(affiliateActivityIndicator)
        backgroundColorView.addSubview(userImageView)
        backgroundColorView.addSubview(dateLabel)
        backgroundColorView.addSubview(nameTitleLabel)
        backgroundColorView.addSubview(nameStringLabel)
        backgroundColorView.addSubview(packageTitleLabel)
        backgroundColorView.addSubview(packageValueLabel)
        backgroundColorView.addSubview(joinedTitleLabel)
        backgroundColorView.addSubview(joinedStringLabel)
        backgroundColorView.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            backgroundColorView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundColorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            backgroundColorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            backgroundColorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            backgroundImageView.topAnchor.constraint(equalTo: backgroundColorView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor),
            affiliateActivityIndicator.heightAnchor.constraint(equalToConstant: 25),
            affiliateActivityIndicator.widthAnchor.constraint(equalToConstant: 25),
            affiliateActivityIndicator.topAnchor.constraint(equalTo: backgroundColorView.topAnchor, constant: 20),
            affiliateActivityIndicator.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 20),
            userImageView.heightAnchor.constraint(equalToConstant: 160),
            userImageView.widthAnchor.constraint(equalToConstant: 160),
            userImageView.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -20),
            userImageView.centerYAnchor.constraint(equalTo: backgroundColorView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: affiliateActivityIndicator.trailingAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalToConstant: 25),
            dateLabel.topAnchor.constraint(equalTo: backgroundColorView.topAnchor, constant: 20),
            moreButton.heightAnchor.constraint(equalToConstant: 10),
            moreButton.widthAnchor.constraint(equalToConstant: 40),
            moreButton.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -20),
            moreButton.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -7),
            nameStringLabel.heightAnchor.constraint(equalToConstant: 20),
            nameTitleLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 20),
            nameTitleLabel.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -20),
            nameTitleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            nameTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            nameStringLabel.heightAnchor.constraint(equalToConstant: 20),
            nameStringLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 20),
            nameStringLabel.trailingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: -20),
            nameStringLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            packageTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            packageTitleLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 20),
            packageTitleLabel.trailingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: -20),
            packageTitleLabel.topAnchor.constraint(equalTo: nameStringLabel.bottomAnchor, constant: 20),
            packageValueLabel.heightAnchor.constraint(equalToConstant: 17),
            packageValueLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 20),
            packageValueLabel.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: -20),
            packageValueLabel.topAnchor.constraint(equalTo: packageTitleLabel.bottomAnchor, constant: 8),
            joinedTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            joinedTitleLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 20),
            joinedTitleLabel.trailingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: -20),
            joinedTitleLabel.topAnchor.constraint(equalTo: packageValueLabel.bottomAnchor, constant: 20),
            joinedStringLabel.heightAnchor.constraint(equalToConstant: 17),
            joinedStringLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 20),
            joinedStringLabel.trailingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: -20),
            joinedStringLabel.topAnchor.constraint(equalTo: joinedTitleLabel.bottomAnchor, constant: 8),
            
            
            ])
        
    }
    
    @objc func handleMoreButton() {
        print("More Button Tapped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
