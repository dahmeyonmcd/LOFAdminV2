//
//  ChangePlanVc.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/23/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftHash
import SwiftKeychainWrapper
import Alamofire

class choosesignalsCell: UICollectionViewCell {
    
    let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectedChange), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitle("Choose Signals", for: .normal)
        button.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let cellBackgoundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds =  true
//        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Signals"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
        
    }()
    
    let desctiptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Signals"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(cellBackgoundView)
        cellBackgoundView.addSubview(titleLabel)
        cellBackgoundView.addSubview(desctiptionLabel)
        cellBackgoundView.addSubview(selectButton)
        
        // setup cell constraints and layouts
        NSLayoutConstraint.activate([
            cellBackgoundView.topAnchor.constraint(equalTo: topAnchor),
            cellBackgoundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellBackgoundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellBackgoundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: cellBackgoundView.topAnchor, constant: 35),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: cellBackgoundView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cellBackgoundView.trailingAnchor, constant: -20),
            desctiptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 35),
            desctiptionLabel.leadingAnchor.constraint(equalTo: cellBackgoundView.leadingAnchor, constant: 20),
            desctiptionLabel.trailingAnchor.constraint(equalTo: cellBackgoundView.trailingAnchor, constant: -20),
            selectButton.widthAnchor.constraint(equalTo: cellBackgoundView.widthAnchor, multiplier: 0.7),
            selectButton.centerXAnchor.constraint(equalTo: cellBackgoundView.centerXAnchor),
            selectButton.bottomAnchor.constraint(equalTo: cellBackgoundView.bottomAnchor, constant: -30),
            selectButton.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }
    
    @objc func selectedChange() {
        let currentPlan: String? = KeychainWrapper.standard.string(forKey: "currentPlan")
        if currentPlan == "13"{
            
        }else{
            DispatchQueue.main.async {
                let myUrl = URL(string: "http://api.lionsofforex.com/registration/update")
                var request = URLRequest(url: myUrl!)
                let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
                let accessText = accessToken
                let postString: [String: Any] = [
                    "update": [
                        "package": "13"
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
                    return
                }
                
                Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        print(response)
                        // to get json return value
                        if let result = response.result.value {
                            let json = result as! NSDictionary
                            print(json)
                            if let userId = json.object(forKey: "success") as? NSDictionary {
                                print(userId)
                                KeychainWrapper.standard.removeObject(forKey: "currentPlan")
                                DispatchQueue.main.async {
                                    KeychainWrapper.standard.set("13", forKey: currentPlan!)
                                }
                            }
                            if let errorId = json.object(forKey: "error") as? NSDictionary {
                                print(errorId)
                            }
                            
                            
                        }
                }
            }
        }
    }
    
}

class essentialsCell: UICollectionViewCell {
    
    let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectedChange), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitle("Choose Signals", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let cellBackgoundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds =  true
        //        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Essentials"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
        
    }()
    
    let desctiptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Signals"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(cellBackgoundView)
        cellBackgoundView.addSubview(titleLabel)
        cellBackgoundView.addSubview(desctiptionLabel)
        cellBackgoundView.addSubview(selectButton)
        
        // setup cell constraints and layouts
        NSLayoutConstraint.activate([
            cellBackgoundView.topAnchor.constraint(equalTo: topAnchor),
            cellBackgoundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellBackgoundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellBackgoundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: cellBackgoundView.topAnchor, constant: 35),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: cellBackgoundView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cellBackgoundView.trailingAnchor, constant: -20),
            desctiptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 35),
            desctiptionLabel.leadingAnchor.constraint(equalTo: cellBackgoundView.leadingAnchor, constant: 20),
            desctiptionLabel.trailingAnchor.constraint(equalTo: cellBackgoundView.trailingAnchor, constant: -20),
            selectButton.widthAnchor.constraint(equalTo: cellBackgoundView.widthAnchor, multiplier: 0.7),
            selectButton.centerXAnchor.constraint(equalTo: cellBackgoundView.centerXAnchor),
            selectButton.bottomAnchor.constraint(equalTo: cellBackgoundView.bottomAnchor, constant: -30),
            selectButton.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }
    
    @objc func selectedChange() {
        let currentPlan: String? = KeychainWrapper.standard.string(forKey: "currentPlan")
        if currentPlan == "14"{
            
        }else{
            DispatchQueue.main.async {
                let myUrl = URL(string: "http://api.lionsofforex.com/registration/update")
                var request = URLRequest(url: myUrl!)
                let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
                let accessText = accessToken
                let postString: [String: Any] = [
                    "update": [
                        "package": "14"
                    ],
                    "where": [
                        "email": accessText
                    ]
                ]
                
                // send http request to perform sign in
                
                request.httpMethod = "POST"// Compose a query string
                request.addValue("application/json", forHTTPHeaderField: "content-type")
                Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        print(response)
                        // to get json return value
                        if let result = response.result.value {
                            let json = result as! NSDictionary
                            print(json)
                            if let userId = json.object(forKey: "success") as? NSDictionary {
                                print(userId)
                                KeychainWrapper.standard.removeObject(forKey: "currentPlan")
                                DispatchQueue.main.async {
                                    KeychainWrapper.standard.set("14", forKey: currentPlan!)
                                    
                                }
                            }
                            if let errorId = json.object(forKey: "error") as? NSDictionary {
                                print(errorId)
                            }
                            
                            
                        }
                }
            }
        }
    }
}

