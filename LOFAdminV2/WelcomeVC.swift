//
//  WelcomeVC.swift
//  PersonalAppTemplate
//
//  Created by Roy Taylor on 3/13/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "lauchscreen")
//        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("LOG IN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(removeViews), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 290).isActive = true
        return button
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "mainLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return imageView
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .right
        label.backgroundColor = .clear
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 168).isActive = true
        label.text = "Forgot your password?,"
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.setTitle("Click here", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        revealViews()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        revealViews()
    }
    
    private func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(backgroundOverlay)
//        backgroundOverlay.addSubview(logoImageView)
        
//        view.addSubview(signUpButton)
//        view.addSubview(loginLabel)
//        view.addSubview(loginButton)
        
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(loginLabel)
        stackViewOne.addArrangedSubview(loginButton)
        stackViewOne.distribution = .equalSpacing
        stackViewOne.axis = .horizontal
        stackViewOne.alignment = .center
        stackViewOne.spacing = 0
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false

        
        let stackViewTwo = UIStackView()
        stackViewTwo.addArrangedSubview(logoImageView)
        stackViewTwo.addArrangedSubview(signUpButton)
        stackViewTwo.addArrangedSubview(stackViewOne)
        stackViewTwo.distribution = .equalSpacing
        stackViewTwo.axis = .vertical
        stackViewTwo.alignment = .center
        stackViewTwo.spacing = 20
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundOverlay.addSubview(stackViewTwo)
        
        
        
        // setup views layout
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackViewTwo.centerXAnchor.constraint(equalTo: backgroundOverlay.centerXAnchor),
            stackViewTwo.centerYAnchor.constraint(equalTo: backgroundOverlay.centerYAnchor)
            ])
        
    }
    
    @objc func signinButtonTapped() {
        print("Sign In Tapped")
        let vc = LoginVC()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func signupButtonTapped() {
        print("Sign Up Tapped")
        let vc = LoginVC()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func removeViews() {
        signUpButton.alpha = 1
        loginLabel.alpha = 1
        loginButton.alpha = 1
        
        self.signupButtonTapped()
        
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//            self.signUpButton.alpha = 0
//            self.loginButton.alpha = 0
//            self.loginLabel.alpha = 0
//        }) { (finishes) in
//            DispatchQueue.main.async {
//                self.signupButtonTapped()
//            }
//        }
        
    }
    
    func revealViews() {
        signUpButton.alpha = 0
        loginLabel.alpha = 0
        loginButton.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.signUpButton.alpha = 1
            self.loginButton.alpha = 1
            self.loginLabel.alpha = 1
        }) { (finishes) in
            DispatchQueue.main.async {
                print("items revealed")
            }
        }
    }
    
    
}
