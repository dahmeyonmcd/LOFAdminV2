//
//  ShopPlaceholderVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Lottie


class ShopPlaceholderVC: UIView {
    
    let clearBackGround: UIView = {
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
        return view
    }()
    
    var animationView: AnimationView = AnimationView(name: "success")
    
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let blurThis = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurThis)
        
        blurView.frame = bounds
        animationView.contentMode = .scaleAspectFit
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(clearBackGround)
        clearBackGround.addSubview(cardBackground)
        cardBackground.addSubview(closeButton)
        //        cardBackground.addSubview(animationView)
        
        animationView.play()
        animationView.loopMode = .loop
        
        // setup constraints for views
        NSLayoutConstraint.activate([
            clearBackGround.topAnchor.constraint(equalTo: topAnchor),
            clearBackGround.bottomAnchor.constraint(equalTo: bottomAnchor),
            clearBackGround.trailingAnchor.constraint(equalTo: trailingAnchor),
            clearBackGround.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackground.widthAnchor.constraint(equalToConstant: 300),
            cardBackground.heightAnchor.constraint(equalToConstant: 300),
            cardBackground.centerXAnchor.constraint(equalTo: clearBackGround.centerXAnchor),
            cardBackground.centerYAnchor.constraint(equalTo: clearBackGround.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 15),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closePage() {
        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }
//        self.removeFromSuperview()
        
    }
    
}
