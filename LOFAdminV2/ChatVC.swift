//
//  ChatView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/6/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

class ChatVC: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    let menuTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userblankprofile")
        imageView.backgroundColor = .clear
        let newColor = UIColor.white.cgColor
        imageView.layer.borderColor = newColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "GradientHeaderImage")
        return imageView
    }()
    
    let backHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let menuBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    let comingSoonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ComingSoon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //        backgroundColor = .white
        //
//        observeKeyboardNotification()
        
        profileImageFetch()
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        
        let emailString: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let email = "\"\(emailString ?? "")\""
        
        var request = URLRequest(url: URL(string: "https://api.lionsofforex.com/chat/webview")!)
        request.httpMethod = "POST"
        let postString = "{\"email\":\(email)}"
        //        let postString = ["email": emailString] as! [String: String]
        
        request.httpBody = postString.data(using: .utf8)
        webView.load(request)
        webView.scrollView.delegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.allowsBackForwardNavigationGestures = true
        setupLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func setupLayout() {
        view.addSubview(topSpacer)
        view.addSubview(webView)
        view.addSubview(menuBar)
        view.addSubview(menuTop)
        menuBar.addSubview(profileImage)
        menuBar.addSubview(menuBarLabel)
        menuBar.addSubview(backHomeButton)
        menuBar.addSubview(headerImage)
        
        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 0),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
//            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 40),
            profileImage.widthAnchor.constraint(equalToConstant: 40),
            profileImage.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 20),
            profileImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            menuBarLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            menuBarLabel.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            menuBarLabel.widthAnchor.constraint(equalTo: menuBar.widthAnchor, multiplier: 0.4),
            backHomeButton.heightAnchor.constraint(equalToConstant: 40),
            backHomeButton.widthAnchor.constraint(equalToConstant: 40),
            backHomeButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            backHomeButton.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -20),
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 50),
            headerImage.widthAnchor.constraint(equalToConstant: 80),
            headerImage.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            headerImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor)
            ])
    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return nil
//    }
//
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 1.0
//    }
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        <#code#>
//    }
    
    
    fileprivate func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    @objc func dashboardTapped() {
        print("Closing Explore")
        dismiss(animated: true, completion: nil)
    }
    
    func profileImageFetch() {
        let imageUrl: String? = KeychainWrapper.standard.string(forKey: "profileImageUrl")
        
        if imageUrl == nil {
            self.profileImage.image = UIImage(named: "userblankprofile-1")
        }else{
            let profileString = ("https://members.lionsofforex.com\(imageUrl ?? "")") as String
            print(profileString)
            
            self.profileImage.setImageFromURl(stringImageUrl: profileString)
        }
        
        
    }

    
}
