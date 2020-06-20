//
//  ChangePasswordVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/23/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import SwiftHash
import Lottie

class ChangePasswordVC: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        return view
    }()
    
    let scrollingView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.contentSize = CGSize(width: view.frame.width, height: 10000)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let currentPassword: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "Password"
        textView.text = ""
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.textAlignment = .left
        textView.textColor = .black
        textView.isSecureTextEntry = true
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let newPassword: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "New Password"
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.text = ""
        textView.textAlignment = .left
        textView.isSecureTextEntry = true
        textView.isUserInteractionEnabled = true
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let confirmNewPassword: TextFieldVC = {
        let textView = TextFieldVC()
        textView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        textView.placeholder = "Confirm Password"
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        textView.text = ""
        textView.textAlignment = .left
        textView.isSecureTextEntry = true
        textView.isUserInteractionEnabled = true
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let saveChangesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        button.addTarget(self, action: #selector(saveChangesTapped), for: .touchUpInside)
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let imageeView = UIImageView()
        imageeView.image = UIImage(named: "ProfileBackgroundImage")
        imageeView.contentMode = .scaleAspectFill
        imageeView.translatesAutoresizingMaskIntoConstraints = false
        return imageeView
    }()
    
    let bottomViewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userblankprofile-1")
        imageView.contentMode = .scaleAspectFill
        let newColor = UIColor.white.cgColor
        imageView.layer.borderColor = newColor
        imageView.layer.borderWidth = 4
        imageView.layer.cornerRadius = 65
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        let userName: String = KeychainWrapper.standard.string(forKey: "nameToken") ?? "User"
        label.text = userName
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changeProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Profile Image", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(changeProfileImageTapped), for: .touchUpInside)
        return button
    }()
    
    let membershipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Membership: Active"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let buttonUnderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let midSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let slidingView: ProfileSlidingView = {
        let view = ProfileSlidingView()
        return view
        
    }()
    
    let pageOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        return view
        
    }()
    
    let lotContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var imagePicker = UIImagePickerController()
    let SettingTableViewCellId = "tableViewCellId"
    let settingTitles = ["Change Plan", "Manage Notifications", "Account Info", "Language", "Change Password"]
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        performProfileImageStore()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        scrollingView.delegate = self
        scrollingView.isScrollEnabled = true
        scrollingView.showsVerticalScrollIndicator = false
        scrollingView.contentSize = CGSize(width: view.frame.width, height: 2000)

        
