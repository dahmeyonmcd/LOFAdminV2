//
//  NotificationCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class NotificationCell: UICollectionViewCell {
    
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellIconImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        cellHolder.addSubview(cellBackground)
        cellHolder.addSubview(cellTitleLabel)
        cellHolder.addSubview(cellSwitcher)
        
        // set constraints for views
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cellBackground.topAnchor.constraint(equalTo: cellHolder.topAnchor),
            cellBackground.bottomAnchor.constraint(equalTo: cellHolder.bottomAnchor),
            cellTitleLabel.centerYAnchor.constraint(equalTo: cellHolder.centerYAnchor),
            cellTitleLabel.leadingAnchor.constraint(equalTo: cellHolder.leadingAnchor, constant: 20),
            cellSwitcher.centerYAnchor.constraint(equalTo: cellHolder.centerYAnchor),
            cellSwitcher.trailingAnchor.constraint(equalTo: cellHolder.trailingAnchor, constant: -20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
