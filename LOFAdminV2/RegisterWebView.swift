//
//  RegisterWebView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/23/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import WebKit

class RegisterWebView: UIViewController {
    let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        
        return mb
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "HeaderLogo")
        return imageView
    }()
    
    let doneButton: UIButton = {
       let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    let topview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let URLToLoad = URL(string: "https://register.lionsofforex.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newUrl = URLRequest(url: URLToLoad!)
        webView.load(newUrl)
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(menuBar)
        view.addSubview(webView)
        view.addSubview(menuTop)
        menuBar.addSubview(doneButton)
        menuBar.addSubview(headerImage)
        
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -30),
            headerImage.heightAnchor.constraint(equalToConstant: 50),
            headerImage.widthAnchor.constraint(equalToConstant: 80),
            headerImage.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            headerImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }
    
    @objc func doneTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
