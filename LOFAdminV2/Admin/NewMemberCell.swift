//
//  NewMemberCell.swift
//  LOFAdminV2
//
//  Created by Dahmeyon McDonald on 6/19/20.
//  Copyright © 2020 LionsOfForex. All rights reserved.
//


import UIKit
import FirebaseFirestore

protocol NewMemberDelegate: NSObjectProtocol {
    func createUser(name: String?, email: String?, package: LOFMember.LOFPackage?, mobile: String?, address: String?, city: String?, zipcode: String?, country: String?, state: String?, create_password: String?, confirm_password: String?, experience: String?)
}

class NewMemberCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "Full name"
        label.textColor = .lightGray
        return label
    }()
    
    let nameField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Your full name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.textColor = .white
        return field
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "Contact"
        label.textColor = .lightGray
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let emailField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Your email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        return field
    }()
    
    let mobileField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Your mobile number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.textColor = .white
        return field
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "Address"
        label.textColor = .lightGray
        return label
    }()
    
    let addressField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.textColor = .white
        return field
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "City"
        label.textColor = .lightGray
        return label
    }()
    
    let cityField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "City", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.textColor = .white
        return field
    }()
    
    let zipcodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "Zipcode"
        label.textColor = .lightGray
        return label
    }()
    
    let zipcodeField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Zipcode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.textColor = .white
        return field
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "Country"
        label.textColor = .lightGray
        return label
    }()
    
    let countryField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Your country", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        return field
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "State"
        label.textColor = .lightGray
        return label
    }()
    
    let stateField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "State", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.textColor = .white
        return field
    }()
    
    let socialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "Account"
        label.textColor = .lightGray
        return label
    }()
    
    let createPasswordField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Create password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    let confirmPasswordField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    let experienceField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Forex experience", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        return field
    }()
    
    let packageField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Select package", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        field.isSecureTextEntry = false
        return field
    }()
    
    var user: LOFMember?
    
    var delegate: NewMemberDelegate?
    
    let experiencePickerValues = ["I've never made a trade in my life!", "I'm ready to take trading more seriously!", "I'm a day trader, ready to improve", "Forex is my life, I just need more signals!"]
    
    let packagePickerValues = ["Signals", "Essentials", "Advanced", "Elite"]
    let packagePickerRawValues = [LOFMember.LOFPackage.Signals, LOFMember.LOFPackage.Essentials, LOFMember.LOFPackage.Advanced, LOFMember.LOFPackage.Elite]
    
    var experiencePicker: UIPickerView!
    var packagePicker: UIPickerView!
    
    var selectedPackage: LOFMember.LOFPackage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupTargets()
        setupPickerViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(createTapped), name: Notification.Name("CreateUser"), object: nil)
    }
    
    @objc func createTapped() {
        delegate?.createUser(name: nameField.text, email: emailField.text, package: selectedPackage, mobile: mobileField.text, address: addressField.text, city: cityField.text, zipcode: zipcodeField.text, country: "1", state: stateField.text, create_password: createPasswordField.text, confirm_password: confirmPasswordField.text, experience: experienceField.text)
    }
    
    func setupPickerViews() {
        packagePicker = UIPickerView()
        packagePicker.delegate = self
        packagePicker.dataSource = self
        packageField.inputView = packagePicker
        
        experiencePicker = UIPickerView()
        experiencePicker.delegate = self
        experiencePicker.dataSource = self
        experienceField.inputView = experiencePicker
    }
    
    func setupTargets() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    
    
    func setupViews() {
        backgroundColor = GlobalManager().globalHilightColor()
        
        let nameStackView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [nameLabel, nameField])
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .vertical
            sv.alignment = .fill
            sv.spacing = 10
            return sv
        }()
        
        let emailStackView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [emailLabel, emailField, mobileField])
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .vertical
            sv.alignment = .fill
            sv.spacing = 10
            return sv
        }()
        
        let addressStackView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [addressLabel, addressField, cityField, stateField, zipcodeField, countryField])
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .vertical
            sv.alignment = .fill
            sv.spacing = 10
            return sv
        }()
        
        let socialStackView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [socialLabel, createPasswordField, confirmPasswordField, experienceField, packageField])
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .vertical
            sv.alignment = .fill
            sv.spacing = 10
            return sv
        }()
        
        let mainStackView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [nameStackView, emailStackView, addressStackView, socialStackView])
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .vertical
            sv.alignment = .fill
            sv.spacing = 30
            return sv
        }()
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewMemberCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == packagePicker {
            return packagePickerRawValues.count
        } else {
            return experiencePickerValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == packagePicker {
            return packagePickerValues[row]
        } else {
            return experiencePickerValues[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == packagePicker {
            selectedPackage = packagePickerRawValues[row]
            packageField.text = packagePickerValues[row]
            endEditing(true)
        } else {
            experienceField.text = experiencePickerValues[row]
            endEditing(true)
        }
    }
}
