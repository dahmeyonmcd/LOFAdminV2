//
//  SettingViewCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/23/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class SettingViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .left
        label.contentMode = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        return label
    }()
    
    let titleArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CellArrow")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "tableViewCellId")
        
        setupViews()
        backgroundColor = .white
    }
    func setupViews() {
        addSubview(titleLabel)
        addSubview(titleArrow)
        
        // setup layout
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: titleArrow.leadingAnchor, constant: -10),
            titleArrow.heightAnchor.constraint(equalToConstant: 30),
            titleArrow.widthAnchor.constraint(equalToConstant: 30),
            titleArrow.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
            titleArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
