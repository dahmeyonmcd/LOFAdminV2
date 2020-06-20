//
//  WalkthroughPageOneCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/18/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class WalkthroughPageSevenCell: UICollectionViewCell {
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    let topBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "BuildingBackground")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .clear
        iv.alpha = 1
        return iv
    }()
    
    let messageImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Message7")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.alpha = 1
        return iv
    }()
    
    let firstScrollImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Building1")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        
        iv.alpha = 1
        return iv
    }()
    
    let secondScrollImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Building2")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        
        iv.alpha = 1
        return iv
    }()
    
    let thirdScrollImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.alpha = 0.5
        return iv
    }()
    
    let mainImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Art1")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.alpha = 0
        //        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        //        iv.widthAnchor.constraint(equalToConstant: 230).isActive = true
        return iv
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GET STARTED", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(continueToDashboard), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isSelected = true
        setupLayout()
        fadeImage()
        setupAnimation()
        animateThis()
    }
    
    
    
    func setupAnimation() {
        
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(firstScrollImage)
        stackViewOne.addArrangedSubview(secondScrollImage)
        //        stackViewOne.addArrangedSubview(thirdScrollImage)
        stackViewOne.spacing = -70
        //        stackViewOne.spacing = topView.frame.width * -1
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.distribution = .fillEqually
        stackViewOne.axis = .horizontal
        
        topView.addSubview(topBackgroundImage)
        topView.addSubview(stackViewOne)
        topView.addSubview(mainImage)
        
        stackViewOne.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        stackViewOne.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        stackViewOne.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        stackViewOne.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        topBackgroundImage.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        topBackgroundImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        topBackgroundImage.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        topBackgroundImage.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        
        mainImage.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        mainImage.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -50).isActive = true
        mainImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 50).isActive = true
        mainImage.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -50).isActive = true
        
    }
    
    func fadeImage() {
        mainImage.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.mainImage.alpha = 1
        }) { (_) in
            // set
        }
    }
    
    func setupLayout() {
        addSubview(topView)
        
        addSubview(bottomView)
        bottomView.addSubview(bottomSpacer)
        bottomView.addSubview(messageImage)
        
        
        NSLayoutConstraint.activate([
            messageImage.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
            messageImage.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 45),
            messageImage.bottomAnchor.constraint(equalTo: bottomSpacer.bottomAnchor, constant: -20),
            messageImage.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -45),
            
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
            
            bottomSpacer.heightAnchor.constraint(equalToConstant: 50),
            bottomSpacer.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            
            ])
    }
    
    
    func animateThis() {
        firstScrollImage.transform = CGAffineTransform(translationX: 0, y: 600)
        secondScrollImage.transform = CGAffineTransform(translationX: 0, y: 600)
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.firstScrollImage.transform = CGAffineTransform(translationX: 0, y: 50)
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                self.secondScrollImage.transform = CGAffineTransform(translationX: 0, y: 50)
            }, completion: { (_) in
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                    self.thirdScrollImage.transform = CGAffineTransform(translationX: 0, y: 50)
                }, completion: { (_) in
                    // insert new aimation
                })
            })
        }
    }
    
    @objc func continueToDashboard() {
        print("continuing to dashboard")
        
        // go straight to dashboard
        let dashboardVC = DashboardVC()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = dashboardVC
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
