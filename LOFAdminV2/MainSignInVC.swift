//
//  MainSignInVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON
import SwiftHash

protocol buttonPressedDelegate {
    func buttonPressed() -> Void
}

class MainSignInVC: UIView {
    
    let txtUserName: UITextField = {
        let textView = UITextField()
        return textView
    }()
    
    let txtPassword: UITextField = {
        let textView = UITextField()
        return textView
    }()
    
    let authenticateUser: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(tryUserSignin), for: .touchUpInside)
        return button
    }()
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signInHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Back_Icon"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backToMainLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 22
        return button
    }()
    
    let emailField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 10
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 2
        textField.textColor = .white
        textField.clipsToBounds = true
        textField.placeholder = "Email Address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: TextFieldVC = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 10
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 2
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        //        textField.clipsToBounds = true
        textField.placeholder = "Email Address"
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
    
    let logoSplash: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LOFLogoWhite")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let signInButtonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tryUserSignin), for: .touchUpInside)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setupKeyboardDismissRecognizer()
        setupLogin()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
//    func displayMessage(userMessage:String) -> Void {
//        DispatchQueue.main.async
//            {
//                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
//                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//                    let swipingVC = LoginVC()
//
//                    // Code in this block will trigger when OK button tapped
//                    print("OK Button Tapped")
//                    DispatchQueue.main.async {
//                        swipingVC.dismiss(animated: true, completion: nil)
//                    }
//                }
//                alertController.addAction(OKAction)
//                present(alertController, animated: true, completion: nil)
//        }
//    }
    
    func setupLogin() {
        addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(loginHolder)
        loginHolder.addSubview(spacerView)
        loginHolder.addSubview(emailField)
        loginHolder.addSubview(passwordTextField)
        loginHolder.addSubview(signInButtonTwo)
//        loginHolder.addSubview(backButton)
        
        // add constraints
        NSLayoutConstraint.activate([
            backgroundOverlay.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            spacerView.widthAnchor.constraint(equalToConstant: 300),
            spacerView.heightAnchor.constraint(equalToConstant: 170),
            spacerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spacerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loginHolder.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor),
            loginHolder.bottomAnchor.constraint(equalTo: backgroundOverlay.bottomAnchor),
            loginHolder.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor),
            loginHolder.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 60),
            emailField.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            emailField.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            emailField.topAnchor.constraint(equalTo: spacerView.bottomAnchor, constant: 30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            passwordTextField.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            passwordTextField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            signInButtonTwo.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 30),
            signInButtonTwo.trailingAnchor.constraint(equalTo: loginHolder.trailingAnchor, constant: -30),
            signInButtonTwo.heightAnchor.constraint(equalToConstant: 60),
            signInButtonTwo.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
//            backButton.heightAnchor.constraint(equalToConstant: 50),
//            backButton.widthAnchor.constraint(equalToConstant: 50),
//            backButton.leadingAnchor.constraint(equalTo: loginHolder.leadingAnchor, constant: 20),
//            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20)
            
            ])
    }
    
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    @objc func faceIDTapped() {
        print("face id tapped")
    }
    
    public func removeThisJunk() {
        self.removeFromSuperview()
    }
    
    @objc func backToMainLogin() {
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
            
            
        }
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.frame.origin.y == 0 {
                self.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
        }
    }
    
    @objc func tryUserSignin() {
        dismissKeyboard()
        let userName = emailField.text
        let userPassword = passwordTextField.text
        let mdPass = MD5(userPassword!)
        
        // Check if required fields are not empty
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            // Display alert message here
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            
//            displayMessage(userMessage: "One of the required fields is missing")
            return
        }
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        // position Activity indicator in the center
        myActivityIndicator.center = center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        addSubview(myActivityIndicator)
        
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
//                        self.displayMessage(userMessage: "\(String(describing: Result))")
                        print(Result)
                        
                    }
                    else {
                        let userId = json.object(forKey: "success") as! NSDictionary
                        let user = userId.object(forKey: "email") as! String
                        let pass = userId.object(forKey: "password") as! String
                        let displayName = userId.object(forKey: "name") as! String
                        let status = userId.object(forKey: "active") as! String
                        let emailStatus = userId.object(forKey: "not_email") as! String
                        let profilePicture = userId.object(forKey: "photo") as! String
                        let packageId = userId.object(forKey: "package") as! String
                        
                        
                        let saveAccessToken: Bool = KeychainWrapper.standard.set(user, forKey: "accessToken")
                        let savePasswordToken: Bool = KeychainWrapper.standard.set(pass, forKey: "passToken")
                        let saveNameToken: Bool = KeychainWrapper.standard.set(displayName, forKey: "nameToken")
                        let saveStatusToken: Bool = KeychainWrapper.standard.set(status, forKey: "statusToken")
                        let saveEmailStatusToken: Bool = KeychainWrapper.standard.set(emailStatus, forKey: "emailStatusToken")
                        let saveProfileImageToken: Bool = KeychainWrapper.standard.set(profilePicture, forKey: "profileImageUrl")
                        let savePackage: Bool = KeychainWrapper.standard.set(packageId, forKey: "currentPlan")
                        
                        print("the access token save result is: \(saveAccessToken)")
                        print("the password token save result is: \(savePasswordToken)")
                        print("the name token save result is: \(saveNameToken)")
                        print("the status token save result is: \(saveStatusToken)")
                        print("the email token save result is: \(saveEmailStatusToken)")
                        print("the profile image token save result is: \(saveProfileImageToken)")
                        print("the profile image token save result is: \(savePackage)")
                        
                        
                        print("result: \(String(describing: user))")
                        print("result: \(String(describing: pass))")
                        
                        
                        let statusToken: String? = KeychainWrapper.standard.string(forKey: "statusToken")
                        if statusToken! == "1" {
                            self.endEditing(true)
                            DispatchQueue.main.async {
                                let dashboardVC = DashboardVC()
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window??.rootViewController = dashboardVC
                            }
                            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                        }
                        else if statusToken! == "0" {
                            self.endEditing(true)
                            DispatchQueue.main.async {
                                let unregisteredVC = UnregisteredVC()
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window??.rootViewController = unregisteredVC
                            }
                            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                            
                        }
                    }
                    
                    
                }
        }
        task.resume()
    }
    
    
    
}
