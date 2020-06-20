//
//  AddressCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class AddressCell: UICollectionViewCell {
    
    let inputViewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textField: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "First Name"
        textView.text = "Berto Delvanicci"
        textView.textAlignment = .left
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let iconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        view.clipsToBounds = true
        return view
    }()
    
    let iconImageView: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: ""), for: .normal)
        view.addTarget(self, action: #selector(pastButtonTapped), for: .touchUpInside)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(inputViewHolder)
        inputViewHolder.addSubview(textField)
        inputViewHolder.addSubview(iconView)
        iconView.addSubview(iconImageView)
        
        //setup constraints for views
        NSLayoutConstraint.activate([
            inputViewHolder.topAnchor.constraint(equalTo: topAnchor),
            inputViewHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            inputViewHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            inputViewHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.topAnchor.constraint(equalTo: inputViewHolder.topAnchor),
            textField.leadingAnchor.constraint(equalTo: inputViewHolder.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: inputViewHolder.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: inputViewHolder.bottomAnchor),
            iconView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    @objc func pastButtonTapped() {
        print("Paste button tapped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
