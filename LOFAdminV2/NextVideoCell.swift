//
//  NextVideoCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class NextVideoCell: UICollectionViewCell {
    
    let cellSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.alpha = 0.6
        view.heightAnchor.constraint(equalToConstant: 0.6).isActive = true
        return view
    }()
    
    let videoHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let videoTitleHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Example Video Titles"
        return label
    }()
    
    let videoSubtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        label.text = "Example LEsson"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.cornerRadius = 5
        clipsToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(videoTitleHeader)
        stackViewOne.addArrangedSubview(videoSubtitle)
        stackViewOne.axis = .vertical
        stackViewOne.distribution = .equalSpacing
        stackViewOne.spacing = 5
        
        
        addSubview(cellSpacer)
        addSubview(videoHolder)
        addSubview(stackViewOne)
        
        NSLayoutConstraint.activate([
            cellSpacer.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            videoHolder.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            videoHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            videoHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            videoHolder.widthAnchor.constraint(equalTo: videoHolder.heightAnchor, multiplier: 1.7),
            
            stackViewOne.leadingAnchor.constraint(equalTo: videoHolder.trailingAnchor, constant: 10),
            stackViewOne.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackViewOne.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
