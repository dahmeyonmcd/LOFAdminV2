//
//  WaitlistVC.swift
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

struct WaitlistItem {
    var id: String
    var email: String
    var experience: String
    var name: String
}

class WaitlistVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        label.text = "Waitlist"
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
        label.text = "Waitlist"
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
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        layout.scrollDirection = .vertical
        return cv
    }()
    
    let cellId = "WaitlistIndividualCellId"
    
    var data1 = [WaitlistItem]()
    
    override func viewDidLoad() {
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(WaitlistCell.self, forCellWithReuseIdentifier: cellId)
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupView()
        
        loadInfo()
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
        view.addSubview(cellHolder)
        
        //        viewHolder.addSubview(cellHolder)
        topSpacer.addSubview(totalPipLabel)
        topSpacer.addSubview(secondPipLabel)
        topSpacer.addSubview(closeButton)
        view.addSubview(bottomSpacer)
        
        //
        NSLayoutConstraint.activate([
            menuBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
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
            ])
    }
    
    func loadInfo() {
        let myUrl = URL(string: "http://api.lionsofforex.com/registration/waiting-list-view")
        let postString = ["": ""]
        // send http request to perform sign in
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                // to get json return value
                let jsondata = JSON(response.result.value as Any)
                if let innerJson = jsondata.dictionary?["success"]?.arrayValue {
                    //                        print(innerJson)
                    for results in innerJson {
                        if let data = results.dictionary {
                            
                            if let id = data["id"]?.description {
                                if let name = data["name"]?.description {
                                    if let email = data["email"]?.description {
                                        if let experience = data["forexExperience"]?.description {
                                            let newItem = WaitlistItem(id: id, email: email, experience: experience, name: name)
                                            print(newItem)
                                            self.data1.append(newItem)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if self.data1.count > 0 {
                        self.cellHolder.reloadData()
                    }
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data1.count > 0 {
            return data1.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iP = data1[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WaitlistCell
        cell.nameLabel.text = iP.name
        cell.emailLabel.text = iP.email
        cell.countryLabel.text = iP.experience
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: cellHolder.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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

class WaitlistCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "---"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "---"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(nameLabel)
        stackViewOne.addArrangedSubview(emailLabel)
        stackViewOne.spacing = 5
        stackViewOne.axis = .vertical
        stackViewOne.alignment = .leading
        
        addSubview(stackViewOne)
        addSubview(countryLabel)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            stackViewOne.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackViewOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            countryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            countryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