//        loadMemberProfile()
        
        setupKeyboardDismissRecognizer()
        setupTopView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupAnimations()
        
    }
    
    func setupAnimations() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.play()
        animationView.loopMode = .loop
        
        view.addSubview(pageOverlay)
        pageOverlay.addSubview(lotContainer)
        lotContainer.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            pageOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            pageOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            lotContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lotContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: lotContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: lotContainer.centerYAnchor),
            ])
        
        // MARK: Launch loading function.
        DispatchQueue.main.async {
            
            // execute
            self.performProfileImageStore()
            self.loadMemberProfile()
            //
        }
    }
    
    @objc func performProfileImageStore() {
        
        let data = UserDefaults.standard.object(forKey: "savedProfileImage") as! NSData
        self.profileImage.image = UIImage(data: data as Data)
        DispatchQueue.main.async {
            print("profile fetched")
//            self.firstZoom()
        }
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
    
    func setupTopView() {
        view.addSubview(scrollingView)
        scrollingView.addSubview(backgroundOverlay)
        view.addSubview(topView)
        view.addSubview(saveChangesButton)
        topView.addSubview(backgroundImage)
        topView.addSubview(bottomViewHolder)
        topView.addSubview(profileImage)
        bottomViewHolder.addSubview(changeProfileButton)
        bottomViewHolder.addSubview(nameLabel)
        bottomViewHolder.addSubview(membershipLabel)
        topView.addSubview(backHomeButton)
        view.addSubview(buttonUnderView)
        backgroundOverlay.addSubview(midSpacerView)
        midSpacerView.addSubview(currentPassword)
        midSpacerView.addSubview(newPassword)
        midSpacerView.addSubview(confirmNewPassword)
        
        // setup constraints
        NSLayoutConstraint.activate([
            scrollingView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            scrollingView.bottomAnchor.constraint(equalTo: saveChangesButton.topAnchor),
            scrollingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOverlay.topAnchor.constraint(equalTo: scrollingView.topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor),
            backgroundOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            backgroundOverlay.heightAnchor.constraint(equalToConstant: 500),
            //            saveChangesButton.heightAnchor.constraint(equalToConstant: 50),
            //            saveChangesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //            saveChangesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            saveChangesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.5),
            backgroundImage.widthAnchor.constraint(equalTo: topView.widthAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            bottomViewHolder.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor),
            bottomViewHolder.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomViewHolder.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            bottomViewHolder.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            bottomViewHolder.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.5),
            profileImage.widthAnchor.constraint(equalToConstant: 130),
            profileImage.heightAnchor.constraint(equalToConstant: 130),
            profileImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            membershipLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            membershipLabel.leadingAnchor.constraint(equalTo: bottomViewHolder.leadingAnchor, constant: 30),
            membershipLabel.trailingAnchor.constraint(equalTo: bottomViewHolder.trailingAnchor, constant: -30),
            membershipLabel.centerXAnchor.constraint(equalTo: bottomViewHolder.centerXAnchor),
            membershipLabel.heightAnchor.constraint(equalToConstant: 20),
            nameLabel.topAnchor.constraint(equalTo: changeProfileButton.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: bottomViewHolder.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            backHomeButton.heightAnchor.constraint(equalToConstant: 40),
            backHomeButton.widthAnchor.constraint(equalToConstant: 40),
            backHomeButton.trailingAnchor.constraint(equalTo: bottomViewHolder.trailingAnchor, constant: -20),
            backHomeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            saveChangesButton.heightAnchor.constraint(equalToConstant: 50),
            saveChangesButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            saveChangesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonUnderView.topAnchor.constraint(equalTo: saveChangesButton.bottomAnchor),
            buttonUnderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            changeProfileButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            changeProfileButton.leadingAnchor.constraint(equalTo: bottomViewHolder.leadingAnchor, constant: 30),
            changeProfileButton.trailingAnchor.constraint(equalTo: bottomViewHolder.trailingAnchor, constant: -30),
            changeProfileButton.centerXAnchor.constraint(equalTo: bottomViewHolder.centerXAnchor),
            changeProfileButton.heightAnchor.constraint(equalToConstant: 20),
            midSpacerView.heightAnchor.constraint(equalTo: backgroundOverlay.heightAnchor, multiplier: 0.5),
            midSpacerView.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor),
            midSpacerView.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor),
            midSpacerView.topAnchor.constraint(equalTo: backgroundOverlay.topAnchor),
            currentPassword.heightAnchor.constraint(equalToConstant: 55),
            currentPassword.topAnchor.constraint(equalTo: midSpacerView.topAnchor, constant: 20),
            currentPassword.leadingAnchor.constraint(equalTo: midSpacerView.leadingAnchor, constant: 35),
            currentPassword.trailingAnchor.constraint(equalTo: midSpacerView.trailingAnchor, constant: -35),
            newPassword.heightAnchor.constraint(equalToConstant: 55),
            newPassword.topAnchor.constraint(equalTo: currentPassword.bottomAnchor, constant: 20),
            newPassword.leadingAnchor.constraint(equalTo: midSpacerView.leadingAnchor, constant: 35),
            newPassword.trailingAnchor.constraint(equalTo: midSpacerView.trailingAnchor, constant: -35),
            confirmNewPassword.heightAnchor.constraint(equalToConstant: 55),
            confirmNewPassword.topAnchor.constraint(equalTo: newPassword.bottomAnchor, constant: 20),
            confirmNewPassword.leadingAnchor.constraint(equalTo: midSpacerView.leadingAnchor, constant: 35),
            confirmNewPassword.trailingAnchor.constraint(equalTo: midSpacerView.trailingAnchor, constant: -35),
        
            
            ])
        
    }
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
        let offsetY: CGFloat = scrollView.contentOffset.y
        if offsetY < -64 {
            let progress:CGFloat = CGFloat(fabsf(Float(offsetY + 50)) / 100)
            self.backgroundImage.transform = CGAffineTransform(scaleX: 1 + progress, y: 1 + progress)
            //            self.dashboardTitleLabel.font.pointSize.advanced(by: 5) = CGAffineTransform(scaleX: 1 + progress, y: 1 + progress)
        }
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
            displayMessage(userMessage: "Something went wrong...")
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
                    let pass = userId.object(forKey: "password") as! String
                    
                    self.pageOverlay.removeFromSuperview()
                    self.animationView.stop()
                    
                    DispatchQueue.main.async {
                        if user.isEmpty != true {
                            self.currentPassword.text = pass
                        }
                        
                    }
                    
                }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellId, for: indexPath) as! SettingViewCell
        cell.titleLabel.text = settingTitles[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("cell 1 tapped")
        } else if indexPath.row == 1 {
            print("cell 2 tapped")
        }else if indexPath.row == 2 {
            print("cell 3 tapped")
            print("Opening Settings")
            let settingsVC = UpdateProfileVC()
            settingsVC.modalTransitionStyle = .crossDissolve
            present(settingsVC, animated: true, completion: nil)
            
        }else if indexPath.row == 3 {
            print("cell 4 tapped")
            let languageVC = LanguageSelectorVC()
            languageVC.modalTransitionStyle = .crossDissolve
            present(languageVC, animated: true, completion: nil)
        }else {
            print("cell 5 tapped")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveChangesTapped() {
        print("savechanges")
        dismissKeyboard()
        print("Trying to save changes")
        // Check if required fields are not empty
        if (self.newPassword.text?.isEmpty)! || (confirmNewPassword.text?.isEmpty)!
        {
            // Display alert message here
            displayMessage(userMessage: "One of the required fields is missing")
            return
        }
        // Validate password
        if ((self.newPassword.text?.elementsEqual(confirmNewPassword.text!))! != true)
        {
            // Display alert message and return
            displayMessage(userMessage: "Please make sure that passwords match")
            return
        }
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        // position Activity indicator in the center
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        // Send HTTP Request to perform sign in
        
        
        let myUrl = URL(string: "http://api.lionsofforex.com/registration/update")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        let newUserPassword = self.newPassword.text
        let mdPass = MD5(newUserPassword!)
        print("access token is: \(accessText!)")
        let postString: [String: Any] = [
            "update": [
                "password": mdPass
            ],
            "where": [
                "email": accessText
            ]
        ]
        // send http request to perform sign in
        
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
                    let pass = userId.object(forKey: "password") as! String
                    
                    DispatchQueue.main.async {
                        if pass.isEmpty != true {
                            self.currentPassword.text = pass
                            self.displayMessage(userMessage: "Password successfully updated")
                            
                        }
                        
                    }
                    
                }
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

    
    @objc func dashboardTapped() {
        print("Dashboard Tapped")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changeProfileImageTapped() {
        print("Change profile image Tapped")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
}
