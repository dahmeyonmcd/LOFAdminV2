//
//  UpdateCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/17/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class UpdateCell: UICollectionViewCell {
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 72/255, green: 76/255, blue: 91/255, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let signalActivityIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.5
        view.layer.masksToBounds = true
//        view.backgroundColor = UIColor.init(red: 126/255, green: 211/255, blue: 33/255, alpha: 1)
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.text = "New Update!"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.text = "-"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UpdateCard")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupView()
    }
    
    func setupView() {
        addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(backgroundImageView)
        backgroundOverlay.addSubview(signalActivityIndicator)
        backgroundOverlay.addSubview(alertLabel)
        backgroundOverlay.addSubview(aboutLabel)
        backgroundOverlay.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            backgroundOverlay.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundOverlay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            backgroundOverlay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            backgroundOverlay.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            
            backgroundImageView.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor),
            
            signalActivityIndicator.heightAnchor.constraint(equalToConstant: 25),
            signalActivityIndicator.widthAnchor.constraint(equalToConstant: 25),
            signalActivityIndicator.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor, constant: 15),
            signalActivityIndicator.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 20),
            
            alertLabel.leadingAnchor.constraint(equalTo: signalActivityIndicator.trailingAnchor, constant: 10),
            alertLabel.heightAnchor.constraint(equalToConstant: 25),
            alertLabel.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor, constant: 15),
            
            aboutLabel.topAnchor.constraint(equalTo: alertLabel.bottomAnchor, constant: 10),
            aboutLabel.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 20),
            aboutLabel.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -20),
            aboutLabel.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor, constant: -20),
            
            typeLabel.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -20),
            typeLabel.heightAnchor.constraint(equalToConstant: 25),
            typeLabel.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor, constant: 15),            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
