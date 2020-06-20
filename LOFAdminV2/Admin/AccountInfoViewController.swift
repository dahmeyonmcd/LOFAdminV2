//
//  AccountInfoViewController.swift
//  MillionaireMentorship App
//
//  Created by Dahmeyon McDonald on 6/9/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit

protocol AccountInfoDelegate: NSObjectProtocol {
    func saveChanges()
}

class AccountInfoViewController: UIViewController {
    
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
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
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
    
    fileprivate let cellID = "ACCOUNTINFOCELLID"
    
    var delegate: AccountInfoDelegate?
    
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
    
    @objc func showAlert() {
        //loading.stopLoading()
        let alertController = UIAlertController(title: "Alert", message: "Successfully saved your account changes", preferredStyle: .alert)
        let okation = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okation)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountInfoSaved"), object: nil)
    }
    
    @objc func saveTappedFunc() {
        NotificationCenter.default.post(name: Notification.Name("AccountInfoSaveTapped"), object: nil)
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
        collectionView.register(AccountInfoCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension AccountInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AccountInfoCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 820) // 600
    }
}
