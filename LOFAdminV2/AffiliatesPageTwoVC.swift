//
//  AffiliatesPageTwo.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class AffiliatesPageTwoVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let menuBar: UIView = {
        let menu = UIView()
        menu.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
    }()
    
    
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "GradientHeaderImage")
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
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
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
        tView.backgroundColor = UIColor.init(red: 217/255, green: 222/255, blue: 233/255, alpha: 1)
        return tView
    }()
    
    let graphButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "CopyIcon"), for: .normal)
        button.tintColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
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
        button.tintColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

    
    func loadAffiliateLink() {
        let mainAffiliateLink: String? = KeychainWrapper.standard.string(forKey: "affiliatesLink")
        self.textField.text = mainAffiliateLink
    }
    
    func setupLayout() {
        view.addSubview(backgroundViewColor)
        backgroundViewColor.addSubview(menuBar)
        view.addSubview(menuTop)
        view.addSubview(topSpacer)
        view.addSubview(bottomSpacer)
        view.addSubview(topView)
        topView.addSubview(textHolder)
        topView.addSubview(graphButton)
        textHolder.addSubview(textField)
        backgroundViewColor.addSubview(cellHolder)
        topView.addSubview(closeButton)
        menuTop.addSubview(headerImage)
        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            backgroundViewColor.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundViewColor.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundViewColor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundViewColor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSpacer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            topView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
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
            headerImage.heightAnchor.constraint(equalToConstant: 50),
            headerImage.widthAnchor.constraint(equalToConstant: 80),
            headerImage.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            headerImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor)
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
        let window = UIApplication.shared.keyWindow!
        let v2 = ShareVC(frame: window.bounds)
        
        window.addSubview(v2)
        
        v2.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func closePage() {
        print("closeing page")
        navigationController?.popViewController(animated: true)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
}
