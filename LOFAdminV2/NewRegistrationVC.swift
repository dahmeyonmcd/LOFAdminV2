//
//  NewRegistrationVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/12/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import AVKit
import SwiftyJSON
import Alamofire
import SwiftHash
import SwiftKeychainWrapper

class NewRegistrationVC: UIViewController, UITextFieldDelegate {
    
    let overlayBlur: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let registrationScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        
        return scroll
    }()
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonUnderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        return view
    }()
    
    let backgroundOverlayMain: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signInHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    let nameField: TextFieldVC = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        textField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextField: TextFieldVC = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let locationTextField: TextFieldVC = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Country", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Registration is currently closed. \nApply below to get accepted!"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let logoSplash: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LOFLogoWhite")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        let newColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1).cgColor
        button.layer.borderColor = newColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 0
        button.setTitle("JOIN THE WAITLIST", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addedToList), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "CloseButton"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 22
        return button
    }()
    
    let signInButtonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.isEnabled = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.layer.cornerRadius = 10
        button.setTitle("Regigster", for: .normal)
        button.addTarget(self, action: #selector(addedToList), for: .touchUpInside)
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
    
    var player: AVPlayer?
    let videoLink = "BackgroundVideo"
    let videoURL: NSURL = Bundle.main.url(forResource: "BackgroundVideo", withExtension: ".mp4")! as NSURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        setupKeyboardDismissRecognizer()
        nameField.delegate = self
        emailTextField.delegate = self
        locationTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        //        setupLogin()
        setupView()
        
    }
    
    @objc func openFirstLogin() {
        let vc = LoginViewThree()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func playerItemDidReachEnd() {
        player!.seek(to: CMTime.zero)
        player?.play()
    }
    
    func setupView() {
        //setup blur here
        let blurThis = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurThis)
        blurView.frame = view.bounds
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurView)
        view.addSubview(overlayBlur)
        overlayBlur.addSubview(logoSplash)
        overlayBlur.addSubview(loginLabel)
        overlayBlur.addSubview(nameField)
        overlayBlur.addSubview(emailTextField)
        overlayBlur.addSubview(locationTextField)
        overlayBlur.addSubview(signInButton)
        overlayBlur.addSubview(buttonUnderView)
        overlayBlur.addSubview(backButton)
        
        
        // setup layout here
        NSLayoutConstraint.activate([
            overlayBlur.topAnchor.constraint(equalTo: view.topAnchor),
            overlayBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoSplash.heightAnchor.constraint(equalToConstant: 60),
            logoSplash.widthAnchor.constraint(equalToConstant: 120),
            logoSplash.topAnchor.constraint(equalTo: overlayBlur.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoSplash.leadingAnchor.constraint(equalTo: overlayBlur.leadingAnchor, constant: 30),
            signInButton.heightAnchor.constraint(equalToConstant: 53),
            signInButton.leadingAnchor.constraint(equalTo: overlayBlur.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: overlayBlur.trailingAnchor),
            signInButton.bottomAnchor.constraint(equalTo: overlayBlur.safeAreaLayoutGuide.bottomAnchor),
            signInButton.centerXAnchor.constraint(equalTo: overlayBlur.centerXAnchor),
            buttonUnderView.topAnchor.constraint(equalTo: signInButton.bottomAnchor),
            buttonUnderView.bottomAnchor.constraint(equalTo: overlayBlur.bottomAnchor),
            buttonUnderView.leadingAnchor.constraint(equalTo: overlayBlur.leadingAnchor),
            buttonUnderView.trailingAnchor.constraint(equalTo: overlayBlur.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 53),
            emailTextField.leadingAnchor.constraint(equalTo: overlayBlur.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: overlayBlur.trailingAnchor, constant: -40),
            emailTextField.centerXAnchor.constraint(equalTo: overlayBlur.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            nameField.heightAnchor.constraint(equalToConstant: 53),
            nameField.leadingAnchor.constraint(equalTo: overlayBlur.leadingAnchor, constant: 40),
            nameField.trailingAnchor.constraint(equalTo: overlayBlur.trailingAnchor, constant: -40),
            nameField.centerXAnchor.constraint(equalTo: overlayBlur.centerXAnchor),
            nameField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            loginLabel.leadingAnchor.constraint(equalTo: overlayBlur.leadingAnchor, constant: 40),
            loginLabel.trailingAnchor.constraint(equalTo: overlayBlur.trailingAnchor, constant: -40),
            loginLabel.heightAnchor.constraint(equalToConstant: 50),
            loginLabel.centerXAnchor.constraint(equalTo: overlayBlur.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: logoSplash.bottomAnchor, constant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 60),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.trailingAnchor.constraint(equalTo: overlayBlur.trailingAnchor, constant: -40),
            backButton.topAnchor.constraint(equalTo: overlayBlur.safeAreaLayoutGuide.topAnchor, constant: 40),
            locationTextField.heightAnchor.constraint(equalToConstant: 53),
            locationTextField.leadingAnchor.constraint(equalTo: overlayBlur.leadingAnchor, constant: 40),
            locationTextField.trailingAnchor.constraint(equalTo: overlayBlur.trailingAnchor, constant: -40),
            locationTextField.centerXAnchor.constraint(equalTo: overlayBlur.centerXAnchor),
            locationTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        addedToList()
        return false
    }
    
    func setupLogin() {
        view.addSubview(backgroundOverlay)
        
        backgroundOverlay.addSubview(loginHolder)
        loginHolder.addSubview(logoSplash)
        loginHolder.addSubview(nameField)
        loginHolder.addSubview(emailTextField)
        loginHolder.addSubview(signInButtonTwo)
        loginHolder.addSubview(backButton)
        
        // add constraints
        NSLayoutConstraint.activate([
            backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoSplash.widthAnchor.constraint(equalToConstant: 300),
            logoSplash.heightAnchor.constraint(equalToConstant: 170),
            logoSplash.centerXAnchor.constraint(equalTo: loginHolder.centerXAnchor),
            logoSplash.centerYAnchor.constraint(equalTo: loginHolder.centerYAnchor),
            loginHolder.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor),
            loginHolder.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor),
            loginHolder.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor),
            loginHolder.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor),
            nameField.heightAnchor.constraint(equalTo: loginHolder.heightAnchor, multiplier: 0.07),
            nameField.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            nameField.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            nameField.topAnchor.constraint(equalTo: logoSplash.bottomAnchor, constant: 30),
            emailTextField.heightAnchor.constraint(equalTo: loginHolder.heightAnchor, multiplier: 0.07),
            emailTextField.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            emailTextField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            signInButtonTwo.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            signInButtonTwo.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            signInButtonTwo.heightAnchor.constraint(equalTo: loginHolder.heightAnchor, multiplier: 0.07),
            signInButtonTwo.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: loginHolder.safeAreaLayoutGuide.topAnchor, constant: 10)
            
            ])
    }
    
    
    @objc func loopVideo() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    func setupLayout() {
        view.addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(signInHolder)
        backgroundOverlay.addSubview(logoSplash)
        signInHolder.addSubview(signInButton)
        signInHolder.addSubview(registerButton)
        signInHolder.addSubview(faceIdButton)
        
        
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
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    // Code in this block will trigger when OK button tapped
                    print("OK Button Tapped")
                    DispatchQueue.main.async {
                        alertController.dismiss(animated: true, completion: nil)
//                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func shopLoginButtons() {
        let window = UIApplication.shared.keyWindow
        let v = UIView(frame: (window?.bounds)!)
        v.backgroundColor = .clear
        let v2 = MainSignInVC(frame: (window?.bounds)!)
        v2.backgroundColor = .clear
        self.backgroundOverlay.addSubview(v2)
        
        
        v2.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    @objc func newOpen() {
        let vc = LoginViewTwo()
        addChild(vc)
        
        view.addSubview(vc.view)
        
        vc.view.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor).isActive = true
        vc.didMove(toParent: self)
    }
    
    @objc func goToSigninVC() {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func newClose() {
        let vc = LoginViewTwo()
        let newvc = LoginViewThree()
        vc.removeFromParent()
        addChild(newvc)
        
        view.addSubview(newvc.view)
        
        newvc.view.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor).isActive = true
        newvc.view.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor).isActive = true
        newvc.view.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor).isActive = true
        newvc.view.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor).isActive = true
        newvc.didMove(toParent: self)
    }
    
    @objc func newClosed() {
        let vc = LoginViewTwo()
        let newvc = LoginViewThree()
        newvc.removeFromParent()
        addChild(vc)
        
        view.addSubview(newvc.view)
        
        vc.view.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor).isActive = true
        vc.didMove(toParent: self)
    }
    
    func showBackButton() {
        let window = UIApplication.shared.keyWindow
        let v = UIView(frame: (window?.bounds)!)
        v.backgroundColor = .clear
        let shapeNew = CGRect(x: 0, y: 0, width: 100, height: 100)
        let v2 = BackButtonView(frame: (shapeNew))
        v2.backgroundColor = .clear
        self.backgroundOverlay.addSubview(v2)
        v2.addSubview(backButton)
        
        
        v2.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        v2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        v2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.topAnchor.constraint(equalTo: v2.topAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: v2.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: v2.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: v2.trailingAnchor).isActive = true
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    @objc func tryRegistration() {
        dismissKeyboard()
        let userName = nameField.text
        let email = emailTextField.text
        let country = locationTextField.text
        
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        // position Activity indicator in the center
        let window = UIApplication.shared.keyWindow!
        myActivityIndicator.center = window.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        // Send HTTP Request to perform sign in
        let myUrl = URL(string: "http://api.lionsofforex.com/registration/waiting-list")
        
        let postString = ["name": userName, "email": email, "forexExperience": country] as! [String: String]
        
        let task = Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    
                    if let Result = json.value(forKey: "error") {
                        self.displayMessage(userMessage: "\(String(describing: Result))")
                        print(Result)
                        
                    }
                    else {
                        let userId = json.value(forKey: "success")
                        print(userId!)
                        DispatchQueue.main.async {
                            let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
                            // position Activity indicator in the center
                            let window = UIApplication.shared.keyWindow!
                            myActivityIndicator.center = window.center
                            myActivityIndicator.hidesWhenStopped = false
                            myActivityIndicator.startAnimating()
                            self.view.addSubview(myActivityIndicator)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0 ) {
                                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                                    print("0")
                                }) { (finish) in
                                    let vc = SuccessMessageVC()
                                    vc.modalTransitionStyle = .crossDissolve
                                    self.present(vc, animated: true, completion: nil)
                                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                                }
                            }
                        }
                    }
                    
                    
                }
        }
        task.resume()
    }
    
    @objc func shopMainButtons() {
        print("it works!")
        let vc = MainSignInVC()
        vc.removeThisJunk()
        vc.alpha = 0.0
        
        vc.removeFromSuperview()
        let window = UIApplication.shared.keyWindow
        let v = UIView(frame: (window?.bounds)!)
        v.backgroundColor = .clear
        let v2 = LoginTextFieldHolder(frame: (window?.bounds)!)
        v2.backgroundColor = .clear
        self.backgroundOverlay.addSubview(v2)
        
        
        v2.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        
        //        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
        //            vc.alpha = 0
        //        }) { (finish) in
        //            vc.removeFromSuperview()
        //            let window = UIApplication.shared.keyWindow
        //            let v = UIView(frame: (window?.bounds)!)
        //            v.backgroundColor = .clear
        //            let v2 = LoginTextFieldHolder(frame: (window?.bounds)!)
        //            v2.backgroundColor = .clear
        //            self.backgroundOverlay.addSubview(v2)
        //
        //
        //            v2.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        //            v2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        //            v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        //            v2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        ////
        ////        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    @objc func showLogin() {
        print("Sign In Tapped")
        let window = UIApplication.shared.keyWindow
        let v = MainSignInVC(frame: (window?.bounds)!)
        v.backgroundColor = .clear
        let v2 = signInHolder
        v2.backgroundColor = .clear
        v.alpha = 1.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            v.removeFromSuperview()
        }) { (finish) in
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                self.backgroundOverlay.addSubview(v2)
                v2.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                v2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                v2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                
            }, completion: { (finish) in
                UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                    
                    
                    
                    
                    v2.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                    v2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                    v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                    v2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                    
                }, completion: { (finish) in
                    UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                        
                    }, completion: nil)
                })
            })
        }
        
    }
    
    @objc func closeVC() {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
        
        // present view controller
    }
    
    
    
    @objc func signInTapped() {
        print("Sign In Tapped")
        let viewToRemove = self.signInHolder
        viewToRemove.alpha = 1.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            viewToRemove.frame = CGRect(x: viewToRemove.frame.origin.x, y: 2000, width: viewToRemove.frame.width, height: viewToRemove.frame.height)
            
            viewToRemove.alpha = 1.0
        }) { (finish) in
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                viewToRemove.alpha = 0.0
                viewToRemove.transform = CGAffineTransform(translationX: 0, y: 0)
                viewToRemove.removeFromSuperview()
                
                
            }, completion: { (finish) in
                UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                    let window = UIApplication.shared.keyWindow
                    let v = UIView(frame: (window?.bounds)!)
                    v.backgroundColor = .clear
                    let v2 = MainSignInVC(frame: (window?.bounds)!)
                    v2.backgroundColor = .clear
                    self.backgroundOverlay.addSubview(v2)
                    
                    
                    v2.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                    v2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                    v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                    v2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                    
                }, completion: { (finish) in
                    UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                        
                    }, completion: nil)
                })
            })
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
    
    @objc func registerTapped() {
        print("Register Tapped")
    }
    
    @objc func faceIDTapped() {
        print("FaceId Tapped")
    }
    
    
    // check all fields
    @objc func checkFields() {
        if (nameField.text?.isEmpty)! {
            nameField.layer.borderColor = UIColor.red.cgColor
        }
        if (locationTextField.text?.isEmpty)! {
            locationTextField.layer.borderColor = UIColor.red.cgColor
        }
        if (emailTextField.text?.isEmpty)! {
            emailTextField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @objc func addedToList() {
        print("added to list")
        if (nameField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (locationTextField.text?.isEmpty)! {
            checkFields()
            displayMessage(userMessage: "One or more of the required fields is missing")
        }else{
            tryRegistration()
            
            
//            displayMessage(userMessage: "You have been sucessfully added to the waitlist. You will receive a response within 48 hours.")
        }
    }
}
