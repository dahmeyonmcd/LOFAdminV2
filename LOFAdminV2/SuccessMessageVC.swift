//
//  SuccessMessageVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/13/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class SuccessMessageVC: UIViewController {
    
    let topSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let messageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SuccessMessage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLOSE", for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4).cgColor
        button.layer.borderWidth = 0.3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
    }
    
    private func setupView() {
        view.addSubview(topSpacer)
        view.addSubview(bottomSpacer)
        view.addSubview(messageImage)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            topSpacer.heightAnchor.constraint(equalToConstant: 50),
            topSpacer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomSpacer.heightAnchor.constraint(equalToConstant: 50),
            bottomSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            messageImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            messageImage.topAnchor.constraint(equalTo: topSpacer.bottomAnchor, constant: 50),
            messageImage.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -60),
            
            closeButton.heightAnchor.constraint(equalToConstant: 60),
            closeButton.widthAnchor.constraint(equalToConstant: 285),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor, constant: -50)
            ])
    }
    
    @objc func dismissView() {
        print("dismissing view")
        let vc = LoginViewThree()
        self.present(vc, animated: true) {
            print("done")
        }
    }
    
}