class advancedCell: UICollectionViewCell {
    
    let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectedChange), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitle("Choose Signals", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let cellBackgoundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds =  true
        //        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Advanced"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
        
    }()
    
    let desctiptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Signals"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return label
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(cellBackgoundView)
        cellBackgoundView.addSubview(titleLabel)
        cellBackgoundView.addSubview(desctiptionLabel)
        cellBackgoundView.addSubview(selectButton)
        
        // setup cell constraints and layouts
        NSLayoutConstraint.activate([
            cellBackgoundView.topAnchor.constraint(equalTo: topAnchor),
            cellBackgoundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellBackgoundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellBackgoundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: cellBackgoundView.topAnchor, constant: 35),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: cellBackgoundView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cellBackgoundView.trailingAnchor, constant: -20),
            desctiptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 35),
            desctiptionLabel.leadingAnchor.constraint(equalTo: cellBackgoundView.leadingAnchor, constant: 20),
            desctiptionLabel.trailingAnchor.constraint(equalTo: cellBackgoundView.trailingAnchor, constant: -20),
            selectButton.widthAnchor.constraint(equalTo: cellBackgoundView.widthAnchor, multiplier: 0.7),
            selectButton.centerXAnchor.constraint(equalTo: cellBackgoundView.centerXAnchor),
            selectButton.bottomAnchor.constraint(equalTo: cellBackgoundView.bottomAnchor, constant: -30),
            selectButton.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }
    
    @objc func selectedChange() {
        let currentPlan: String? = KeychainWrapper.standard.string(forKey: "currentPlan")
        if currentPlan == "15"{
            
        }else{
            DispatchQueue.main.async {
                let myUrl = URL(string: "http://api.lionsofforex.com/registration/update")
                var request = URLRequest(url: myUrl!)
                let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
                let accessText = accessToken
                let postString: [String: Any] = [
                    "update": [
                        "package": "15"
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
                    return
                }
                
                Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        print(response)
                        // to get json return value
                        if let result = response.result.value {
                            let json = result as! NSDictionary
                            print(json)
                            if let userId = json.object(forKey: "success") as? NSDictionary {
                                print(userId)
                                KeychainWrapper.standard.removeObject(forKey: "currentPlan")
                                DispatchQueue.main.async {
                                    KeychainWrapper.standard.set("15", forKey: currentPlan!)
                                }
                            }
                            if let errorId = json.object(forKey: "error") as? NSDictionary {
                                print(errorId)
                            }
                            
                            
                        }
                }
            }
        }
    }
    
}

