//
//  AppNotificationCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class AppNotificationCell: UICollectionViewCell {
    
    let cellHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellBackground: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleToFill
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellIconImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellSwitcher: UISwitch = {
        let newSwitch = UISwitch()
        newSwitch.backgroundColor = .clear
        newSwitch.translatesAutoresizingMaskIntoConstraints = false
        newSwitch.onTintColor = UIColor.init(red: 126/255, green: 211/255, blue: 33/255, alpha: 1)
        return newSwitch
    }()
    
    let cellTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let topSpacer: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        
        cellHolder.addSubview(cellTitleLabel)
        cellHolder.addSubview(cellIconImage)
        
        cellHolder.addSubview(bottomSpacer)
        
        // set constraints for views
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            cellTitleLabel.leadingAnchor.constraint(equalTo: cellIconImage.trailingAnchor, constant: 10),
            cellTitleLabel.trailingAnchor.constraint(equalTo: cellHolder.trailingAnchor, constant: -15),
            cellTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            cellTitleLabel.heightAnchor.constraint(equalToConstant: 15),
            
            cellIconImage.heightAnchor.constraint(equalToConstant: 30),
            cellIconImage.widthAnchor.constraint(equalToConstant: 30),
            cellIconImage.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            cellIconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            bottomSpacer.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
