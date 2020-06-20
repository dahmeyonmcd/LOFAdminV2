//
//  LoginVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import AVKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import SwiftHash
import Lottie
import FirebaseFirestore

class LoginVC: UIViewController, UITextFieldDelegate {
    
    let overlayBlur: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
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
        view.backgroundColor = UIColor.black
//        view.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
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
    
    let pageOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        return view
        
    }()
    
    let lotContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let emailField: TextFieldVC = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: TextFieldVC = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.tintColor = .white
        textField.isSecureTextEntry = true
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
        label.text = "Please enter your login credentials"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let logoSplash: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        let newColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        button.layer.borderColor = newColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 0
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tryUserSignin), for: .touchUpInside)
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
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(tryUserSignin), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitle("JOIN THE WAIT-LIST", for: .normal)
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
    
//    var player: AVPlayer?
//    let videoLink = "BackgroundVideo"
//    let videoURL: NSURL = Bundle.main.url(forResource: "BackgroundVideo", withExtension: ".mp4")! as NSURL
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
//        emailField.delegate = self
//        passwordTextField.delegate = self

        setupKeyboardDismissRecognizer()
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
//        setupLogin()
        setupView()
        
    }
    
    func startAnimations() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.play()
        animationView.loopMode = .loop
        
        view.addSubview(pageOverlay)
        pageOverlay.addSubview(lotContainer)
        lotContainer.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            pageOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            pageOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            lotContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lotContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: lotContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: lotContainer.centerYAnchor),
            ])
        
        // MARK: Launch loading function.
        DispatchQueue.main.async {
            
            // execute
            print("dahmeyon's custom loading animation is working :)")
            //
        }
    }
    
    func checkForWalkthrough() {
        
    }
    
    @objc func openFirstLogin() {
        let vc = WelcomeVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
//    func playerItemDidReachEnd() {
//        player!.seek(to: CMTime.zero)
//        player?.play()
//    }
    
    func setupView() {
        //setup blur here
        let blurThis = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurThis)
        blurView.frame = view.bounds
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurView)
        view.addSubview(backgroundImage)
        view.addSubview(overlayBlur)
        
        view.addSubview(logoSplash)
        view.addSubview(loginLabel)
        view.addSubview(emailField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(buttonUnderView)
        view.addSubview(backButton)
        
        
        // setup layout here
        NSLayoutConstraint.activate([
            overlayBlur.topAnchor.constraint(equalTo: view.topAnchor),
            overlayBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            logoSplash.heightAnchor.constraint(equalToConstant: 60),
            logoSplash.widthAnchor.constraint(equalToConstant: 120),
            logoSplash.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoSplash.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            signInButton.heightAnchor.constraint(equalToConstant: 53),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonUnderView.topAnchor.constraint(equalTo: signInButton.bottomAnchor),
            buttonUnderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 53),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            
            emailField.heightAnchor.constraint(equalToConstant: 53),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginLabel.heightAnchor.constraint(equalToConstant: 25),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: logoSplash.bottomAnchor, constant: 30),
            
            backButton.heightAnchor.constraint(equalToConstant: 60),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            ])
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
            self.logoSplash.frame.origin.y += keyboardSize.height
            self.backButton.frame.origin.y += keyboardSize.height
            self.loginLabel.frame.origin.y += keyboardSize.height
            self.emailField.frame.origin.y += keyboardSize.height
            self.passwordTextField.frame.origin.y += keyboardSize.height
            
            // views to move
//            self.signInButton.frame.origin.y += keyboardSize.height
//            self.buttonUnderView.frame.origin.y += keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
            self.logoSplash.frame.origin.y -= keyboardSize.height
            self.backButton.frame.origin.y -= keyboardSize.height
            self.loginLabel.frame.origin.y -= keyboardSize.height
            self.emailField.frame.origin.y -= keyboardSize.height
            self.passwordTextField.frame.origin.y -= keyboardSize.height
            
            // views to move
//            self.signInButton.frame.origin.y += keyboardSize.height
//            self.buttonUnderView.frame.origin.y += keyboardSize.height
        }
    }
    
    func setupLogin() {
        view.addSubview(backgroundOverlay)

        backgroundOverlay.addSubview(loginHolder)
        loginHolder.addSubview(logoSplash)
        loginHolder.addSubview(emailField)
        loginHolder.addSubview(passwordTextField)
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
            emailField.heightAnchor.constraint(equalTo: loginHolder.heightAnchor, multiplier: 0.07),
            emailField.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            emailField.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            emailField.topAnchor.constraint(equalTo: logoSplash.bottomAnchor, constant: 30),
            passwordTextField.heightAnchor.constraint(equalTo: loginHolder.heightAnchor, multiplier: 0.07),
            passwordTextField.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            passwordTextField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            signInButtonTwo.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            signInButtonTwo.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            signInButtonTwo.heightAnchor.constraint(equalTo: loginHolder.heightAnchor, multiplier: 0.07),
            signInButtonTwo.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: loginHolder.safeAreaLayoutGuide.topAnchor, constant: 10)
            
            ])
    }

    
