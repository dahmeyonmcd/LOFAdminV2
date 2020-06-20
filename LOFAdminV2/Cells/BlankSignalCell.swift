//
//  BlankSignalCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/6/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class BlankSignalCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        view.clipsToBounds = true
        return view
    }()
    
    let datePlaceholder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.alpha = 0.8
        view.clipsToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    let imagePlaceholder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.alpha = 0.8
        view.clipsToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    let labelOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.alpha = 0.8
        view.clipsToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    let labelTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.alpha = 0.8
        view.clipsToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    let labelThree: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.alpha = 0.8
        view.clipsToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    let labelFour: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.alpha = 0.8
        view.clipsToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
        
    }
    
    func setupView() {
        addSubview(containerView)
        containerView.addSubview(datePlaceholder)
        containerView.addSubview(imagePlaceholder)
        containerView.addSubview(labelOne)
        containerView.addSubview(labelTwo)
        containerView.addSubview(labelThree)
        containerView.addSubview(labelFour)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            datePlaceholder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            datePlaceholder.heightAnchor.constraint(equalToConstant: 25),
            datePlaceholder.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            datePlaceholder.widthAnchor.constraint(equalToConstant: 80),
            imagePlaceholder.heightAnchor.constraint(equalToConstant: 130),
            imagePlaceholder.widthAnchor.constraint(equalToConstant: 150),
            imagePlaceholder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            imagePlaceholder.topAnchor.constraint(equalTo: datePlaceholder.bottomAnchor, constant: 30),
            labelOne.heightAnchor.constraint(equalToConstant: 25),
            labelOne.leadingAnchor.constraint(equalTo: imagePlaceholder.trailingAnchor, constant: 50),
            labelOne.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            labelOne.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            labelTwo.heightAnchor.constraint(equalToConstant: 25),
            labelTwo.leadingAnchor.constraint(equalTo: imagePlaceholder.trailingAnchor, constant: 50),
            labelTwo.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            labelTwo.topAnchor.constraint(equalTo: labelOne.bottomAnchor, constant: 20),
            labelThree.heightAnchor.constraint(equalToConstant: 25),
            labelThree.leadingAnchor.constraint(equalTo: imagePlaceholder.trailingAnchor, constant: 50),
            labelThree.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            labelThree.topAnchor.constraint(equalTo: labelTwo.bottomAnchor, constant: 20),
            labelFour.heightAnchor.constraint(equalToConstant: 25),
            labelFour.leadingAnchor.constraint(equalTo: imagePlaceholder.trailingAnchor, constant: 50),
            labelFour.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            labelFour.topAnchor.constraint(equalTo: labelThree.bottomAnchor, constant: 20),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
