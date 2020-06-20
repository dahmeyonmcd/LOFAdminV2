//
//  LanguageSelectorVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/23/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class LanguageSelectorVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let countries =  ["English", "Spanish", "French", "German"]
    
    let clearBackGround: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let lotContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let cardBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        return view
    }()
    
    let languagePicker: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = .gray
        button.setImage(UIImage(named: "Close_Icon"), for: .normal)
        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.imageEdgeInsets = InsetView
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        view.backgroundColor = .clear
        let blurThis = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurThis)
        
        blurView.frame = view.bounds
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(clearBackGround)
        clearBackGround.addSubview(cardBackground)
        clearBackGround.addSubview(closeButton)
        cardBackground.addSubview(languagePicker)
        
        // setup constraints for views
        NSLayoutConstraint.activate([
            clearBackGround.topAnchor.constraint(equalTo: view.topAnchor),
            clearBackGround.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            clearBackGround.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            clearBackGround.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardBackground.widthAnchor.constraint(equalToConstant: 300),
            cardBackground.heightAnchor.constraint(equalToConstant: 200),
            cardBackground.centerXAnchor.constraint(equalTo: clearBackGround.centerXAnchor),
            cardBackground.centerYAnchor.constraint(equalTo: clearBackGround.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            closeButton.topAnchor.constraint(equalTo: cardBackground.bottomAnchor, constant: 15),
            closeButton.centerXAnchor.constraint(equalTo: clearBackGround.centerXAnchor),
            languagePicker.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            languagePicker.heightAnchor.constraint(equalTo: cardBackground.heightAnchor)
            ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return countries.count
    }
    
    @objc func closePage() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
