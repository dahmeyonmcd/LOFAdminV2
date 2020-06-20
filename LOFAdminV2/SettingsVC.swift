//
//  SettingsVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class SettingsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    
    
    let backGroundColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .clear
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
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bertoprofile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Back_Icon"), for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dashboardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardLotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardViewBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainCardBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        let userName: String = KeychainWrapper.standard.string(forKey: "nameToken") ?? "User"
        let firstName = userName.components(separatedBy: " ").first
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.text = "Welcome Back, \n\(firstName ?? "")"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let memberCountLabel: UILabel = {
        let label = UILabel()
        let memberCount: String = KeychainWrapper.standard.string(forKey: "lofMembers") ?? "---"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "\(memberCount) Active Members"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let greetingMessage: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.text = "Welcome Lions of Forex members around the world"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lofCalendar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let calendarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CalendarImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let saveChangesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        button.addTarget(self, action: #selector(saveChangesTapped), for: .touchUpInside)
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonUnderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let EmailNotificationsCellId = "emailNotificationsCellId"
    private let SMSNotificationsCellId = "smsNotificationsCellId"
    private let PushNotificationsCellId = "pushNotificationsCellId"
    private let SignalNotificationsCellId = "signalNotificationsCellId"
    private let AffiliateNotificationCellId = "affiliateNotificationCellId"
    private let ThemeCellId = "ThemeCellId"
    let settingOptions = ["","","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topCollectionView.register(NotificationCell.self, forCellWithReuseIdentifier: EmailNotificationsCellId)
        topCollectionView.dataSource = self
        topCollectionView.delegate = self
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(backGroundColor)
        backGroundColor.addSubview(dashboardHolder)
        dashboardHolder.addSubview(dashboardBorderImage)
        dashboardHolder.addSubview(dashboardTitleLabel)
        dashboardHolder.addSubview(backButton)
        backGroundColor.addSubview(saveChangesButton)
        backGroundColor.addSubview(buttonUnderView)
        
        // set up collectionview 2.
        backGroundColor.addSubview(topCollectionView)
        
        // setup constraints
        NSLayoutConstraint.activate([
            backGroundColor.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundColor.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backGroundColor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundColor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dashboardHolder.heightAnchor.constraint(equalToConstant: 160),
            dashboardHolder.topAnchor.constraint(equalTo: backGroundColor.topAnchor),
            dashboardHolder.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor),
            dashboardHolder.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor),
            dashboardBorderImage.topAnchor.constraint(equalTo: dashboardHolder.topAnchor),
            dashboardBorderImage.widthAnchor.constraint(equalTo: dashboardHolder.widthAnchor),
            dashboardBorderImage.leadingAnchor.constraint(equalTo: dashboardHolder.leadingAnchor),
            dashboardBorderImage.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor),
            dashboardBorderImage.heightAnchor.constraint(equalTo: dashboardHolder.heightAnchor),
            dashboardTitleLabel.bottomAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            dashboardTitleLabel.leadingAnchor.constraint(equalTo: dashboardHolder.leadingAnchor, constant: 25),
            backButton.bottomAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor, constant: -28),
            topCollectionView.topAnchor.constraint(equalTo: dashboardHolder.bottomAnchor, constant: 30),
            topCollectionView.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor),
            topCollectionView.bottomAnchor.constraint(equalTo: backGroundColor.safeAreaLayoutGuide.bottomAnchor),
            saveChangesButton.heightAnchor.constraint(equalToConstant: 50),
            saveChangesButton.widthAnchor.constraint(equalTo: backGroundColor.safeAreaLayoutGuide.widthAnchor),
            saveChangesButton.bottomAnchor.constraint(equalTo: backGroundColor.safeAreaLayoutGuide.bottomAnchor),
            buttonUnderView.topAnchor.constraint(equalTo: saveChangesButton.bottomAnchor),
            buttonUnderView.bottomAnchor.constraint(equalTo: backGroundColor.bottomAnchor),
            buttonUnderView.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor),
            buttonUnderView.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor),
        
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmailNotificationsCellId, for: indexPath) as! NotificationCell
                cell.cellTitleLabel.text = "Recieve email notifications"
                cell.cellBackground.image = UIImage(named: "SettingsBackgroundImage")
                cell.cellIconImage.image = UIImage(named: "ExploreIcon_Large")
                return cell
                
            }else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmailNotificationsCellId, for: indexPath) as! NotificationCell
                cell.cellTitleLabel.text = "Recieve SMS notifications"
                cell.cellBackground.image = UIImage(named: "SettingsBackgroundImage")
                cell.cellIconImage.image = UIImage(named: "SignalIcon_large")
                return cell
                
            }else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmailNotificationsCellId, for: indexPath) as! NotificationCell
                cell.cellTitleLabel.text = "Recieve Push notifications"
                cell.cellBackground.image = UIImage(named: "SettingsBackgroundImage")
                cell.cellIconImage.image = UIImage(named: "EducationIcon_Large")
                return cell
                
            }else if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmailNotificationsCellId, for: indexPath) as! NotificationCell
                cell.cellTitleLabel.text = "Recieve Signal notifications"
                cell.cellBackground.image = UIImage(named: "SettingsBackgroundImage")
                cell.cellIconImage.image = UIImage(named: "EducationIcon_Large")
                return cell
                
            }else if indexPath.row == 4 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmailNotificationsCellId, for: indexPath) as! NotificationCell
                cell.cellTitleLabel.text = "Recieve Webinar notifications"
                cell.cellBackground.image = UIImage(named: "SettingsBackgroundImage")
                cell.cellIconImage.image = UIImage(named: "EducationIcon_Large")
                return cell
                
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmailNotificationsCellId, for: indexPath) as! NotificationCell
                cell.cellTitleLabel.text = "Recieve Affiliate notifications"
                cell.cellBackground.image = UIImage(named: "SettingsBackgroundImage")
                cell.cellIconImage.image = UIImage(named: "")
                return cell
                
            }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("isTapped")
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveChangesTapped() {
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
