//
//  CreateNewSignalVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/13/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import AVKit
import WebKit

class lofTVUploadVC: UIViewController {
    
    let topSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let viewHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userblankprofile")
        imageView.backgroundColor = .clear
        let newColor = UIColor.white.cgColor
        imageView.layer.borderColor = newColor
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "HeaderLogo")
        return imageView
    }()
    
    let backHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 1)
        //        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
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
    
    let menuBar: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = .black
        return tView
    }()
    
    let entryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Type notification here"
        label.numberOfLines = 1
        return label
    }()
    
    let entryField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.contentMode = .topLeft
        
        return textField
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CANCEL", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Adding New Signal"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let pairPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        //        iv.image = UIImage(named: "DashboardBackgroundImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let totalPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Admin"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "LOFTV Upload"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.contentMode = .bottomLeft
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "mb"), for: .normal)
        button.tintColor = .white
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("SIGNAL", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.layer.zPosition = 1
        button.layer.masksToBounds = true
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollView.alwaysBounceHorizontal = false
        view.scrollView.showsVerticalScrollIndicator = true
        view.backgroundColor = .black
        return view
    }()
    
    let URLToLoad = URL(string: "https://api.lionsofforex.com/admin/loftv-upload")
    
    override func viewDidLoad() {
        
        let newUrl = URLRequest(url: URLToLoad!)
        webView.load(newUrl)
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupView()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func updateButtonTapped() {
        print("open updates")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(menuBar)
        view.addSubview(topSpacer)
        view.addSubview(viewHolder)
        
        //        viewHolder.addSubview(cellHolder)
        topSpacer.addSubview(totalPipLabel)
        topSpacer.addSubview(secondPipLabel)
        topSpacer.addSubview(closeButton)
        view.addSubview(bottomSpacer)
        //        view.addSubview(loginLabel)
        viewHolder.addSubview(webView)
        
        //
        NSLayoutConstraint.activate([
            menuBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            viewHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topSpacer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 50),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            totalPipLabel.leadingAnchor.constraint(equalTo: topSpacer.leadingAnchor, constant: 20),
            totalPipLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            secondPipLabel.leadingAnchor.constraint(equalTo: totalPipLabel.trailingAnchor, constant: 5),
            secondPipLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: topSpacer.trailingAnchor, constant: -15),
            
            webView.topAnchor.constraint(equalTo: viewHolder.topAnchor),
            webView.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor),
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
   
    
    @objc func closeButtonTapped() {
        print("closing page")
        navigationController?.popViewController(animated: true)
    }
    
}
