//
//  AffiliatesView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/10/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON
import Lottie

class AffiliatesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
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
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    // MARK: Set up walkthrough
    
    let walkthroughHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return view
    }()
    
    let walkthroughBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "WalkthroughBackground")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let walkthroughTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        let attString = NSAttributedString(string: "MORE", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        label.text = "Share LOF & Earn! Track your referrals, payouts, and (soon) request your payouts from your phone!"
        label.numberOfLines = 2
        return label
    }()
    
    let walkthroughButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Close_Icon"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeWalkthrough), for: .touchUpInside)
        return button
    }()
    
    // MARK: End of walkthrough Elements
    
    
    var homeController: SwipingController?
    
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
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("MORE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(topButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 18
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let LionViews: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let totalAffiliatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        label.text = "---"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.contentMode = .left
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondAffiliatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        label.text = "total affiliates"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.contentMode = .bottomLeft
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let helpLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Invite members to unlock \naffiliate dashboard!"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.contentMode = .center
        label.textAlignment = .center
        label.numberOfLines = 2
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
    
    let MainTab = SwipingController()
    let AffiliatesCellId = "affiliatesCellId"
    var data1 = [[String: AnyObject]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        MainTab.menuBarLabel.text = "Affiliates"
        setupTopBar()
        cellHolder.dataSource = self
        cellHolder.delegate = self
        cellHolder.backgroundColor = .clear
        cellHolder.register(AffiliatesCell.self, forCellWithReuseIdentifier: AffiliatesCellId)
        setupAffiliatesGraph()
        
        startAnimations()
    }
    
    func startAnimations() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.play()
        animationView.loopMode = .loop
        
        addSubview(pageOverlay)
        pageOverlay.addSubview(lotContainer)
        lotContainer.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            pageOverlay.topAnchor.constraint(equalTo: topAnchor),
            pageOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lotContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            lotContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: lotContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: lotContainer.centerYAnchor),
            ])
        
        // MARK: Launch loading function.
        DispatchQueue.main.async {
            
            // execute
            self.loadAffiliatesLink()
            self.loadAffiliatesEarned()
            self.loadAffiliatesVisitors()
            self.loadAffiliatesConversion()
            
            self.handleLions()
            
            self.handleWalkthrough()
//            self.fetchAffiliates()
            
            
            //
        }
    }
    
    func setupAffiliatesGraph() {
        overlayView.addSubview(cellHolder)
        
        cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
        
    }
    
    
    // MARK: Handles walkthrough
    func handleWalkthrough() {
        let key: Bool? = KeychainWrapper.standard.bool(forKey: "SawAffiliatesWalkthrough")
        if key == nil {
            openWalkthrough()
            
        }else if key == false {
            openWalkthrough()
            
        }else{
            print("already watched walkthrough")
        }
    }
    
    func setupWalkthrough() {
        let stackOne = UIStackView()
        stackOne.translatesAutoresizingMaskIntoConstraints = false
        stackOne.addArrangedSubview(walkthroughTitleLabel)
        stackOne.axis = .vertical
        stackOne.distribution = .equalSpacing
        stackOne.alignment = .leading
        
        // finish setting up walkthrough
        let v2 = walkthroughHolder
        v2.translatesAutoresizingMaskIntoConstraints = false
        let v3 = walkthroughButton
        let v4 = walkthroughBackgroundImage
        let v5 = stackOne
        v3.translatesAutoresizingMaskIntoConstraints = false

        addSubview(v2)
        v2.addSubview(v4)
        v2.addSubview(v5)
        v2.addSubview(v3)
        
        v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
        
        v3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        v3.widthAnchor.constraint(equalToConstant: 40).isActive = true
        v3.trailingAnchor.constraint(equalTo: v2.trailingAnchor, constant: -15).isActive = true
        v3.centerYAnchor.constraint(equalTo: v2.centerYAnchor).isActive = true
        
        v4.topAnchor.constraint(equalTo: v2.topAnchor).isActive = true
        v4.bottomAnchor.constraint(equalTo: v2.bottomAnchor).isActive = true
        v4.trailingAnchor.constraint(equalTo: v2.trailingAnchor).isActive = true
        v4.leadingAnchor.constraint(equalTo: v2.leadingAnchor).isActive = true
        
        v5.topAnchor.constraint(equalTo: v2.topAnchor, constant: 10).isActive = true
        v5.bottomAnchor.constraint(equalTo: v2.bottomAnchor, constant: -10).isActive = true
        v5.trailingAnchor.constraint(equalTo: v3.leadingAnchor, constant: -10).isActive = true
        v5.leadingAnchor.constraint(equalTo: v2.leadingAnchor, constant: 15).isActive = true
        
    }
    
    @objc func closeWalkthrough() {
        walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseOut, animations: {
            self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 300)
        }) { (_) in
            // here
            self.walkthroughHolder.removeFromSuperview()
        }
        KeychainWrapper.standard.set(true, forKey: "SawAffiliatesWalkthrough")

    }
    
    @objc func openWalkthrough() {
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.setupWalkthrough()
            self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 300)
            
            UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseIn, animations: {
                self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (_) in
                // here
                
            }
        }
        
    }
    
    func setupTopBar() {
        addSubview(overlayView)
        overlayView.addSubview(topSpacer)
        overlayView.addSubview(bottomSpacer)
        overlayView.addSubview(topView)
        topView.addSubview(totalAffiliatesLabel)
        topView.addSubview(graphButton)
        topView.addSubview(secondAffiliatesLabel)
        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.topAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 60),
            topView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            topView.widthAnchor.constraint(equalTo: overlayView.widthAnchor),
            graphButton.widthAnchor.constraint(equalToConstant: 100),
            graphButton.heightAnchor.constraint(equalToConstant: 36),
            graphButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            graphButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            totalAffiliatesLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            totalAffiliatesLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            secondAffiliatesLabel.leadingAnchor.constraint(equalTo: totalAffiliatesLabel.trailingAnchor, constant: 5),
            secondAffiliatesLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffiliatesCellId, for: indexPath) as! AffiliatesCell
        
        let iP = data1[indexPath.row]
        cell.userImageView.image = UIImage(named: "AffiliatePlaceholder")
        cell.dateLabel.text = iP["added_date"] as? String
        cell.joinedStringLabel.text = iP["status"] as? String
        cell.packageValueLabel.text = iP["conversions"] as? String
        //        cell.commissionEarned.text = iP["amount"] as? String
        cell.nameStringLabel.text = iP["name"] as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 240
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 9, left: 0, bottom: 0, right: 0)
    }
    
    func setupImages() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(LionViews)
        stackViewOne.addArrangedSubview(helpLabel)
        stackViewOne.axis = .vertical
        stackViewOne.alignment = .center
        
        stackViewOne.spacing = 15
        
        LionViews.heightAnchor.constraint(equalToConstant: 80).isActive = true
        LionViews.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        helpLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        helpLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        addSubview(stackViewOne)
        
        NSLayoutConstraint.activate([
            stackViewOne.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackViewOne.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleLions() {
        let lionsAmount: String? = KeychainWrapper.standard.string(forKey: "numberOfLions")
        let newInt = Int(lionsAmount!)
        
        if newInt == 0 {
            // shows
            let image = UIImage(named: "ZeroLions")
            LionViews.image = image
            setupImages()
            self.pageOverlay.removeFromSuperview()
            self.animationView.stop()
        }else if newInt == 1 {
            let image = UIImage(named: "OneLion")
            LionViews.image = image
            setupImages()
            self.pageOverlay.removeFromSuperview()
            self.animationView.stop()
        }else if newInt == 2 {
            let image = UIImage(named: "TwoLions")
            LionViews.image = image
            setupImages()
            self.pageOverlay.removeFromSuperview()
            self.animationView.stop()
        }else if newInt! >= 3 {
//            let image = UIImage(named: "AllThree")
            fetchAffiliates()
        }else if newInt == nil {
            let image = UIImage(named: "ZeroLions")
            LionViews.image = image
            setupImages()
            self.pageOverlay.removeFromSuperview()
            self.animationView.stop()
        }else {
            print("congrats")
            fetchAffiliates()
        }
    }
    
    func fetchAffiliates() {
        let myUrl = URL(string: "http://api.lionsofforex.com/affiliates/payouts")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
        // send http request to perform sign in
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    
                    if let da = jsondata["success"].arrayObject {
                        self.data1 = da as! [[String : AnyObject]]
                        let totalNumber = self.data1.count as Int
                        self.totalAffiliatesLabel.text = String(totalNumber)
                        print(jsondata)
                        
                    }
                    
                    if self.data1.count >= 0 {
                        self.cellHolder.reloadData()
                        self.animationView.stop()
                        self.pageOverlay.removeFromSuperview()
                    }
                }
                
        }
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
    
    
    @objc func topButtonTapped() {
        print("show graph tapped")
        // present view controller
        let mainController = AffiliatesPageTwoVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        
        topVC?.present(navigationController, animated: true, completion: nil)
    }
    
}
