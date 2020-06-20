//
//  UpdateProfileVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/23/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class UpdateProfileVC: UIViewController {
    
    
    let saveChangesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        button.addTarget(self, action: #selector(saveChangesTapped), for: .touchUpInside)
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backGroundColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonUnderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollingView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.contentSize = CGSize(width: view.frame.width, height: 10000)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    let inputViewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameField: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "Name"
        textView.text = ""
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.textAlignment = .left
        textView.textColor = .black
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let emailField: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "Email"
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.text = ""
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = false
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let mobileTextField: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "Mobile"
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.text = ""
        textView.textAlignment = .left
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let addressField: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "Address"
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.text = ""
        textView.textAlignment = .left
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let cityField: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "City"
        textView.text = ""
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.textAlignment = .left
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let stateField: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "State"
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.text = ""
        textView.textAlignment = .left
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let zipCodeField: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "Zipcode"
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.text = ""
        textView.textAlignment = .left
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    
    let dashboardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Account"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dashboardHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dashboardBorderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DashboardBorder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bertoprofile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        let whiteColor = UIColor.white.cgColor
        imageView.layer.borderColor = whiteColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        loadMemberProfile()
        setupLayout()
        profileImageFetch()
    }
    
    
    
    

    
    
    func setupLayout() {
        view.addSubview(saveChangesButton)
        view.addSubview(buttonUnderView)
        view.addSubview(dashboardHolder)
        view.addSubview(scrollingView)
        dashboardHolder.addSubview(dashboardBorderImage)
        dashboardHolder.addSubview(profileImage)
        dashboardHolder.addSubview(dashboardTitleLabel)
        dashboardHolder.addSubview(settingsButton)
        scrollingView.addSubview(backGroundColor)
        backGroundColor.addSubview(nameField)
        backGroundColor.addSubview(emailField)
        backGroundColor.addSubview(addressField)
        backGroundColor.addSubview(cityField)
        backGroundColor.addSubview(stateField)
        backGroundColor.addSubview(zipCodeField)
        
        // setup layout constraints
        
        NSLayoutConstraint.activate([
            scrollingView.topAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            scrollingView.bottomAnchor.constraint(equalTo: saveChangesButton.topAnchor),
            scrollingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveChangesButton.heightAnchor.constraint(equalToConstant: 50),
            saveChangesButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            saveChangesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonUnderView.topAnchor.constraint(equalTo: saveChangesButton.bottomAnchor),
            buttonUnderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dashboardHolder.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            dashboardHolder.topAnchor.constraint(equalTo: view.topAnchor),
            dashboardHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dashboardHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dashboardBorderImage.topAnchor.constraint(equalTo: dashboardHolder.topAnchor),
            dashboardBorderImage.widthAnchor.constraint(equalTo: dashboardHolder.widthAnchor),
            dashboardBorderImage.leadingAnchor.constraint(equalTo: dashboardHolder.leadingAnchor),
            dashboardBorderImage.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor),
            dashboardBorderImage.heightAnchor.constraint(equalTo: dashboardHolder.heightAnchor),
            dashboardTitleLabel.bottomAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            dashboardTitleLabel.leadingAnchor.constraint(equalTo: dashboardHolder.leadingAnchor, constant: 25),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor, constant: -25),
            settingsButton.bottomAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            settingsButton.heightAnchor.constraint(equalToConstant: 20),
            settingsButton.widthAnchor.constraint(equalToConstant: 70),
            settingsButton.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor, constant: -28),
            profileImage.bottomAnchor.constraint(equalTo: settingsButton.topAnchor, constant: -10),
            backGroundColor.heightAnchor.constraint(equalToConstant: 500),
            backGroundColor.widthAnchor.constraint(equalTo: view.widthAnchor),
            backGroundColor.topAnchor.constraint(equalTo: scrollingView.topAnchor),
            backGroundColor.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor),
            backGroundColor.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor),
            backGroundColor.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor),
            nameField.heightAnchor.constraint(equalToConstant: 55),
            nameField.topAnchor.constraint(equalTo: backGroundColor.topAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 35),
            nameField.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -35),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 35),
            emailField.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -35),
            addressField.heightAnchor.constraint(equalToConstant: 55),
            addressField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            addressField.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 35),
            addressField.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -35),
            cityField.heightAnchor.constraint(equalToConstant: 55),
            cityField.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 20),
            cityField.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 35),
            cityField.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -35),
            stateField.heightAnchor.constraint(equalToConstant: 55),
            stateField.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 20),
            stateField.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 35),
            stateField.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -35),
            zipCodeField.heightAnchor.constraint(equalToConstant: 55),
            zipCodeField.topAnchor.constraint(equalTo: stateField.bottomAnchor, constant: 20),
            zipCodeField.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 35),
            zipCodeField.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -35),
            ])
    }
    
    func loadMemberProfile() {
        let myUrl = URL(string: "http://api.lionsofforex.com/login/login")
        var request = URLRequest(url: myUrl!)
        let passToken: String? = KeychainWrapper.standard.string(forKey: "passToken")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        let passText = passToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText, "password": passText] as! [String: String]
        // send http request to perform sign in
        
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            //            displayMessage(userMessage: "Something went wrong...")
            return
        }
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    let userId = json.object(forKey: "success") as! NSDictionary
                    let user = userId.object(forKey: "name") as! String
                    let email = userId.object(forKey: "email") as! String
                    let address = userId.object(forKey: "address") as AnyObject
                    _ = userId.object(forKey: "address2") as AnyObject
                    let mobile = userId.object(forKey: "mobile") as! String
                    let zipcode = userId.object(forKey: "zipcode") as AnyObject
                    let city = userId.object(forKey: "city") as AnyObject
                    let providence = userId.object(forKey: "providence") as AnyObject
                    
                    
                    DispatchQueue.main.async {
                        if user.isEmpty != true {
                            self.emailField.text = email
                            self.nameField.text = user
                            self.addressField.text = address as? String
                            //                            self.addressTwo.text = addressTwo as? String
                            self.mobileTextField.text = mobile
                            self.cityField.text = city as? String
                            self.stateField.text = providence as? String
                            self.zipCodeField.text = zipcode as? String
                        }
                        
                    }
                    
                }
        }
        
        
    }
    
