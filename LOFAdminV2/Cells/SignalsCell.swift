//
//  SignalsCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class SignalsCell: UICollectionViewCell {
    
    let backgroundColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 72/255, green: 76/255, blue: 91/255, alpha: 1)
        view.layer.cornerRadius = 5
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true // 240
        view.layer.masksToBounds = true
        return view
    }()
    
    let updateHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 5
//        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.layer.masksToBounds = true
        return view
    }()
    
    let firstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
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
    
    let signalActivityIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.init(red: 126/255, green: 211/255, blue: 33/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    let signalsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "EURUSD")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    let tradeTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "TYPE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let entryTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "ENTRY"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let updateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.init(name: "GorditaBlack", size: 16)
        label.text = "UPDATE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let updateAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.font = UIFont.init(name: "GorditaBold", size: 11)
        label.textAlignment = .left
        label.textColor = UIColor.init(red: 150/255, green: 158/255, blue: 181/255, alpha: 1)
        label.numberOfLines = 0
        label.text = "---"
        return label
    }()
    
    let clickLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.font = UIFont.init(name: "GorditaBold", size: 11)
        label.textAlignment = .left
        label.textColor = UIColor.init(red: 150/255, green: 158/255, blue: 181/255, alpha: 1)
        label.numberOfLines = 0
        label.text = "---"
        return label
    }()
    
    let tradeStyleTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "TRADE STYLE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpOneTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "TP 1"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpTwoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "TP 2"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let newPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.contentMode = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "S/L"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.text = "March 11"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tradeTypeAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Closed 20 Pips"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tradeStyleAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpAmountOneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpAmountTwoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let entryAmountTwoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        setupLayout()
    }
    
    func setupLayout() {
        let updateStackView = UIStackView()
        updateStackView.addArrangedSubview(updateTitleLabel)
        updateStackView.addArrangedSubview(updateAmountLabel)
        updateStackView.axis = .vertical
        updateStackView.alignment = .leading
        updateStackView.spacing = 4
        updateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let styleStackView = UIStackView()
        styleStackView.addArrangedSubview(tradeStyleTitleLabel)
        styleStackView.addArrangedSubview(tradeStyleAmountLabel)
        styleStackView.axis = .vertical
        styleStackView.alignment = .leading
        styleStackView.spacing = 2
        styleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tpStackView = UIStackView()
        tpStackView.addArrangedSubview(tpOneTitleLabel)
        tpStackView.addArrangedSubview(tpAmountOneLabel)
        tpStackView.axis = .vertical
        tpStackView.alignment = .leading
        tpStackView.spacing = 2
        tpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tpTwoStackView = UIStackView()
        tpTwoStackView.addArrangedSubview(tpTwoTitleLabel)
        tpTwoStackView.addArrangedSubview(tpAmountTwoLabel)
        tpTwoStackView.axis = .vertical
        tpTwoStackView.alignment = .leading
        tpTwoStackView.spacing = 2
        tpTwoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let entryStackView = UIStackView()
        entryStackView.addArrangedSubview(entryTitleLabel)
        entryStackView.addArrangedSubview(entryAmountTwoLabel)
        entryStackView.axis = .vertical
        entryStackView.alignment = .leading
        entryStackView.spacing = 2
        entryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let slStackView = UIStackView()
        slStackView.addArrangedSubview(slTitleLabel)
        slStackView.addArrangedSubview(slAmountLabel)
        slStackView.axis = .vertical
        slStackView.alignment = .leading
        slStackView.spacing = 2
        slStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let typeStackView = UIStackView()
        typeStackView.addArrangedSubview(tradeTypeTitleLabel)
        typeStackView.addArrangedSubview(tradeTypeAmountLabel)
        typeStackView.axis = .vertical
        typeStackView.alignment = .leading
        typeStackView.spacing = 2
        typeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let indicatorStackView = UIStackView()
        indicatorStackView.addArrangedSubview(signalActivityIndicator)
        indicatorStackView.addArrangedSubview(dateLabel)
        indicatorStackView.axis = .horizontal
        indicatorStackView.alignment = .leading
        indicatorStackView.spacing = 10
        indicatorStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackViewTwo = UIStackView()
        mainStackViewTwo.addArrangedSubview(styleStackView)
        mainStackViewTwo.addArrangedSubview(tpStackView)
        mainStackViewTwo.addArrangedSubview(tpTwoStackView)
        mainStackViewTwo.addArrangedSubview(entryStackView)
        mainStackViewTwo.addArrangedSubview(slStackView)
        mainStackViewTwo.addArrangedSubview(typeStackView)
        mainStackViewTwo.axis = .vertical
        mainStackViewTwo.alignment = .leading
        mainStackViewTwo.spacing = 10
        mainStackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackViewOne = UIStackView()
        mainStackViewOne.addArrangedSubview(indicatorStackView)
        mainStackViewOne.addArrangedSubview(signalsImageView)
        mainStackViewOne.addArrangedSubview(newPipLabel)
        mainStackViewOne.axis = .vertical
        mainStackViewOne.alignment = .leading
        mainStackViewOne.distribution = .fill
        mainStackViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(backgroundColorView)
        
        backgroundColorView.addSubview(backgroundImageView)
        
        backgroundColorView.addSubview(firstView)
        backgroundColorView.addSubview(secondView)
        
        firstView.addSubview(mainStackViewOne)
        secondView.addSubview(mainStackViewTwo)
        
        addSubview(updateHolder)
        updateHolder.addSubview(updateStackView)
        
        NSLayoutConstraint.activate([
            backgroundColorView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundColorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            backgroundColorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            
            backgroundImageView.topAnchor.constraint(equalTo: backgroundColorView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor),
            
            firstView.topAnchor.constraint(equalTo: backgroundColorView.topAnchor),
            firstView.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor),
            firstView.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor),
            firstView.widthAnchor.constraint(equalTo: backgroundColorView.widthAnchor, multiplier: 0.5),
            
            secondView.topAnchor.constraint(equalTo: backgroundColorView.topAnchor),
            secondView.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor),
            secondView.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor),
            secondView.widthAnchor.constraint(equalTo: backgroundColorView.widthAnchor, multiplier: 0.5),
            
            mainStackViewOne.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 15),
            mainStackViewOne.leadingAnchor.constraint(equalTo: firstView.leadingAnchor, constant: 15),
            mainStackViewOne.trailingAnchor.constraint(equalTo: firstView.trailingAnchor, constant: -15),
            mainStackViewOne.bottomAnchor.constraint(equalTo: firstView.bottomAnchor, constant: -15),
            
            mainStackViewTwo.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 15),
            mainStackViewTwo.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 15),
            mainStackViewTwo.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -15),
//            mainStackViewTwo.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -15),
            
            
            updateHolder.topAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: 0),
            updateHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            updateHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            updateHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            
            updateStackView.topAnchor.constraint(equalTo: updateHolder.topAnchor, constant: 20),
//            updateStackView.bottomAnchor.constraint(equalTo: updateHolder.bottomAnchor, constant: -20),
            updateStackView.leadingAnchor.constraint(equalTo: updateHolder.leadingAnchor, constant: 9),
            updateStackView.trailingAnchor.constraint(equalTo: updateHolder.trailingAnchor, constant: -9),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleMoreButton() {
        print("more button tapped")
    }
    
}
