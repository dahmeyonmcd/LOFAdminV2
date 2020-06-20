//
//  NotificationsView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON


class NotificationsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        layout.scrollDirection = .vertical
        cv.alpha = 0
        return cv
    }()

    let goToDashboardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 3
        button.setTitle("Back To Dashboard", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToDashboard), for: .touchUpInside)
        return button
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "No New Notifications!"
        return label
    }()
    
    let dashboardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "NotificationBell_Icon")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        label.text = "Get real-time alerts regarding everything LOF! You can edit your preferences in the settings tab!"
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
    
    let MainTab = SwipingController()
    let settingOptions = ["New Signal!","New Signal!","New Webnar Available!","New Update Available","New Signal!","New Webnar Available!"]
    let NewAppNotificationsCellId = "newAppNotificationsCellId"
    
    var data1 = [String : Any]()
    var notifications = [String : AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsView.NotificationArrived(notification:)), name: NSNotification.Name("NewNotificationReceived"), object: nil)
        
        cellHolder.register(AppNotificationCell.self, forCellWithReuseIdentifier: NewAppNotificationsCellId)
        cellHolder.dataSource = self
        cellHolder.delegate = self
//        setupLayout()
        setupButtonLayout()
        handleWalkthrough()
        
        configureCollectionView()
    }
    
    @objc func NotificationArrived(notification: Notification) {
        // Do your updating of labels or array here
        let userInfo = notification.userInfo
        print("new notification recieved on notifications")
        print("notification here: \(String(describing: userInfo))")
        print(userInfo!)
        let parsedNotification = userInfo as! [String : AnyObject]
        self.notifications.append(parsedNotification)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupButtonLayout() {
        addSubview(containerView)
        containerView.addSubview(dashboardImage)
        containerView.addSubview(notificationLabel)
        addSubview(topSpacer)
        addSubview(bottomSpacer)
        addSubview(cellHolder)
        //        addSubview(goToDashboardButton)
        
        // setup views here
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dashboardImage.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
            dashboardImage.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.24),
            dashboardImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dashboardImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -30),
            notificationLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            notificationLabel.heightAnchor.constraint(equalToConstant: 20),
            notificationLabel.topAnchor.constraint(equalTo: dashboardImage.bottomAnchor, constant: 10),
            notificationLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),

            cellHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            
            ])
        
    }
    
    func configureCollectionView() {
//        data1.count
        if settingOptions.count < 0 {
            cellHolder.backgroundColor = .clear
        }else{
            cellHolder.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        }
    }
    
    // MARK: Handles walkthrough
    func handleWalkthrough() {
        let key: Bool? = KeychainWrapper.standard.bool(forKey: "SawNotificationsWalkthrough")
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
        
        KeychainWrapper.standard.set(true, forKey: "SawNotificationsWalkthrough")
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
    
    
    private func setupLayout() {
        // set up collectionview 2.
        addSubview(topSpacer)
        addSubview(bottomSpacer)
        addSubview(cellHolder)
        
        // setup constraints
        NSLayoutConstraint.activate([
            
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iP = settingOptions[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewAppNotificationsCellId, for: indexPath) as! AppNotificationCell
        cell.cellTitleLabel.text = iP
        cell.cellIconImage.image = UIImage(named: "Selected_Notification_Icon")
        return cell
    }
    
    @objc func goToDashboard() {
        // go back to dashboard
        print("Go to dashboard pressed")
        let vc = SwipingController()
        vc.dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("isTapped")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
