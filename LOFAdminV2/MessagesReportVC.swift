//
//  MessagesReportVC.swift
//  GroupedMessagesLBTA
//
//  Created by UnoEast on 6/19/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

class MessagesReportVC: UIViewController {
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(goBackTapped), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Send Feedback", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let menubar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return view
    }()
    
    let spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    let navtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "What's wrong?"
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Let us Know What's Going On"
        label.numberOfLines = 0
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Type here.."
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.heightAnchor.constraint(equalToConstant: 55).isActive = true
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 0.4
        return tf
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .gray
        label.text = "We use your feedback to help us learn when \nsomething's not right"
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    @objc func goBackTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendButtonTapped() {
        print("Sending feedback")
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.addArrangedSubview(subtitleLabel)
        stackViewOne.alignment = .leading
        stackViewOne.spacing = 0
        stackViewOne.axis = .vertical
        
        view.addSubview(menubar)
        menubar.addSubview(spacer)
        menubar.addSubview(cancelButton)
        view.addSubview(sendButton)
        view.addSubview(stackViewOne)
        view.addSubview(textField)
        menubar.addSubview(navtitleLabel)
        
        NSLayoutConstraint.activate([
            menubar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menubar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menubar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            spacer.bottomAnchor.constraint(equalTo: menubar.bottomAnchor, constant: 0),
            spacer.leadingAnchor.constraint(equalTo: menubar.leadingAnchor, constant: 0),
            spacer.trailingAnchor.constraint(equalTo: menubar.trailingAnchor, constant: 0),
            
            cancelButton.centerYAnchor.constraint(equalTo: menubar.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: menubar.leadingAnchor),
            
            navtitleLabel.centerXAnchor.constraint(equalTo: menubar.centerXAnchor),
            navtitleLabel.centerYAnchor.constraint(equalTo: menubar.centerYAnchor),
            
            stackViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackViewOne.topAnchor.constraint(equalTo: menubar.bottomAnchor, constant: 25),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: stackViewOne.bottomAnchor, constant: 25),
            
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
    }
    
}
