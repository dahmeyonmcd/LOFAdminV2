//
//  NewMemverViewController.swift
//  LOFAdminV2
//
//  Created by Dahmeyon McDonald on 6/19/20.
//  Copyright © 2020 LionsOfForex. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseFirestore
import UIKit

class NewMemberViewController: UIViewController {
    
    let menuBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = GlobalManager().globalBackgroundColor()
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let textColor = UIColor.white
        button.setImage(UIImage(named: "backwards_button"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.heightAnchor.constraint(equalToConstant: 38).isActive = true
        button.widthAnchor.constraint(equalToConstant: 38).isActive = true
        button.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(saveTappedFunc), for: .touchUpInside)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .vertical
        cv.backgroundColor = nil
        cv.keyboardDismissMode = .interactive
        return cv
    }()
    
    fileprivate let cellID = "NEWMEMBERRCELLID"
    
    var bottomConstraint : NSLayoutConstraint!
    
    var globalHeight = CGFloat()
    
    var keyboardShown = false
    
    var accountInfoCell: AccountInfoCell!
    
    var notification: Notification!
    
    //lazy var loading = LoadingView(rootViewController: self, title: "Saving your account info changes...", description: "This may take a second. Please be patient.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAccountInfoCell()
        configureCollectionView()
        setupKeyboardListeners()
        setupNotifications()
    }
    
    func setupViews() {
        view.backgroundColor = GlobalManager().globalHilightColor()
        
        view.addSubview(menuBar)
        menuBar.addSubview(backButton)
        menuBar.addSubview(saveButton)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 5),
            
            saveButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint.isActive = true
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: Notification.Name("AccountInfoSaved"), object: nil)
    }
    
    @objc func showAlert(_ title: String?, _ message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okation = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okation)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountInfoSaved"), object: nil)
    }
    
    @objc func saveTappedFunc() {
        NotificationCenter.default.post(name: Notification.Name("CreateUser"), object: nil)
        //loading.startLoading()
    }
    
    func setupAccountInfoCell() {
        self.accountInfoCell = AccountInfoCell()
    }
    
    func setupKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: Notification) {
        if keyboardShown == true {
            
        }else{
            if let info = notification.userInfo {
                let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                self.globalHeight = keyboardFrame.height

                self.bottomConstraint.constant -= globalHeight
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.collectionView.layoutIfNeeded()
                })
                self.keyboardShown = true
            }
        }
        
    }
    
    @objc func keyboardDisappeared() {
        if keyboardShown == true {
            keyboardShown = false
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.collectionView.layoutIfNeeded()
            })
        }else{
            
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewMemberCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension NewMemberViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NewMemberCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 880) // 600
    }
}

extension NewMemberViewController: NewMemberDelegate {
    func createUser(name: String?, email: String?, package: LOFMember.LOFPackage?, mobile: String?, address: String?, city: String?, zipcode: String?, country: String?, state: String?, create_password: String?, confirm_password: String?, experience: String?) {
        
        if let name = name, let email = email, let package = package, let mobile = mobile, let country = country, let create_password = create_password, let confirm_password = confirm_password, let experience = experience {
            if create_password == confirm_password {
                // success
                guard let myUrl = URL(string: "http://api.lionsofforex.com/myaccount/new_user") else { return }
                
                let postStringTwo = ["name": name, "email": email, "password": create_password, "mobile": mobile, "address": address ?? "", "address2": "", "country": country, "birthday": "01/01/1980", "forexExperience": experience, "package": package.rawValue, "promocode": ""]
                
                NotificationCenter.default.post(name: Notification.Name("StartLoadingRegistration"), object: nil)
                Alamofire.request(myUrl, method: .post, parameters: postStringTwo, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        
                        print(response)
                        
                        if let result = response.result.value {
                            if let json = result as? NSDictionary {
                                
                                if let success = json.value(forKey: "success") as? NSDictionary {
                                    if let id = success["id"] as? String {
                                        
                                        let firebasePostString = ["id": id, "name": name, "email": email, "password": create_password, "mobile": mobile, "address": address ?? "", "address2": "", "city": city ?? "", "state": state ?? "", "zipcode": zipcode ?? "", "country": country, "birthday": "01/01/1980", "forexExperience": experience, "package": package.rawValue, "promocode": "", "active": "0", "mobileRegister": "0"]
                                        
                                        Firestore.firestore().collection("members").document(id).setData(firebasePostString, merge: true) { (err) in
                                            if err == nil {
                                                // SUCCESS
                                                self.showAlert("Alert", "Successfully created user.")
                                                self.dismiss(animated: true, completion: nil)
                                            } else {
                                                self.showAlert("Alert", "Successfully created user but failed to store in firebase.")
                                                self.dismiss(animated: true, completion: nil)
                                            }
                                        }
                                    }
                                }
                                
                                if let error = json.value(forKey: "error") as? NSDictionary {
                                    let message = error["message"] as? String ?? "Error creating user"
                                    self.showAlert("Alert", message)
                                }
                            }
                        }
                }
            } else {
                self.showAlert("Alert", "Please make sure passwords match")
            }
        } else {
            self.showAlert("Alert", "Please fill out all required fields")
        }
    }
    
    
}
