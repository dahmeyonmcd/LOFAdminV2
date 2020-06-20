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

class ChatView: UIView, WKNavigationDelegate {
    
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
    
    var webView: WKWebView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .white
//
        observeKeyboardNotification()
        
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
        
        webView.allowsBackForwardNavigationGestures = true
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(topSpacer)
        addSubview(bottomSpacer)
//        addSubview(webView)
        
        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
//            webView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
//            webView.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
//            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    fileprivate func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.frame.origin.y += keyboardSize.height
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
