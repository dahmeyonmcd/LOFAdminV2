//
//  WalkthroughPageFourView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/18/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class WalkthroughPageFourView: UIView {
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    let firstScrollImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .blue
        iv.alpha = 0.5
        return iv
    }()
    
    let secondScrollImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .yellow
        iv.alpha = 0.5
        return iv
    }()
    
    let thirdScrollImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .green
        iv.alpha = 0.5
        return iv
    }()
    
    let mainImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .red
        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 210).isActive = true
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
        
        setupLayout()
        setupAnimation()
        animateThis()
    }
    
    override func didMoveToSuperview() {
        animateThis()
    }
    
    override func didMoveToWindow() {
        animateThis()
    }
    
    func setupAnimation() {
        
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(firstScrollImage)
        stackViewOne.addArrangedSubview(secondScrollImage)
        stackViewOne.addArrangedSubview(thirdScrollImage)
        stackViewOne.spacing = -100
//        stackViewOne.spacing = topView.frame.width * -1
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.distribution = .fillEqually
        stackViewOne.axis = .horizontal
        
//        firstScrollImage.widthAnchor.constraint(equalToConstant:100).isActive = true
//        firstScrollImage.heightAnchor.constraint(equalToConstant:100).isActive = true
//
//        secondScrollImage.widthAnchor.constraint(equalToConstant:100).isActive = true
//        secondScrollImage.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        topView.addSubview(stackViewOne)
        
        stackViewOne.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        stackViewOne.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        stackViewOne.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        stackViewOne.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        
        
        
    }
    
    func setupLayout() {
        addSubview(topView)
        topView.addSubview(mainImage)
        addSubview(bottomView)
        bottomView.addSubview(bottomSpacer)
        bottomView.addSubview(continueButton)

        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 55),
            continueButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor, constant: -30),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mainImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            mainImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            bottomSpacer.heightAnchor.constraint(equalToConstant: 50),
            bottomSpacer.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            
            ])
    }
    
    func animateThis() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.firstScrollImage.transform = CGAffineTransform(translationX: 0, y: -100)
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                self.secondScrollImage.transform = CGAffineTransform(translationX: 0, y: -100)
            }, completion: { (_) in
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                    self.thirdScrollImage.transform = CGAffineTransform(translationX: 0, y: -100)
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