//    func setupFields() {
//        let userName: String = KeychainWrapper.standard.string(forKey: "nameToken") ?? ""
//        let emailString: String = KeychainWrapper.standard.string(forKey: "accessToken") ?? ""
//        let addressString: String = KeychainWrapper.standard.string(forKey: "accessToken") ?? ""
//        let mobileString: String = KeychainWrapper.standard.string(forKey: "mobilePhone") ?? ""
//    }
    
    @objc func saveChangesTapped() {
        print("savechanges")
        let myUrl = URL(string: "http://api.lionsofforex.com/registration/update")
        var request = URLRequest(url: myUrl!)
        //        let passToken: String? = KeychainWrapper.standard.string(forKey: "passToken")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString: [String: Any] = [
            "update": [
                "name": nameField.text!,
                "mobile": mobileTextField.text!,
                "address": addressField.text!,
                //                "address2": addressTwo.text!,
                "city": cityField.text!,
                //                "state": stateField.text!,
                "zipcode": zipCodeField.text!
            ],
            "where": [
                "email": accessText
            ]
        ]
        // send http request to perform sign in
        
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            //            displayMessage(userMessage: "Something went wrong...")
            return
        }
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    let userId = json.object(forKey: "success") as! NSDictionary
                    let user = userId.object(forKey: "name") as! String
                    let email = userId.object(forKey: "email") as! String
                    let address = userId.object(forKey: "address") as AnyObject
                    let mobile = userId.object(forKey: "mobile") as! String
                    let zipcode = userId.object(forKey: "zipcode") as AnyObject
                    let city = userId.object(forKey: "city") as AnyObject
                    let providence = userId.object(forKey: "providence") as AnyObject
                    
                    
                    DispatchQueue.main.async {
                        if user.isEmpty != true {
                            self.emailField.text = email
                            self.nameField.text = user
                            self.addressField.text = address as? String
                            self.mobileTextField.text = mobile
                            self.cityField.text = city as? String
                            self.stateField.text = providence as? String
                            self.zipCodeField.text = zipcode as? String
                            self.displayMessage(userMessage: "Successfully updated your profile")
                        }
                        
                        
                    }
                    
                }
        }
    }
    
    @objc func pasteButtonTapped() {
        print("paste")
    }
    
    @objc func cancelTapped() {
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
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    // Code in this block will trigger when OK button tapped
                    print("OK Button Tapped")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
