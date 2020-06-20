//
//  LoadingAnimation.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/12/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Lottie

class LoadingAnimation: UIView {
    
    let overlayBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        return view
    }()
    
    let loadingHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        view.layer.cornerRadius = 9
        view.clipsToBounds = true
        return view
    }()
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        // setup animation view
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
    }
    
    private func setupLayout() {
        addSubview(loadingHolder)
        addSubview(overlayBackground)
        loadingHolder.addSubview(animationView)
        
        animationView.play()
        animationView.loopMode = .loop
        
        NSLayoutConstraint.activate([
            overlayBackground.topAnchor.constraint(equalTo: topAnchor),
            overlayBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingHolder.heightAnchor.constraint(equalToConstant: 70),
            loadingHolder.widthAnchor.constraint(equalToConstant: 70),
            loadingHolder.centerXAnchor.constraint(equalTo: overlayBackground.centerXAnchor),
            loadingHolder.centerYAnchor.constraint(equalTo: overlayBackground.centerYAnchor),
            animationView.topAnchor.constraint(equalTo: loadingHolder.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: loadingHolder.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: loadingHolder.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: loadingHolder.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
