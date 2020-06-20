//
//  LoginTextFieldHolder.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginTextFieldHolder: UIView {
    
    let emailField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 10
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.clipsToBounds = true
        textField.placeholder = "Email Address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 10
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        //        textField.clipsToBounds = true
        textField.placeholder = "Email Address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let signInHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        let newColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1).cgColor
        button.layer.borderColor = newColor
        button.layer.borderWidth = 3.5
        button.layer.cornerRadius = 10
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return button
    }()
    
    let signInButtonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    let faceIdButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.setTitle("FaceId", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(faceIDTapped), for: .touchUpInside)
        return button
    }()
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    let logoSplash: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .red
    }
    
    func setupLayout() {
        addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(logoSplash)
        backgroundOverlay.addSubview(signInHolder)
        signInHolder.addSubview(signInButton)
        signInHolder.addSubview(registerButton)
        signInHolder.addSubview(faceIdButton)
        
        
        // setup constraints
        NSLayoutConstraint.activate([
            signInHolder.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor),
            signInHolder.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor),
            signInHolder.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor),
            signInHolder.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor),
            backgroundOverlay.topAnchor.constraint(equalTo: topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoSplash.widthAnchor.constraint(equalToConstant: 300),
            logoSplash.heightAnchor.constraint(equalToConstant: 170),
            logoSplash.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoSplash.centerYAnchor.constraint(equalTo: centerYAnchor),
            signInButton.leadingAnchor.constraint(equalTo: signInHolder.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: signInHolder.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 60),
            signInButton.topAnchor.constraint(equalTo: logoSplash.bottomAnchor, constant: 40),
            registerButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -30),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
            faceIdButton.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 30),
            faceIdButton.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -30),
            faceIdButton.heightAnchor.constraint(equalToConstant: 60),
            faceIdButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func registerTapped() {
        print("Register Tapped")
    }
    
    @objc func faceIDTapped() {
        print("FaceId Tapped")
    }
    @objc func signInTapped() {
        KeychainWrapper.standard.set("1", forKey: "isHidden")
        print("FaceId Tapped")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
                self.alpha = 0
            }) { (finish) in
                self.removeFromSuperview()
            }
        }
    }
    
}