class ChangePlanVc: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    

    
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
    

    

    
    
    let dashboardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dashboardHolder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
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
    
    let planCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let home = ChangePlanVc()
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        return cv
    }()
    
    let SignalPlanCellId = "signalPlanCellId"
    let EssentialPlanCellId = "essentialPlanCellId"
    let AdvancedPlanCellId = "advancedPlanCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        loadCurrentPackage()
        planCollectionView.dataSource = self
        planCollectionView.delegate = self
        planCollectionView.register(choosesignalsCell.self, forCellWithReuseIdentifier: SignalPlanCellId)
        planCollectionView.register(essentialsCell.self, forCellWithReuseIdentifier: EssentialPlanCellId)
        planCollectionView.register(advancedCell.self, forCellWithReuseIdentifier: AdvancedPlanCellId)
        setupLayout()
    }
    
    
    
    
    
    
    
    private func setupLayout() {
        view.addSubview(dashboardHolder)
        view.addSubview(scrollingView)
        dashboardHolder.addSubview(dashboardBorderImage)
        dashboardHolder.addSubview(profileImage)
        dashboardHolder.addSubview(dashboardTitleLabel)
        dashboardHolder.addSubview(settingsButton)
        scrollingView.addSubview(backGroundColor)
        dashboardHolder.addSubview(planCollectionView)
        
        // setup layout constraints
        
        NSLayoutConstraint.activate([
            scrollingView.topAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            scrollingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
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
            backGroundColor.heightAnchor.constraint(equalToConstant: 900),
            backGroundColor.widthAnchor.constraint(equalTo: view.widthAnchor),
            backGroundColor.topAnchor.constraint(equalTo: scrollingView.topAnchor),
            backGroundColor.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor),
            backGroundColor.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor),
            backGroundColor.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor),
            planCollectionView.topAnchor.constraint(equalTo: dashboardHolder.topAnchor),
            planCollectionView.bottomAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            planCollectionView.leadingAnchor.constraint(equalTo: dashboardHolder.leadingAnchor),
            planCollectionView.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor)
            
            ])
    }
    
    func loadCurrentPackage() {
        let myUrl = URL(string: "http://api.lionsofforex.com/myaccount")
        var request = URLRequest(url: myUrl!)
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
        // send http request to perform sign in
        
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    let userId = json.object(forKey: "success") as? NSDictionary
                    let plan = userId!.object(forKey: "package") as? String
                    KeychainWrapper.standard.set(plan!, forKey: "currentPlan")
                    let output: String? = KeychainWrapper.standard.string(forKey: "currentPlan")
                    print(output!)
                    
                }
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentPlan: String? = KeychainWrapper.standard.string(forKey: "currentPlan")
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignalPlanCellId, for: indexPath) as! choosesignalsCell
            if currentPlan == "13" {
                cell.isSelected = true
                cell.cellBackgoundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.cellBackgoundView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                cell.layer.borderWidth = 5
                cell.selectButton.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            }else{
                cell.isSelected = false
                cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            return cell
        }   else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EssentialPlanCellId, for: indexPath) as! essentialsCell
            if currentPlan == "14" {
                cell.isSelected = true
                cell.cellBackgoundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.cellBackgoundView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                cell.selectButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                cell.layer.borderWidth = 5
            }else{
                cell.isSelected = false
                cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            return cell
        }   else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvancedPlanCellId, for: indexPath) as! advancedCell
            if currentPlan == "15" {
                cell.isSelected = true
                cell.cellBackgoundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.cellBackgoundView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                cell.selectButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.layer.borderWidth = 5
            }else{
                cell.isSelected = false
                cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: backGroundColor.frame.width * 0.6, height: planCollectionView.frame.height * 0.7)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignalPlanCellId, for: indexPath) as! choosesignalsCell
            cell.selectedChange()
            collectionView.reloadData()
            
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EssentialPlanCellId, for: indexPath) as! essentialsCell
            cell.selectedChange()
            collectionView.reloadData()
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvancedPlanCellId, for: indexPath) as! advancedCell
            cell.selectedChange()
            collectionView.reloadData()
        }
    }
    
    
    
    
    //    func setupFields() {
    //        let userName: String = KeychainWrapper.standard.string(forKey: "nameToken") ?? ""
    //        let emailString: String = KeychainWrapper.standard.string(forKey: "accessToken") ?? ""
    //        let addressString: String = KeychainWrapper.standard.string(forKey: "accessToken") ?? ""
    //        let mobileString: String = KeychainWrapper.standard.string(forKey: "mobilePhone") ?? ""
    //    }
    
    
    @objc func pasteButtonTapped() {
        print("paste")
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
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
