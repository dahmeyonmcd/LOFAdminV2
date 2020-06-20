//
//  IndividualEducationCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class IndividualEducationCell: UICollectionViewCell {
    
    let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let subheadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "LessonCardImage")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let enterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 2)
        button.setImage(UIImage(named: "EnterButton"), for: .normal)
        button.tintColor = UIColor.init(red: 87/255, green: 213/255, blue: 233/255, alpha: 1)
        return button
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 5
        
        
        setupView()
    }
    
    func setupView() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.axis = .vertical
        stackViewOne.alignment = .leading
        stackViewOne.spacing = 20
        stackViewOne.distribution = .equalSpacing
        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.addArrangedSubview(subheadingLabel)
        
        addSubview(contentContainer)
        contentContainer.addSubview(backgroundImage)
        contentContainer.addSubview(stackViewOne)
        addSubview(enterButton)
        
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            backgroundImage.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            
            stackViewOne.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 30),
            stackViewOne.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 30),
            stackViewOne.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -30),
//            stackViewOne.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -30)
            
            enterButton.heightAnchor.constraint(equalToConstant: 35),
            enterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            enterButton.widthAnchor.constraint(equalToConstant: 80),
            enterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
