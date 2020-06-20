//
//  AffiliatesTabView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/27/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire

class AffiliatesTabView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "HeaderLogo")
        return imageView
    }()
    
    let backgroundViewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        return tView
    }()
    
    let graphButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("MORE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = .white
        
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let totalAffiliatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "4"
        label.contentMode = .left
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 23
        view.clipsToBounds = true
        return view
    }()
    
    let textField: TextFieldVC = {
        let view = TextFieldVC()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = .black
        view.textAlignment = .left
        view.isEnabled = true
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    let secondAffiliatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "total affiliates"
        label.contentMode = .left
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let EarnedThisMonth = "earnedThisMonth"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        cellHolder.backgroundColor = .clear
        cellHolder.register(AffiliatesSubCell.self, forCellWithReuseIdentifier: EarnedThisMonth)
        setupLayout()
        loadAffiliateLink()
        loadAffiliatesEarned()
        loadAffiliatesConversion()
        loadAffiliateLink()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAffiliateLink() {
        let mainAffiliateLink: String? = KeychainWrapper.standard.string(forKey: "affiliatesLink")
        self.textField.text = mainAffiliateLink
    }
    
    func setupLayout() {
        addSubview(backgroundViewColor)
        addSubview(menuTop)
        addSubview(topSpacer)
        addSubview(bottomSpacer)
        addSubview(topView)
        topView.addSubview(textHolder)
        topView.addSubview(graphButton)
        textHolder.addSubview(textField)
        backgroundViewColor.addSubview(cellHolder)
        topView.addSubview(closeButton)
        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            backgroundViewColor.topAnchor.constraint(equalTo: topAnchor),
            backgroundViewColor.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundViewColor.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundViewColor.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuTop.topAnchor.constraint(equalTo: topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            topView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.widthAnchor.constraint(equalTo: widthAnchor),
            graphButton.widthAnchor.constraint(equalToConstant: 36),
            graphButton.heightAnchor.constraint(equalToConstant: 36),
            graphButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            graphButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
            textHolder.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 10),
            textHolder.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            textHolder.trailingAnchor.constraint(equalTo: graphButton.leadingAnchor, constant: -10),
            textHolder.heightAnchor.constraint(equalToConstant: 45),
            textField.leadingAnchor.constraint(equalTo: textHolder.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: textHolder.trailingAnchor),
            textField.topAnchor.constraint(equalTo: textHolder.topAnchor),
            textField.bottomAnchor.constraint(equalTo: textHolder.bottomAnchor),
            cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: backgroundViewColor.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: backgroundViewColor.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: backgroundViewColor.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            ])
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EarnedThisMonth, for: indexPath) as! AffiliatesSubCell
            let earnedAmount: String? = KeychainWrapper.standard.string(forKey: "affiliatesEarnedThisMonth")
            cell.tabTitle.text = "Earned This Month"
            cell.tabHolderImage.image = UIImage(named: "EarnedBackground")
            cell.amountLabel.text = earnedAmount ?? "--"
            return cell
            
        }else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EarnedThisMonth, for: indexPath) as! AffiliatesSubCell
            let visitorAmount: String? = KeychainWrapper.standard.string(forKey: "affiliatesVisitors")
            cell.tabTitle.text = "Visitors"
            cell.tabHolderImage.image = UIImage(named: "VisitorsBackground")
            cell.amountLabel.text = visitorAmount ?? "--"
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EarnedThisMonth, for: indexPath) as! AffiliatesSubCell
            let conversionAmount: String? = KeychainWrapper.standard.string(forKey: "affiliatesConversion")
            cell.tabTitle.text = "Conversion Rate"
            cell.tabHolderImage.image = UIImage(named: "ConversionBackground")
            cell.amountLabel.text = ("\(conversionAmount ?? "")%")
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 9, left: 0, bottom: 0, right: 0)
    }
    
    @objc func shareButtonTapped() {
        print("Present share View")
        let referral: String? = KeychainWrapper.standard.string(forKey: "affiliatesLink")
        UIPasteboard.general.string = referral
        print("referral link copied \(referral ?? "")")
        let window = UIApplication.shared.keyWindow
        let v2 = ShareVC(frame: (window?.bounds)!)
        
        backgroundViewColor.addSubview(v2)
        
        v2.topAnchor.constraint(equalTo: topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    @objc func closePage() {
        print("closeing page")
        self.removeFromSuperview()
    }
    
    
    
    func loadAffiliatesLink() {
        let myUrl = URL(string: "http://api.lionsofforex.com/affiliates/link")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
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
                    let userId = json.value(forKey: "success") as! String
                    
                    let saveAffiliatesLink = KeychainWrapper.standard.set(userId, forKey: "affiliatesLink")
                    print(saveAffiliatesLink)
                }
        }
    }
    
    func loadAffiliatesEarned() {
        let myUrl = URL(string: "http://api.lionsofforex.com/affiliates/earned")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
        // send http request to perform sign in
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    let userId = json.value(forKey: "success") as! String
                    
                    let saveAffiliatesLink = KeychainWrapper.standard.set(userId, forKey: "affiliatesEarnedThisMonth")
                    print(saveAffiliatesLink)
                }
        }
    }
    
    func loadAffiliatesVisitors() {
        let myUrl = URL(string: "http://api.lionsofforex.com/affiliates/visitors")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
        // send http request to perform sign in
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    let userId = json.value(forKey: "success") as! String
                    let saveAffiliatesLink = KeychainWrapper.standard.set(userId, forKey: "affiliatesVisitors")
                    print(saveAffiliatesLink)
                }
        }
    }
    
    func loadAffiliatesConversion() {
        let myUrl = URL(string: "http://api.lionsofforex.com/affiliates/conversion")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
        // send http request to perform sign in
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    let userId = json.value(forKey: "success") as! String
                    let saveAffiliatesEarned = KeychainWrapper.standard.set(userId, forKey: "affiliatesConversion")
                    print(saveAffiliatesEarned)
                }
        }
    }
    
}
