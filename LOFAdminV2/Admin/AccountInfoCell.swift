//
//  AccountInfoCell.swift
//  MillionaireMentorship App
//
//  Created by Dahmeyon McDonald on 6/9/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AccountInfoCell: UICollectionViewCell {
    
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
        field.isUserInteractionEnabled = false
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
        field.isUserInteractionEnabled = false
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
        label.text = "Social"
        label.textColor = .lightGray
        return label
    }()
    
    let instagramField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Instagram", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        return field
    }()
    
    let linkedinField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "LinkedIn", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        return field
    }()
    
    let websiteField: TextFieldVC = {
        let field = TextFieldVC()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        field.backgroundColor = GlobalManager().globalBackgroundColor()
        field.attributedPlaceholder = NSAttributedString(string: "Website", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.layer.cornerRadius = 8
        field.tintColor = .white
        field.isUserInteractionEnabled = true
        field.textColor = .white
        return field
    }()
    
    var user: LOFMember?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        //AccountInfoViewController().delegate = self
        fetchUser()
        setupTargets()
        setupNotification()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveChanges), name: Notification.Name("AccountInfoSaveTapped"), object: nil)
    }
    
    func setupTargets() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func fetchUser() {
        isUserInteractionEnabled = false
        
        guard let userData = UserDefaults.standard.data(forKey: "selectedMember") else { return }
        guard let user = try? PropertyListDecoder().decode(LOFMember.self, from: userData) else { return }
        
        self.user = user
        
        Firestore.firestore().collection("members").document(user.id).getDocument { (snapshot, error) in
            if error == nil {
                if let snapshot = snapshot {
                    if let dict = snapshot.data() {
                        let name = dict["name"] as? String ?? ""
                        let email = dict["email"] as? String ?? ""
                        let mobile = dict["mobile"] as? String ?? ""
                        let address = dict["address"] as? String ?? ""
                        let city = dict["city"] as? String ?? ""
                        let state = dict["state"] as? String ?? ""
                        let zipcode = dict["zipcode"] as? String ?? ""
                        let country = dict["country"] as? String ?? ""
                        
                        let instagram = dict["instagram"] as? String ?? ""
                        let linkedin = dict["linkedin"] as? String ?? ""
                        let website = dict["website"] as? String ?? ""
                        
                        self.nameField.text = name
                        self.emailField.text = email
                        self.mobileField.text = mobile
                        self.addressField.text = address
                        self.cityField.text = city
                        self.stateField.text = state
                        self.zipcodeField.text = zipcode
                        self.countryField.text = country
                        self.instagramField.text = instagram
                        self.linkedinField.text = linkedin
                        self.websiteField.text = website
                        
                        self.isUserInteractionEnabled = true
                    }
                }
            }
        }
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
            let sv = UIStackView(arrangedSubviews: [socialLabel, instagramField, linkedinField, websiteField])
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


extension AccountInfoCell: AccountInfoDelegate {
    @objc func saveChanges() {
        if user != nil {
            guard let userData = UserDefaults.standard.data(forKey: "selectedMemeber") else { return }
            guard let user = try? PropertyListDecoder().decode(LOFMember.self, from: userData) else { return }
            
            let poststring = ["mobile": mobileField.text ?? "", "address": addressField.text ?? "", "city": cityField.text ?? "", "zipcode": zipcodeField.text ?? "", "state": stateField.text ?? "", "instagram": instagramField.text ?? "", "linkedin": linkedinField.text ?? "", "website": websiteField.text ?? ""]
            
            print(poststring)
            
            Firestore.firestore().collection("members").document(user.id).setData(poststring, merge: true) { (error) in
                if error != nil {
                    print("Failed to save")
                } else {
                    print("Successfully saved")
                    NotificationCenter.default.post(name: Notification.Name("AccountInfoSaved"), object: nil)
                }
            }
        }
    }
    
}
