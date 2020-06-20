//
//  ShareVV.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Lottie

class HiddenView: UIView {
    
    let clearBackGround: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let lotContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let cardBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = .gray
        button.setImage(UIImage(named: "Close_Icon"), for: .normal)
        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.imageEdgeInsets = InsetView
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    let successImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "HiddenImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        let blurThis = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurThis)
        
        blurView.frame = bounds
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        setupLayout()
        autoClosePage()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    private func setupLayout() {
        addSubview(clearBackGround)
        clearBackGround.addSubview(cardBackground)
        clearBackGround.addSubview(successImage)
        //        cardBackground.addSubview(closeButton)
        //        lotContainer.addSubview(animationView)
        
        
        animationView.play()
        animationView.loopMode = .loop
        
        // setup constraints for views
        NSLayoutConstraint.activate([
            successImage.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 30),
            successImage.bottomAnchor.constraint(equalTo: cardBackground.bottomAnchor, constant: -30),
            successImage.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 30),
            successImage.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -30),
            
            clearBackGround.topAnchor.constraint(equalTo: topAnchor),
            clearBackGround.bottomAnchor.constraint(equalTo: bottomAnchor),
            clearBackGround.trailingAnchor.constraint(equalTo: trailingAnchor),
            clearBackGround.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackground.widthAnchor.constraint(equalToConstant: 170),
            cardBackground.heightAnchor.constraint(equalToConstant: 170),
            cardBackground.centerXAnchor.constraint(equalTo: clearBackGround.centerXAnchor),
            cardBackground.centerYAnchor.constraint(equalTo: clearBackGround.centerYAnchor, constant: -100),
            //            closeButton.heightAnchor.constraint(equalToConstant: 50),
            //            closeButton.widthAnchor.constraint(equalToConstant: 50),
            //            closeButton.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 15),
            //            closeButton.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 15),
            //            lotContainer.heightAnchor.constraint(equalToConstant: 150),
            //            lotContainer.widthAnchor.constraint(equalToConstant: 150),
            //            lotContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            //            lotContainer.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
    
    @objc func closePage() {
        self.removeFromSuperview()
    }
    
    func startAnimating() {
        animationView.loopMode = .loop
        animationView.play()
        
    }
    
    func autoClosePage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
                self.alpha = 0
            }) { (finish) in
                self.removeFromSuperview()
            }
        }
    }
    
}