//    @objc func loopVideo() {
//        player?.seek(to: CMTime.zero)
//        player?.play()
//    }
    
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc func newClosed() {
        navigationController?.popViewController(animated: true)
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
    
    @objc func tryUserSignin() {
        dismissKeyboard()
        let userName = emailField.text
        let userPassword = passwordTextField.text
        let mdPass = MD5(userPassword!)
//        checkFields()
        // Check if required fields are not empty
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            // Display alert message here
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            
                displayMessage(userMessage: "One of the required fields is missing")
            return
        }
//        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
//        // position Activity indicator in the center
//        let window = UIApplication.shared.keyWindow!
//        myActivityIndicator.center = window.center
//        myActivityIndicator.hidesWhenStopped = false
//        myActivityIndicator.startAnimating()
//        view.addSubview(myActivityIndicator)
        
        startAnimations()
        
        // Send HTTP Request to perform sign in
        let myUrl = URL(string: "http://api.lionsofforex.com/login/login")
        
        let postString = ["email": userName, "password": mdPass] as! [String: String]
        
        let task = Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    
                    if let Result = json.value(forKey: "error") {
                        
                        self.displayMessage(userMessage: "\(String(describing: Result))")
                        self.pageOverlay.removeFromSuperview()
                        self.animationView.stop()
//                        self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    }
                    else {
                        guard let userId = json.object(forKey: "success") as? NSDictionary else { return }
                        guard let user = userId.object(forKey: "email") as? String else { return }
                        guard let pass = userId.object(forKey: "password") as? String else { return }
                        guard let displayName = userId.object(forKey: "name") as? String else { return }
                        guard let status = userId.object(forKey: "active") as? String else { return }
                        guard let emailStatus = userId.object(forKey: "not_email") as? String else { return }
                        guard let profilePicture = userId.object(forKey: "photo") as? String else { return }
                        guard let packageId = userId.object(forKey: "package") as? String else { return }
                        guard let id = userId.object(forKey: "id") as? String else { return }
                        
                        if let profilePictureURL = URL(string: "https://members.lionsofforex.com/\(profilePicture)"){
                            print(profilePictureURL)
                        }
                        
                        if status == "1" {
                            Firestore.firestore().collection("members").document(id).getDocument { snapshot, err in
                                if let err = err {
                                    // NOT AN ADMIN ERROR
                                    self.displayMessage(userMessage: err.localizedDescription)
                                }else{
                                    if let snapshot = snapshot {
                                        if let value = snapshot.data() {
                                            print(value)
                                            if let adminAuth = value["adminAuthorized"] as? String {
                                                if adminAuth == "admin" {
                                                    // SUCCESS ALLOW
                                                    
                                                    KeychainWrapper.standard.set(user, forKey: "accessToken")
                                                    UserDefaults.standard.set(id, forKey: "TokenID")
                                                    KeychainWrapper.standard.set(pass, forKey: "passToken")
                                                    KeychainWrapper.standard.set(displayName, forKey: "nameToken")
                                                    KeychainWrapper.standard.set(status, forKey: "statusToken")
                                                    KeychainWrapper.standard.set(emailStatus, forKey: "emailStatusToken")
                                                    KeychainWrapper.standard.set(profilePicture, forKey: "profileImageUrl")
                                                    KeychainWrapper.standard.set(packageId, forKey: "currentPlan")
                                                    KeychainWrapper.standard.set(id, forKey: "selectedUserId")
                                                    
                                                    self.passwordTextField.text = ""
                                                    self.emailField.text = ""
                                                    self.pageOverlay.removeFromSuperview()
                                                    self.animationView.stop()
                                                    
                                                    // MARK: Sets isLoggedIn to true
                                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                                    
                                                    self.navigationController?.dismiss(animated: true, completion: nil)
                                                    
                                                }else{
                                                    // NOT AN ADMIN ERROR
                                                    self.passwordTextField.text = ""
//                                                    self.emailField.text = ""
                                                    self.pageOverlay.removeFromSuperview()
                                                    self.displayMessage(userMessage: "User not authorized for admin access.")
                                                }
                                            }else{
                                                self.passwordTextField.text = ""
//                                                self.emailField.text = ""
                                                self.pageOverlay.removeFromSuperview()
                                                self.displayMessage(userMessage: "User not authorized for admin access.")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if status == "0" {
                            self.dismissKeyboard()
                            DispatchQueue.main.async {
                                let unregisteredVC = UnregisteredVC()
                                let mainController = UINavigationController(rootViewController: unregisteredVC)
                                mainController.isNavigationBarHidden = true
                                
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window??.rootViewController = mainController
                            }
                            self.pageOverlay.removeFromSuperview()
                            self.animationView.stop()
                            
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
    

    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
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
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.dismissKeyboard()
//        tryUserSignin()
//        return false
//    }
    
    @objc func closeVC() {
        navigationController?.popViewController(animated: true)
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
    
//    @objc func checkFields() {
//        if (emailField.text?.isEmpty)! {
//            emailField.layer.borderColor = UIColor.red.cgColor
//        }
//        if (passwordTextField.text?.isEmpty)! {
//            passwordTextField.layer.borderColor = UIColor.red.cgColor
//        }
//    }
    
    @objc func registerTapped() {
        print("Register Tapped")
    }
    
    @objc func faceIDTapped() {
        print("FaceId Tapped")
    }
}
