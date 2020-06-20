//
//  LoginViewThree.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import AVKit

class LoginViewThree: UIViewController {
    
    
    let emailField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 10
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 0.3
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
        textField.layer.borderWidth = 0.3
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
    
//    let signInButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .clear
//        let newColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1).cgColor
//        button.layer.borderColor = newColor
//        button.layer.borderWidth = 3.5
//        button.layer.cornerRadius = 10
//        button.setTitle("Sign In", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(goToSigninVC), for: .touchUpInside)
//        return button
//    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("MEMBER LOGIN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 0
        let newColor = UIColor.white.cgColor
        button.layer.borderColor = newColor
        button.layer.borderWidth = 0.3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        button.addTarget(self, action: #selector(goToSigninVC), for: .touchUpInside)
        return button
    }()
    
    let greetingLabel: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "GreetingLabel")
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 0
        let newColor = UIColor.white.cgColor
        button.layer.borderColor = newColor
        button.layer.borderWidth = 0.3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        button.setTitle("JOIN THE WAITLIST", for: .normal)
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
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 0.7)
        
        return view
    }()
    
    let logoSplash: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LOFLogoWhite")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var player: AVPlayer?
    let videoLink = "BackgroundVideo"
    let videoURL: NSURL = Bundle.main.url(forResource: "BackgroundVideo", withExtension: ".mp4")! as NSURL
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .clear
        fadeViews()
        
        player = AVPlayer(url: videoURL as URL)
        playAudioMix()
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        player?.play()
        
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        setupLayout()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func goToSigninVC() {
        let loginView = LoginVC()
        loginView.modalTransitionStyle = .crossDissolve
        present(loginView, animated: true, completion: nil)
        
    }
    
    func setupView() {
        view.addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(logoSplash)
        backgroundOverlay.addSubview(greetingLabel)
        backgroundOverlay.addSubview(signInButton)
        backgroundOverlay.addSubview(registerButton)
        
        // set up stack view **
        
        
        // set up view
        NSLayoutConstraint.activate([
            backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoSplash.heightAnchor.constraint(equalToConstant: 60),
            logoSplash.widthAnchor.constraint(equalToConstant: 120),
            logoSplash.topAnchor.constraint(equalTo: backgroundOverlay.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoSplash.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 30),
            greetingLabel.topAnchor.constraint(equalTo: logoSplash.bottomAnchor, constant: 0),
            greetingLabel.widthAnchor.constraint(equalToConstant: 250),
            greetingLabel.heightAnchor.constraint(equalToConstant: 130),
            greetingLabel.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 30),
            signInButton.heightAnchor.constraint(equalToConstant: 53),
//            signInButton.widthAnchor.constraint(equalToConstant: 180),
            signInButton.widthAnchor.constraint(equalTo: backgroundOverlay.widthAnchor, multiplier: 0.36),
            signInButton.bottomAnchor.constraint(equalTo: backgroundOverlay.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            signInButton.leadingAnchor.constraint(equalTo: backgroundOverlay.safeAreaLayoutGuide.leadingAnchor, constant: 40),
//            registerButton.widthAnchor.constraint(equalToConstant: 150),
            registerButton.widthAnchor.constraint(equalTo: backgroundOverlay.widthAnchor, multiplier: 0.36),
            registerButton.heightAnchor.constraint(equalToConstant: 53),
            registerButton.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -40),
            registerButton.bottomAnchor.constraint(equalTo: backgroundOverlay.safeAreaLayoutGuide.bottomAnchor, constant: -60)
            ])
        
        
    }
    
    func fadeViews() {
        signInButton.alpha = 0
        greetingLabel.alpha = 0
        registerButton.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 1, animations: {
            self.signInButton.alpha = 1
            self.greetingLabel.alpha = 1
            self.registerButton.alpha = 1
        }) { (finishes) in
            print("finshed")
        }
    }
    
    func setupLayout() {
        view.addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(logoSplash)
        backgroundOverlay.addSubview(signInHolder)
        signInHolder.addSubview(signInButton)
        signInHolder.addSubview(registerButton)
//        signInHolder.addSubview(faceIdButton)
        
        
        // setup constraints
        NSLayoutConstraint.activate([
            signInHolder.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor),
            signInHolder.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor),
            signInHolder.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor),
            signInHolder.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor),
            backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoSplash.widthAnchor.constraint(equalToConstant: 300),
            logoSplash.heightAnchor.constraint(equalToConstant: 170),
            logoSplash.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoSplash.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.leadingAnchor.constraint(equalTo: signInHolder.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: signInHolder.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalTo: signInHolder.heightAnchor, multiplier: 0.07),
            signInButton.topAnchor.constraint(equalTo: logoSplash.bottomAnchor, constant: 40),
            registerButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -30),
            registerButton.heightAnchor.constraint(equalTo: signInHolder.heightAnchor, multiplier: 0.07),
//            faceIdButton.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 30),
//            faceIdButton.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -30),
//            faceIdButton.heightAnchor.constraint(equalToConstant: 60),
//            faceIdButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            
            ])
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    // Code in this block will trigger when OK button tapped
                    print("OK Button Tapped")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func registerTapped() {
        print("Register Tapped")
        
        let cv = NewRegistrationVC()
        cv.modalTransitionStyle = .crossDissolve
        present(cv, animated: true, completion: nil)
        
    }
    
    @objc func faceIDTapped() {
        print("FaceId Tapped")
    }
    
    
    @objc func signInTapped() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
                self.view.alpha = 0
            }) { (finish) in
                self.removeFromParent()
            }
        }
    }
    
    func playAudioMix() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
}
