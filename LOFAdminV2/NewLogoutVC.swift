//
//  LogoutVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Lottie
import SwiftKeychainWrapper

class NewLogoutVC: UIViewController {
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let promptLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Are you sure you want to logout?"
        view.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        view.backgroundColor = .clear
        view.contentMode = .center
        return view
    }()
    
    let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        let newCOlor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1).cgColor
        button.layer.borderColor = newCOlor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.layer.borderWidth = 0
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        button.backgroundColor = .white
        let newCOlor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1).cgColor
        button.layer.borderColor = newCOlor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.layer.borderWidth = 3
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.setTitleColor(UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1), for: .normal)
        
        return button
    }()
    
    var animationView: AnimationView = AnimationView(name: "success")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurThis = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurThis)
        
        view.backgroundColor = .clear
        
        blurView.frame = view.bounds
//        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurView)
        
        setupLayout()
    }
    
   
    func setupLayout() {
        view.addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(cardView)
        cardView.addSubview(yesButton)
        cardView.addSubview(noButton)
        cardView.addSubview(promptLabel)
        
        // add constraints here for viws ...
        NSLayoutConstraint.activate([
            backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 100),
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.centerXAnchor.constraint(equalTo: backgroundOverlay.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: backgroundOverlay.centerYAnchor),
            yesButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.4),
            yesButton.heightAnchor.constraint(equalToConstant: 40),
            yesButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -15),
            yesButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            noButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.4),
            noButton.heightAnchor.constraint(equalToConstant: 40),
            noButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -15),
            noButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            promptLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.8),
            promptLabel.heightAnchor.constraint(equalToConstant: 15),
            promptLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            promptLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15)
            ])
    }
    
    @objc func noButtonTapped() {
        print("no tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func yesButtonTapped() {
        print("yes tapped")
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        // position Activity indicator in the center
        let window = UIApplication.shared.keyWindow!
        myActivityIndicator.center = window.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.dismiss(animated: true, completion: nil)
            self.performUserLogout()
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func performUserLogout() {
        print("Logging Out...")
        // present loading overlay
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        let window = UIApplication.shared.keyWindow!
        // position Activity indicator in the center
        myActivityIndicator.center = window.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // remove loading overlay
            
            // execute this code
            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            KeychainWrapper.standard.removeObject(forKey: "accessToken")
            KeychainWrapper.standard.removeObject(forKey: "passToken")
            KeychainWrapper.standard.removeObject(forKey: "nameToken")
            KeychainWrapper.standard.removeObject(forKey: "statusToken")
            KeychainWrapper.standard.removeObject(forKey: "emailStatusToken")
            KeychainWrapper.standard.removeObject(forKey: "selectedCourse")
            KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
            KeychainWrapper.standard.removeObject(forKey: "selectedCourseName")
            KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
            KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
            KeychainWrapper.standard.removeObject(forKey: "profileImageUrl")
            KeychainWrapper.standard.removeObject(forKey: "numberOfLions")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateDate")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateName")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateCommision")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateVisitors")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateConversion")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateStatus")
            KeychainWrapper.standard.removeObject(forKey: "profileImage")
            KeychainWrapper.standard.removeObject(forKey: "profileImageUrl")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesVisitors")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesEarned")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesVisitors")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesConversion")
            KeychainWrapper.standard.removeObject(forKey: "affiliateLockj")
            KeychainWrapper.standard.removeObject(forKey: "selectedSymbol")
            KeychainWrapper.standard.removeObject(forKey: "selectedType")
            KeychainWrapper.standard.removeObject(forKey: "selectedSignalDate")
            KeychainWrapper.standard.removeObject(forKey: "selectedPips")
            KeychainWrapper.standard.removeObject(forKey: "selectedSL")
            KeychainWrapper.standard.removeObject(forKey: "selectedTP")
            KeychainWrapper.standard.removeObject(forKey: "selectedEntry")
            KeychainWrapper.standard.removeObject(forKey: "currentPackage")
            KeychainWrapper.standard.removeObject(forKey: "lofMembers")
            KeychainWrapper.standard.removeObject(forKey: "selectedUpdate")
            //            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            let loginVC = LoginVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = loginVC
            //        self.present(loginVC, animated: true, completion: nil)
        }
        
        
    }
    
}
