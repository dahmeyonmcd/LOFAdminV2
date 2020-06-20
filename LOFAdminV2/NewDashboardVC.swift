//
//  NewDashboardVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 4/9/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import SwiftyJSON
import SwiftKeychainWrapper
import AVKit
import UserNotifications

class NewDashboardVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        layout.sectionHeadersPinToVisibleBounds = true
        cv.showsVerticalScrollIndicator = false
        layout.scrollDirection = .vertical
        return cv
    }()
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "mb"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.font = UIFont.init(name: "GorditaBold", size: 30)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Dashboard"
        label.numberOfLines = 1
        return label
    }()
    
    let menuHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        view.widthAnchor.constraint(equalToConstant: 280).isActive = true
        view.layer.cornerRadius = 0
        view.clipsToBounds = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.heightAnchor.constraint(equalToConstant: 67).isActive = true
        view.layer.cornerRadius = 0
        view.clipsToBounds = true
        return view
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.clipsToBounds = true
        return view
    }()
    
    let notificationHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 80/255, green: 220/255, blue: 255/255, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let profilePic: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "DashboardBackgroundImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(reloadMemberCounter), for: .valueChanged)
        view.tintColor = .white
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

    
    var profileImage = UIImageView()
    var userNameString = String()
    var imageURL = String()
    var isOpen = Bool()
    
    var SignalsIsOpen = Bool()
    var MemberssIsOpen = Bool()
    
    let DashboardHeaderCellId = "dashboardHeaderCellId"
    let DashboardSubheaderCellId = "dashboardSubheaderCellId"
    let DashboardWelcomeCellId = "dashboardWelcomeCellId"
    let DashboardWelcomeTwoCellId = "dashboardWelcomeTwoCellId"
    let DashboardQuickLinkCellId = "dashboardQuicklinkCellId"
    let DashboardCalendarCellId = "dashboardCalendarCellId"
    let DashboardFeaturesCellId = "dashboardFeaturesCellId"
    let DashboardAdminQuickLinkCellId = "dashboardAdminQuicklinkCellId"
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    var contentOffset = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "Update3") != nil {
            print("Updated successfully")
        }else{
            let update: String = "Updated"
            UserDefaults.standard.set(update, forKey: "Update3")
        }
        
        KeychainWrapper.standard.set(true, forKey: "SignedInOnce")
        
        loadChatSessionId()
        
        checkChats()
        
        isOpen = false
        
        SignalsIsOpen = false
        MemberssIsOpen = false
        
        if isOpen == false {
            cellHolder.isUserInteractionEnabled = true
        }else{
            cellHolder.isUserInteractionEnabled = false
        }
        
        view.backgroundColor = UIColor.white
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.addSubview(refreshControl)
        cellHolder.alwaysBounceVertical = true
        
        cellHolder.register(DashboardSubheader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DashboardSubheaderCellId)
        cellHolder.register(DashboardHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DashboardHeaderCellId)
        cellHolder.register(DashboardWelcomeCell.self, forCellWithReuseIdentifier: DashboardWelcomeCellId)
        cellHolder.register(DashboardWelcomeTwoCell.self, forCellWithReuseIdentifier: DashboardWelcomeTwoCellId)
        cellHolder.register(DashboardAdminQuickLinksCell.self, forCellWithReuseIdentifier: DashboardAdminQuickLinkCellId)
        cellHolder.register(DashboardQuickLinksCell.self, forCellWithReuseIdentifier: DashboardQuickLinkCellId)
        cellHolder.register(DashboardFeaturesCell.self, forCellWithReuseIdentifier: DashboardFeaturesCellId)
        cellHolder.register(DashboardCalendarCell.self, forCellWithReuseIdentifier: DashboardCalendarCellId)
        
        setupViews()
        
//        startMockNotification()
        
        startAnimations()
//        startImageTimer()
//        setupMenu()
        
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(openMenu))
//        let swipeGestureBack = UISwipeGestureRecognizer(target: self, action: #selector(closeMenu))
//        swipeGesture.direction = .right
//        swipeGestureBack.direction = .left
//        self.view.addGestureRecognizer(swipeGesture)
//        self.view.addGestureRecognizer(swipeGestureBack)
        
        registerForPushNotifications()
        
        checkUsers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(performProfileImageStore), name: Notification.Name("profileImageChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewDashboardVC.NotificationArrived(notification:)), name: NSNotification.Name("NewNotificationReceived"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(performLogout), name: Notification.Name("logoutTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openLOFTV), name: Notification.Name("lofTVTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openCoupons), name: Notification.Name("CouponsTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openAffiliateOverview), name: Notification.Name("AffiliateOverviewTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openCustomerService), name: Notification.Name("CustomerServiceTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openTeam), name: Notification.Name("TeamMembersTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendNotification), name: Notification.Name("SendNotificationTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendSignal), name: Notification.Name("SendSignalTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openExplore), name: Notification.Name("ExploreTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openWaitlist), name: Notification.Name("WaitlistTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openChat), name: Notification.Name("ChatTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openProfile), name: Notification.Name("ProfileTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openAffiliates), name: Notification.Name("AffiliatedTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadTapped), name: Notification.Name("UploadToLOFTVTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopRefresh), name: Notification.Name("FinishedReloadMembers"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startImageTimer()
    }
    
    @objc func stopRefresh() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }else{
            
        }
    }
    
    @objc func uploadTapped() {
        let vc = MMTVVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func displayNotification() {
        view.addSubview(notificationHolder)
        
        NSLayoutConstraint.activate([
            notificationHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            notificationHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 7),
            notificationHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -7),
            ])
        
        self.notificationHolder.transform = CGAffineTransform(translationX: 0, y: -200)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.notificationHolder.transform = CGAffineTransform(translationX: 0, y: -200)
            UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 4, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                self.notificationHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: { (_) in
                // add more
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    self.notificationHolder.transform = CGAffineTransform(translationX: 0, y: 0)
                    UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                        self.notificationHolder.transform = CGAffineTransform(translationX: 0, y: -200)
                    }, completion: { (_) in
                        // add more
                        self.notificationHolder.removeFromSuperview()
                    })
                })
            })
        }
    }
    
    @objc func openCoupons() {
        let vc = CouponsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openExplore() {
        let layout = UICollectionViewFlowLayout()
        
        let mainController = SwipingController(collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        
        navigationController?.pushViewController(mainController, animated: true)
        
//        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func openWaitlist() {
        let vc = WaitlistVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openAffiliateOverview() {
        let vc = AffiliateOverviewVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openAffiliates() {
        let vc = AffiliatesPageTwoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openChat() {
        let vc = ChatCategoryVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openCustomerService() {
        let vc = CustomerServiceVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openTeam() {
        let vc = TeamMembersVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openProfile() {
        let vc = NewMyProfileVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func sendNotification() {
        let vc = CreateNewUpdateVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func sendSignal() {
        let vc = CreateNewSignalVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func NotificationArrived(notification: Notification) {
        // Do your updating of labels or array here
        let userInfo = notification.userInfo
        print("new notification recieved on dashboard")
        print("notification here: \(String(describing: userInfo))")
        //        self.notifications.append(parsedNotification)
    }
    
    func setupNotifications() {
        let registered: String = UserDefaults.standard.string(forKey: "Notifications")!
        if registered == "accepted" {
            // run notification prompt
            registerForPushNotifications()
        }else if registered == "denied"{
            // ru
        }else{
            // ru
        }
    }
    
    @objc func openLOFTV() {
        let vc = lofTVVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            // 1.
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") //3
                guard granted else { return }
                self.getNotificationSettings()
        }
    }
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
            }
        }
    }
    

    @objc func performLogout() {
        let vc = NewLogoutVC()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func setupMenu() {
//        view.addSubview(menuHolder)
//
//        NSLayoutConstraint.activate([
//            menuHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            menuHolder.topAnchor.constraint(equalTo: view.topAnchor),
//            menuHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            ])
//
//        let v2 = NavBarView(frame: menuHolder.frame)
//        menuHolder.addSubview(v2)
//
//        NSLayoutConstraint.activate([
//            v2.leadingAnchor.constraint(equalTo: menuHolder.leadingAnchor),
//            v2.topAnchor.constraint(equalTo: menuHolder.topAnchor),
//            v2.bottomAnchor.constraint(equalTo: menuHolder.bottomAnchor),
//            v2.trailingAnchor.constraint(equalTo: menuHolder.trailingAnchor),
//            ])
        
    }
    
    @objc func openMenu() {
        if isOpen == false {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.menuHolder.transform = CGAffineTransform(translationX: -280, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                self.menuHolder.transform = CGAffineTransform(translationX: -280, y: 0)
                self.view.transform = CGAffineTransform(translationX: 280, y: 0)
            }) { (_) in
                // insert code here
                self.isOpen = true
                if self.isOpen == false {
                    self.cellHolder.isUserInteractionEnabled = true
                }else{
                    self.cellHolder.isUserInteractionEnabled = false
                }
            }
        }else{
//            self.view.transform = CGAffineTransform(translationX: 280, y: 0)
//            self.menuHolder.transform = CGAffineTransform(translationX: -560, y: 0)
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
//                self.menuHolder.transform = CGAffineTransform(translationX: -280, y: 0)
//                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//            }) { (_) in
//                // insert code here
//                self.isOpen = false
//            }
        }
    }
    
    @objc func closeMenu() {
        if isOpen == false {
            
        }else{
            self.view.transform = CGAffineTransform(translationX: 280, y: 0)
            self.menuHolder.transform = CGAffineTransform(translationX: -280, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                self.menuHolder.transform = CGAffineTransform(translationX: -280, y: 0)
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (_) in
                // insert code here
                self.isOpen = false
                if self.self.isOpen == false {
                    self.cellHolder.isUserInteractionEnabled = true
                }else{
                    self.cellHolder.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    func firstZoom() {
        
        self.imageHolder.transform = CGAffineTransform(scaleX: 0, y: 0)
//        self.profilePic.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.imageHolder.transform = CGAffineTransform(scaleX: 1, y: 1)
//            self.profilePic.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: -10)
//            self.profilePic.transform = CGAffineTransform(translationX: 0, y: -10)
            
            
        }) { (_) in
            // here
            self.bounceAnimation()
        }
    }
    
    func bounceAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.profilePic.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }) { (_) in
            // here
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.profilePic.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    
    
    func loadChatSessionId() {
        let myUrl = URL(string: "http://api.lionsofforex.com/chat/session")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        if accessToken != nil {
            let postString = ["email": accessToken] as! [String: String]
            // send http request to perform sign in
            Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                .responseJSON { response in
//                    print(response)
                    // to get json return value
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        //                        print(json)
                        if let userId = json.value(forKey: "success") as? String {
                            KeychainWrapper.standard.set(userId, forKey: "ChatSession")
                            print("chat session ID is: \(userId)")
                        }
                    }
            }
        }else{
            return
        }
    }
    
    func startAnimations() {
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
            self.loadAffiliateInfo()
            self.startAccountCheckerTimer()
            self.performProfileImageStore()
            //
        }
    }
    
    func checkChats() {
        DispatchQueue.main.async {
            let myUrl = URL(string: "https://api.lionsofforex.com/myaccount/user")
            let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
            let accessText = accessToken
            if accessText != nil {
                let postString = [ "email": accessText] as! [String: String]
                // send http request to perform sign in
                
                Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        print(response)
                        // to get json return value
                        if let result = response.result.value {
                            let json = result as! NSDictionary
                            print(json)
                            let userId = json.object(forKey: "success") as! NSDictionary
                            let packageID = userId.object(forKey: "package") as! String
                            
                            if packageID == "13" {
                                print("Signals")
                                KeychainWrapper.standard.set("13", forKey: "PackageId")
                                
                            }else if packageID == "14" {
                                print("Essentials")
                                KeychainWrapper.standard.set("14", forKey: "PackageId")
                                
                            }else if packageID == "15" {
                                print("Advanced")
                                KeychainWrapper.standard.set("15", forKey: "PackageId")
                                
                            }else if packageID == "31" {
                                print("Elite")
                                KeychainWrapper.standard.set("31", forKey: "PackageId")
                                
                            }else{
                                print("Grandfathered Package")
                                KeychainWrapper.standard.set("19", forKey: "PackageId")
                                
                            }
                            
                            if let errorId = json.value(forKey: "error") {
                                let errorURL = errorId as! String
                                print(errorURL)
                            }
                        }
                }
            }else{
                return
            }
        }
    }
    
    @objc func checkStatus() {
        // run function daily and check for status
        
        let userName: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        
        // Send HTTP Request to perform sign in
        let myUrl = URL(string: "http://api.lionsofforex.com/myaccount/user")
        
        if userName != nil {
            let postString = ["email": userName] as! [String: String]
            
            let task = Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
                    // to get json return value
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        if let Result = json.value(forKey: "error") {
                            print(Result)
                            return
                        }
                        else {
                            if let userId = json.object(forKey: "success") as? NSDictionary {
                                
                                if let status = userId.object(forKey: "active") as? String {
                                    if status == "1" {
                                        print("User is active")
                                    }else if status == "2" {
                                        print("Account needs attention")
                                    }else{
                                        print("User is inactive")
                                        self.performUserLogout()
                                    }
                                }
                            }
                        }
                    }
            }
            task.resume()
        }else{
            return
        }
    }
    
    func startAccountCheckerTimer() {
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(NewDashboardVC.checkStatus), userInfo: nil, repeats: true)

    }
    
    func startMockNotification() {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(NewDashboardVC.displayNotification), userInfo: nil, repeats: false)
        
    }
    
    func startImageTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(NewDashboardVC.checkImageUrl), userInfo: nil, repeats: false)
        
    }
    
    @objc func checkImageUrl() {
        let imageUrlID: String? = KeychainWrapper.standard.string(forKey: "profileImageUrl")
        
        let profilePictureURL = URL(string: "https://members.lionsofforex.com\(imageUrlID ?? "")")!
        
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: profilePictureURL) {
            (data, response, error) in
            if let e = error {
                print("Error downloading was unsuccessful \(e)")
            }else{
                if let res = response as? HTTPURLResponse {
                    print("downloaded profile image with response ocde \(res.statusCode)")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            if let imgData: NSData = (image).pngData() as NSData? {
                                UserDefaults.standard.set(imgData, forKey: "savedProfileImage")
                                NotificationCenter.default.post(name: Notification.Name("profileImageChanged"), object: nil)
                            }
                        }
                        
                        //                                        self.loadIt()
                    }else{
                        print("couldn't get a response")
                    }
                }
            }
        }
        downloadPicTask.resume()
    }
    
    func performUserLogout() {
        print("Logging Out...")
        // present loading overlay
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        let window = UIApplication.shared.keyWindow!
        // position Activity indicator in the center
        myActivityIndicator.center = window.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // remove loading overlay
            
            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            
            // execute this code
            KeychainWrapper.standard.removeObject(forKey: "accessToken")
            KeychainWrapper.standard.removeObject(forKey: "passToken")
            KeychainWrapper.standard.removeObject(forKey: "nameToken")
            KeychainWrapper.standard.removeObject(forKey: "statusToken")
            KeychainWrapper.standard.removeObject(forKey: "emailStatusToken")
            KeychainWrapper.standard.removeObject(forKey: "selectedCourse")
            KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
            KeychainWrapper.standard.removeObject(forKey: "selectedCourseName")
            KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
            KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
            KeychainWrapper.standard.removeObject(forKey: "profileImageUrl")
            KeychainWrapper.standard.removeObject(forKey: "numberOfLions")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateDate")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateName")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateCommision")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateVisitors")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateConversion")
            KeychainWrapper.standard.removeObject(forKey: "selectedAffiliateStatus")
            KeychainWrapper.standard.removeObject(forKey: "profileImage")
            KeychainWrapper.standard.removeObject(forKey: "profileImageUrl")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesVisitors")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesEarned")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesVisitors")
            KeychainWrapper.standard.removeObject(forKey: "affiliatesConversion")
            KeychainWrapper.standard.removeObject(forKey: "affiliateLockj")
            KeychainWrapper.standard.removeObject(forKey: "selectedSymbol")
            KeychainWrapper.standard.removeObject(forKey: "selectedType")
            KeychainWrapper.standard.removeObject(forKey: "selectedSignalDate")
            KeychainWrapper.standard.removeObject(forKey: "selectedPips")
            KeychainWrapper.standard.removeObject(forKey: "selectedSL")
            KeychainWrapper.standard.removeObject(forKey: "selectedTP")
            KeychainWrapper.standard.removeObject(forKey: "selectedEntry")
            KeychainWrapper.standard.removeObject(forKey: "currentPackage")
            KeychainWrapper.standard.removeObject(forKey: "lofMembers")
            KeychainWrapper.standard.removeObject(forKey: "selectedUpdate")
            //            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            myActivityIndicator.removeFromSuperview()
            self.checkUsers()
            //        self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    @objc func checkUsers() {
        if let user = KeychainWrapper.standard.string(forKey: "accessToken") {
            if user == "" {
                // USER NOT LOGGED IN
                
                let vc = WelcomeVC()
                let mainNav = UINavigationController(rootViewController: vc)
                mainNav.isNavigationBarHidden = true
                if #available(iOS 13.0, *) {
                    mainNav.isModalInPresentation = true
                } else {
                    // Fallback on earlier versions
                }
                self.present(mainNav, animated: false, completion: nil)
            }else{
                // USER LOGGED IN
            }
        }else{
            // USER NOT LOGGED IN
            let vc = WelcomeVC()
            let mainNav = UINavigationController(rootViewController: vc)
            mainNav.isNavigationBarHidden = true
            if #available(iOS 13.0, *) {
                mainNav.isModalInPresentation = true
            } else {
                // Fallback on earlier versions
            }
            self.present(mainNav, animated: false, completion: nil)
        }
    }
    
    func loadAffiliateInfo() {
        let myUrl = URL(string: "http://api.lionsofforex.com/affiliates/lions")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        if accessText != nil {
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
                        let saveNumberOfLions = KeychainWrapper.standard.set(userId, forKey: "numberOfLions")
                        print(saveNumberOfLions)
                    }
            }
        }else{
            return
        }
    }
    
    @objc func performProfileImageStore() {
        DispatchQueue.main.async {
            self.animationView.stop()
            self.pageOverlay.removeFromSuperview()
        }
    }
    
    
    //MARK this is the very first time I got this good at coding :) Stay blessed UNO!
    
    func loadIt() {
        let data = UserDefaults.standard.object(forKey: "savedProfileImage") as! NSData
        self.profilePic.image = UIImage(data: data as Data)
        DispatchQueue.main.async {
            self.animationView.stop()
            self.pageOverlay.removeFromSuperview()
            self.firstZoom()
        }
    }
    
    func profileImageFetch() {
        let imageUrl: String? = KeychainWrapper.standard.string(forKey: "profileImageUrl")
//        let indexPath = IndexPath(item: 0, section: 0)
        if imageUrl == nil {
            
//            let vc = DashboardHeader()
            self.profileImage.image = UIImage(named: "userblankprofile-1")!
            self.profilePic.image = UIImage(named: "userblankprofile-1")
//            self.cellHolder.reloadData()
            self.animationView.stop()
            self.pageOverlay.removeFromSuperview()
            self.firstZoom()
        }else{
//            let vc = DashboardHeader()
            let profileString = ("https://members.lionsofforex.com\(imageUrl ?? "")") as String
            print(profileString)
            
            self.profileImage.setImageFromURl(stringImageUrl: profileString)
            DispatchQueue.main.async {
                self.profilePic.setImageFromURl(stringImageUrl: profileString)
//                self.cellHolder.reloadData()
//                self.animationView.stop()
                self.pageOverlay.removeFromSuperview()
                self.firstZoom()
            }
        }
        
        
    }
    
    private func setupViews() {
        view.addSubview(backgroundImage)
        view.addSubview(topView)
        view.addSubview(topSpacer)
        view.addSubview(cellHolder)
//        topView.addSubview(imageHolder)
        topView.addSubview(titleLabel)
        topView.addSubview(menuButton)
//        imageHolder.addSubview(profilePic)
        view.addSubview(menuHolder)
        
        
        
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topSpacer.topAnchor.constraint(equalTo: view.topAnchor),
            topSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
//            imageHolder.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0),
//            imageHolder.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
//
//            profilePic.topAnchor.constraint(equalTo: imageHolder.topAnchor),
//            profilePic.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor),
//            profilePic.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor),
//            profilePic.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor),
            
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 5),
            
            menuButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -15),
            
            menuHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuHolder.topAnchor.constraint(equalTo: view.topAnchor),
            menuHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
        DispatchQueue.main.async {
            self.menuHolder.transform = CGAffineTransform(translationX: -280, y: 0)
            let v2 = NavBarView(frame: self.menuHolder.frame)
            self.menuHolder.addSubview(v2)
            
            NSLayoutConstraint.activate([
                v2.leadingAnchor.constraint(equalTo: self.menuHolder.leadingAnchor),
                v2.topAnchor.constraint(equalTo: self.menuHolder.topAnchor),
                v2.bottomAnchor.constraint(equalTo: self.menuHolder.bottomAnchor),
                v2.trailingAnchor.constraint(equalTo: self.menuHolder.trailingAnchor),
                ])
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 1
        }else if section == 3 {
            return 1
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardWelcomeCellId, for: indexPath) as! DashboardWelcomeCell
                if SignalsIsOpen == false {
                    
                    cell.cashLabel.text = "Tap to expand"
                    cell.graphHolder.isHidden = false
                }else{
                    
                    cell.cashLabel.text = "Tap to close"
                    cell.graphHolder.isHidden = true
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardWelcomeTwoCellId, for: indexPath) as! DashboardWelcomeTwoCell
                if MemberssIsOpen == false {
                    
                    cell.greetingLabel.text = "Tap to expand"
                }else{
                    
                    cell.greetingLabel.text = "Tap to close"
                }
                return cell
            }
        }else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardAdminQuickLinkCellId, for: indexPath) as! DashboardAdminQuickLinksCell
            return cell
        }else if section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardQuickLinkCellId, for: indexPath) as! DashboardQuickLinksCell
            return cell
        }else if section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardFeaturesCellId, for: indexPath) as! DashboardFeaturesCell
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCalendarCellId, for: indexPath) as! DashboardCalendarCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
//        let vc = DashboardFeaturesCell()
        
        if section == 0 {
            // MARK: Calculate cell size based on width aspect ratio
            if indexPath.row == 0 {
                // change sizes for open closed
                if SignalsIsOpen == false {
                    return CGSize(width: cellHolder.frame.width, height: 120)
                    
                }else{
                    return CGSize(width: cellHolder.frame.width, height: 420)
                }
                
            }else{
                if MemberssIsOpen == false {
                    return CGSize(width: cellHolder.frame.width, height: 155)
                }else{
                    return CGSize(width: cellHolder.frame.width, height: 455)
                }
                
            }
        }else if section == 1 {
            return CGSize(width: cellHolder.frame.width, height: 110)
        }else if section == 2 {
            return CGSize(width: cellHolder.frame.width, height: 120)
        }else if section == 3 {
            return CGSize(width: cellHolder.frame.width, height: 400)
        }else{
            return CGSize(width: cellHolder.frame.width, height: 300)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            if indexPath.row == 0 {
                if SignalsIsOpen == false{
                    print("expanding signals")
                    SignalsIsOpen = true
                    DispatchQueue.main.async {
                        self.cellHolder.reloadItems(at: [indexPath])
                    }
                }else{
                    print("closing signals")
                    SignalsIsOpen = false
                    DispatchQueue.main.async {
                        self.cellHolder.reloadItems(at: [indexPath])
                    }
                }
            }else{
                if MemberssIsOpen == false{
                    print("expanding members")
                    MemberssIsOpen = true
                    DispatchQueue.main.async {
                        self.cellHolder.reloadItems(at: [indexPath])
                    }
                }else{
                    print("closing members")
                    MemberssIsOpen = false
                    DispatchQueue.main.async {
                        self.cellHolder.reloadItems(at: [indexPath])
                    }
                }
            }
            print("map selected")
        }else if section == 1 {
            print("admin links selected")
        }else if section == 2 {
            print("quick links selected")
        }else if section == 3 {
            print("features selected")
        }else{
            print("calendar selected")
            let vc = LOFCalendarVC()
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: cellHolder.frame.width, height: 36)
        }else if section == 1 {
            return CGSize(width: cellHolder.frame.width, height: 36)
        }else if section == 2 {
            return CGSize(width: cellHolder.frame.width, height: 36)
        }else if section == 3 {
            return CGSize(width: cellHolder.frame.width, height: 36)
        }else{
            return CGSize(width: cellHolder.frame.width, height: 36)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }else if section == 1 {
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }else if section == 2 {
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }else if section == 3 {
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }else{
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DashboardSubheaderCellId, for: indexPath) as! DashboardSubheader
            headerView.titleLabel.text = "Overview"
            return headerView
        }else if section == 1 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DashboardSubheaderCellId, for: indexPath) as! DashboardSubheader
            headerView.titleLabel.text = "Admin Quick Links"
            return headerView
        }else if section == 2 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DashboardSubheaderCellId, for: indexPath) as! DashboardSubheader
            headerView.titleLabel.text = "Quick Links"
            return headerView
        }else if section == 3 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DashboardSubheaderCellId, for: indexPath) as! DashboardSubheader
            headerView.titleLabel.text = "Features"
            return headerView
        }else{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DashboardSubheaderCellId, for: indexPath) as! DashboardSubheader
            headerView.titleLabel.text = "LOF Calendar"
            return headerView
        }
        
    }
    
    func createNewMemo() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }else if section == 1 {
            return 20
        }else if section == 2 {
            return 20
        }else if section == 3 {
            return 20
        }else{
            return 20
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffset = self.cellHolder.contentOffset.y;
    }

    
    @objc func reloadMemberCounter() {
        print("reloading member count")
        NotificationCenter.default.post(name: Notification.Name("RefreshMemberCount"), object: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class DashboardHeader: UICollectionViewCell {
    
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "topPiece")
        view.contentMode = .scaleToFill
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.font = UIFont.init(name: "AvenirNextLTPro-Bold", size: 35)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Dashboard"
        label.numberOfLines = 1
        return label
    }()
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        view.widthAnchor.constraint(equalToConstant: 70).isActive = true
        view.layer.cornerRadius = 35
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let profilePic: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        backgroundColor = .clear
        setupViews()
        firstZoom()
    }
    
    func firstZoom() {
        
        self.imageHolder.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.profilePic.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.imageHolder.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.profilePic.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: -10)
            self.profilePic.transform = CGAffineTransform(translationX: 0, y: -10)
            
            
        }) { (_) in
            // here
            self.bounceAnimation()
        }
    }
    
    func bounceAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            self.profilePic.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }) { (_) in
            // here
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            self.profilePic.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    private func setupViews() {
        addSubview(backgroundImage)
        addSubview(titleLabel)
//        addSubview(imageHolder)
        
        NSLayoutConstraint.activate([
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            
//            imageHolder.centerYAnchor.constraint(equalTo: centerYAnchor),
//            imageHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DashboardSubheader: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "GorditaBold", size: 13)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Sublabel"
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DashboardWelcomeCell: UICollectionViewCell {
    
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "cell1")
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    let iconImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.init(red: 29/255, green: 34/255, blue: 45/255, alpha: 1)
        view.image = UIImage(named: "smallSignals")
        view.contentMode = .scaleAspectFit
//        view.layer.cornerRadius = 15
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    let imageHolder: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 29/255, green: 34/255, blue: 45/255, alpha: 1)
        view.image = UIImage(named: "")
        view.contentMode = .scaleAspectFit
//        view.image.edge
        view.layer.cornerRadius = 15
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    let graphHolder: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.init(red: 29/255, green: 34/255, blue: 45/255, alpha: 1)
        view.backgroundColor = .clear
        view.image = UIImage(named: "graphImage")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let mainCardHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 3
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    let bottomCardHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 3
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    let overTint: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.45)
        view.clipsToBounds = true
        return view
    }()
    
    let pipsAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "GorditaBlack", size: 25)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "0"
        label.numberOfLines = 1
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "PIPS CAUGHT"
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.font = UIFont.init(name: "GorditaBold", size: 11)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "SIGNALS"
        label.numberOfLines = 1
        return label
    }()
    
    let cashLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.font = UIFont.init(name: "GorditaBold", size: 11)
        label.textAlignment = .left
        label.textColor = UIColor.init(red: 150/255, green: 158/255, blue: 181/255, alpha: 1)
        label.numberOfLines = 1
        label.text = "Tap to expand"
        return label
    }()
    
    let curvedChart: LineChart = {
        let chart = LineChart()
        chart.isCurved = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .clear
        return chart
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        backgroundColor = .clear
        
        setupViews()
        
        pipCount()
        
        setupChart()
        
        DATA()
//        setupOverView()

    }
    
    func pipCount(){
        let myUrl = URL(string: "http://api.lionsofforex.com/signals/list")
        var request = URLRequest(url: myUrl!)
        let postString = ["email": "louismonteiro@gmail.com"]
        // send http request to perform sign in
        
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    //run this i wanna see what the output is
                    print()
                    
                    var myArray = ["0"]
                    var arrayTwo = [""]
                    if let innerJson = jsondata.dictionary?["success"]?.arrayValue {
                        for result in innerJson {
                            if let data  = result.dictionary {
                                
                                let pip = data["pips"]
                                let date = data["pips"]
                                
                                if  let pipString:String = pip?.description,
                                    let dateString:String = date?.description {
                                    if pipString != "null" {
                                        
                                        if let pipCount = pipString.components(separatedBy: " ").first {
                                            
                                            myArray.append(pipCount)
                                            arrayTwo.append(dateString)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        let intArray = myArray.map({Int($0) ?? 0})
                        let totalSum = intArray.reduce(0, +)
                        let stringTotal = String(totalSum)
                        print(intArray)
                        print(totalSum)
                        self.pipsAmount.text = "\(stringTotal)"
                    }
                }
        }
    }
    
//    func fetchInfo() {
//        let vc = NewDashboardVC()
//        self.nameLabel.text = vc.userNameString
//    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(imageHolder)
        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.axis = .horizontal
        stackViewOne.alignment = .center
        stackViewOne.spacing = 7
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewTwo = UIStackView()
        stackViewTwo.addArrangedSubview(pipsAmount)
        stackViewTwo.addArrangedSubview(subLabel)
        stackViewTwo.axis = .horizontal
        stackViewTwo.alignment = .center
        stackViewTwo.spacing = 4
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewThree = UIStackView()
        stackViewThree.addArrangedSubview(stackViewOne)
        stackViewThree.addArrangedSubview(stackViewTwo)
        stackViewThree.addArrangedSubview(cashLabel)
        stackViewThree.axis = .vertical
        stackViewThree.alignment = .leading
        stackViewThree.spacing = 8
        stackViewThree.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainCardHolder)
        addSubview(bottomCardHolder)
        mainCardHolder.addSubview(backgroundImage)
        mainCardHolder.addSubview(stackViewThree)
        mainCardHolder.addSubview(graphHolder)
        mainCardHolder.addSubview(iconImage)
        
        NSLayoutConstraint.activate([
            mainCardHolder.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//            mainCardHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            mainCardHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainCardHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            bottomCardHolder.topAnchor.constraint(equalTo: mainCardHolder.bottomAnchor, constant: 0),
            bottomCardHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bottomCardHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            backgroundImage.topAnchor.constraint(equalTo: mainCardHolder.topAnchor, constant: 0),
            backgroundImage.bottomAnchor.constraint(equalTo: mainCardHolder.bottomAnchor, constant: 0),
            backgroundImage.leadingAnchor.constraint(equalTo: mainCardHolder.leadingAnchor, constant: 0),
            backgroundImage.trailingAnchor.constraint(equalTo: mainCardHolder.trailingAnchor, constant: 0),
            
            stackViewThree.centerYAnchor.constraint(equalTo: mainCardHolder.centerYAnchor),
            stackViewThree.leadingAnchor.constraint(equalTo: mainCardHolder.leadingAnchor, constant: 20),
            
            graphHolder.topAnchor.constraint(equalTo: stackViewThree.topAnchor),
            graphHolder.bottomAnchor.constraint(equalTo: stackViewThree.bottomAnchor),
            graphHolder.leadingAnchor.constraint(equalTo: stackViewThree.trailingAnchor, constant: 20),
            graphHolder.trailingAnchor.constraint(equalTo: mainCardHolder.trailingAnchor, constant: -20),
            
            iconImage.centerYAnchor.constraint(equalTo: imageHolder.centerYAnchor, constant: 0),
            iconImage.centerXAnchor.constraint(equalTo: imageHolder.centerXAnchor, constant: 0),
//            iconImage.leadingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: 4),
//            iconImage.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: -4),
            ])
    }
    
    func DATA() -> [PointEntry] {
        var results: [PointEntry] = []
        let myUrl = URL(string: "http://api.lionsofforex.com/signals/list")
        var request = URLRequest(url: myUrl!)
        let postString = ["email": "louismonteiro@gmail.com"] as! [String: String]
        // send http request to perform sign in
        
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    //run this i wanna see what the output is
                    print()
                    
                    
                    var index = 0
                    if let innerJson = jsondata.dictionary?["success"]?.arrayValue {
                        for result in innerJson {
                            if let data  = result.dictionary {
                                
                                let pip = data["pips"]
                                let date = data["date"]
                                if  let pipString:String = pip?.description,
                                    let dateString:String = date?.description {
                                    if pipString != "null" {
                                        
//                                        print(pipString,dateString)
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "d MMM"
                                        
                                        if let firstString = pipString.components(separatedBy: " ").first {
//                                            print("first string is: \(firstString)")
                                            if let intString: Int = Int(firstString) {
//                                                print("int string is: \(intString)")
                                                let dateFormatterGet = DateFormatter()
                                                dateFormatterGet.dateFormat = "dd MMMM, h:mm a"
                                                
                                                var date = dateFormatterGet.date(from: dateString)
                                                //replace that zero with a index id later
                                                date?.addTimeInterval(TimeInterval(24*60*60*index))
                                                index = index + 1
                                                
                                                //                            print(PointEntry(value: Int(pipString)!, label: formatter.string(from: date!)))
                                                results.append(PointEntry(value: intString, label: formatter.string(from: date!)))
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
                DispatchQueue.main.async {
                    // we will update the graph here because we have all the POintEntry by noe
                    print(results.count)
                    self.curvedChart.dataEntries = results
                    //                    self.curvedlineChart.isCurved = true
                    
                }
        }
        
        return results
    }
    

    func setupChart() {
        bottomCardHolder.addSubview(curvedChart)
        
        NSLayoutConstraint.activate([
            curvedChart.topAnchor.constraint(equalTo: bottomCardHolder.topAnchor),
            curvedChart.bottomAnchor.constraint(equalTo: bottomCardHolder.bottomAnchor),
            curvedChart.leadingAnchor.constraint(equalTo: bottomCardHolder.leadingAnchor),
            curvedChart.trailingAnchor.constraint(equalTo: bottomCardHolder.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DashboardWelcomeTwoCell: UICollectionViewCell {
    
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "cell2")
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    let imageHolder: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.image = UIImage(named: "cellHolderCircle")
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 19
        view.heightAnchor.constraint(equalToConstant: 38).isActive = true
        view.widthAnchor.constraint(equalToConstant: 38).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    let mainCardHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 3
        view.heightAnchor.constraint(equalToConstant: 155).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    let bottomCardHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 3
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    let overTint: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.45)
        view.clipsToBounds = true
        return view
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "GorditaBlack", size: 25)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "0"
        label.numberOfLines = 1
        return label
    }()
    
    let refreshControl: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .white
        return view
    }()
    
    let trialAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "GorditaBlack", size: 25)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "0"
        label.numberOfLines = 1
        return label
    }()
    
    let sponsorAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "GorditaBlack", size: 25)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "0"
        label.numberOfLines = 1
        return label
    }()
    
    let unregisteredAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "GorditaBlack", size: 25)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "0"
        label.numberOfLines = 1
        return label
    }()
    
    let paidAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "GorditaBlack", size: 25)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "0"
        label.numberOfLines = 1
        return label
    }()
    
    let inactiveAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "GorditaBlack", size: 25)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "0"
        label.numberOfLines = 1
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "ACTIVE MEMBERS"
        label.numberOfLines = 1
        return label
    }()
    
    let trialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "TRIAL MEMBERS"
        label.numberOfLines = 1
        return label
    }()
    
    let SponsoredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "SPONSORED MEMBERS"
        label.numberOfLines = 1
        return label
    }()
    
    let PaidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "PAID MEMBERS"
        label.numberOfLines = 1
        return label
    }()
    
    let UnregisteredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "UNREGISTERED MEMBERS"
        label.numberOfLines = 1
        return label
    }()
    
    let InactiveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "INACTIVE MEMBERS"
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.font = UIFont.init(name: "GorditaBold", size: 11)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "SIGNALS"
        label.numberOfLines = 1
        return label
    }()
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.font = UIFont.init(name: "GorditaBold", size: 11)
        label.textAlignment = .left
        label.textColor = UIColor.init(red: 150/255, green: 158/255, blue: 181/255, alpha: 1)
        label.numberOfLines = 1
        label.text = "Around the world"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        backgroundColor = .clear
  
        setupViews()
        
        startAnimating()
        
        memberCount()
        
        NotificationCenter.default.addObserver(self, selector: #selector(memberCount), name: Notification.Name("RefreshMemberCount"), object: nil)
    }
    
    func setupOverView() {
        let v2 = CardVideoPlayer(frame: self.bounds)
        
        mainCardHolder.addSubview(v2)
        
        
        v2.topAnchor.constraint(equalTo: mainCardHolder.topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: mainCardHolder.bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: mainCardHolder.leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: mainCardHolder.trailingAnchor).isActive = true
        v2.alpha = 1
    }
    
    //    func fetchInfo() {
    //        let vc = NewDashboardVC()
    //        self.nameLabel.text = vc.userNameString
    //    }
    
    private func setupLabels() {
        let sponsorStackView = UIStackView()
        sponsorStackView.addArrangedSubview(sponsorAmountLabel)
        sponsorStackView.addArrangedSubview(SponsoredLabel)
        sponsorStackView.axis = .horizontal
        sponsorStackView.alignment = .center
        sponsorStackView.spacing = 4
        sponsorStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let trialStackView = UIStackView()
        trialStackView.addArrangedSubview(trialAmountLabel)
        trialStackView.addArrangedSubview(trialLabel)
        trialStackView.axis = .horizontal
        trialStackView.alignment = .center
        trialStackView.spacing = 4
        trialStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let paidStackView = UIStackView()
        paidStackView.addArrangedSubview(paidAmountLabel)
        paidStackView.addArrangedSubview(PaidLabel)
        paidStackView.axis = .horizontal
        paidStackView.alignment = .center
        paidStackView.spacing = 4
        paidStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let unregisteredStackView = UIStackView()
        unregisteredStackView.addArrangedSubview(unregisteredAmountLabel)
        unregisteredStackView.addArrangedSubview(UnregisteredLabel)
        unregisteredStackView.axis = .horizontal
        unregisteredStackView.alignment = .center
        unregisteredStackView.spacing = 4
        unregisteredStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let inactiveStackView = UIStackView()
        inactiveStackView.addArrangedSubview(inactiveAmountLabel)
        inactiveStackView.addArrangedSubview(InactiveLabel)
        inactiveStackView.axis = .horizontal
        inactiveStackView.alignment = .center
        inactiveStackView.spacing = 4
        inactiveStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let subStackView = UIStackView()
        subStackView.addArrangedSubview(inactiveStackView)
        subStackView.addArrangedSubview(unregisteredStackView)
        subStackView.addArrangedSubview(trialStackView)
        subStackView.addArrangedSubview(paidStackView)
        subStackView.addArrangedSubview(sponsorStackView)
        subStackView.axis = .vertical
        subStackView.alignment = .center
        subStackView.spacing = 10
        subStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomCardHolder.addSubview(subStackView)
        
        NSLayoutConstraint.activate([
            
            subStackView.centerYAnchor.constraint(equalTo: bottomCardHolder.centerYAnchor),
            subStackView.centerXAnchor.constraint(equalTo: bottomCardHolder.centerXAnchor, constant: 0)
            ])
        
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(imageHolder)
//        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.axis = .horizontal
        stackViewOne.alignment = .center
//        stackViewOne.spacing = 7
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewTwo = UIStackView()
        stackViewTwo.addArrangedSubview(amountLabel)
        stackViewTwo.addArrangedSubview(subLabel)
        stackViewTwo.axis = .horizontal
        stackViewTwo.alignment = .center
        stackViewTwo.spacing = 4
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let stackViewThree = UIStackView()
        stackViewThree.addArrangedSubview(stackViewOne)
        stackViewThree.addArrangedSubview(stackViewTwo)
        stackViewThree.addArrangedSubview(greetingLabel)
        stackViewThree.axis = .vertical
        stackViewThree.alignment = .center
        stackViewThree.spacing = 5
        stackViewThree.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        addSubview(mainCardHolder)
        addSubview(bottomCardHolder)
        mainCardHolder.addSubview(backgroundImage)
        mainCardHolder.addSubview(stackViewThree)
        
        
        
        NSLayoutConstraint.activate([
            mainCardHolder.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainCardHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainCardHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            bottomCardHolder.topAnchor.constraint(equalTo: mainCardHolder.bottomAnchor, constant: 0),
            bottomCardHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bottomCardHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            backgroundImage.topAnchor.constraint(equalTo: mainCardHolder.topAnchor, constant: 0),
            backgroundImage.bottomAnchor.constraint(equalTo: mainCardHolder.bottomAnchor, constant: 0),
            backgroundImage.leadingAnchor.constraint(equalTo: mainCardHolder.leadingAnchor, constant: 0),
            backgroundImage.trailingAnchor.constraint(equalTo: mainCardHolder.trailingAnchor, constant: 0),
            
            stackViewThree.centerYAnchor.constraint(equalTo: mainCardHolder.centerYAnchor),
            stackViewThree.centerXAnchor.constraint(equalTo: mainCardHolder.centerXAnchor, constant: 0),
            ])
    }
    
    @objc func startAnimating() {
        bottomCardHolder.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            refreshControl.centerXAnchor.constraint(equalTo: bottomCardHolder.centerXAnchor),
            refreshControl.centerYAnchor.constraint(equalTo: bottomCardHolder.centerYAnchor),
            ])
        refreshControl.startAnimating()
        memberCount()
    }
    
    @objc func memberCount() {
        
        let myUrl = URL(string: "http://api.lionsofforex.com/adminv2/all_members")
        var request = URLRequest(url: myUrl!)
        let postString = ["email": "delvanicci@gmail.com"]
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    //run this i wanna see what the output is
                    //                    print()
                    
                    var myArray = [String]()
                    var myUnregisteredArray = [String]()
                    var myPaidArray = [String]()
                    var mySponsoredArray = [String]()
                    var myInactiveArray = [String]()
                    var myTrialArray = [String]()
                    
                    if let iJson = jsondata.dictionary?["success"]?.arrayValue {
                        let mJson = JSON(iJson)
                        if let innerJson = mJson.array {
                            for result in innerJson {
                                if let data  = result.dictionary {
                                    let pip = data["active"]
                                    if  let pipString:String = pip?.description {
                                        if pipString == "1" {
                                            myArray.append(pipString)
                                            
                                            let trial = data["trial"]
                                            if  let pipString:String = trial?.description {
                                                if pipString == "1" {
                                                    myTrialArray.append("1")
                                                }else if pipString == "0" {
                                                    myPaidArray.append("1")
                                                }
                                            }
                                            
                                        }else if pipString == "0" {
                                            
                                            myInactiveArray.append("1")
                                        }
                                    }
                                    let sponsor = data["beta_user"]
                                    if  let pipString:String = sponsor?.description {
                                        if pipString == "1" {
                                            mySponsoredArray.append("1")
                                        }else if pipString == "0" {
                                        }
                                    }
                                    let register = data["verificated"]
                                    if  let pipString:String = register?.description {
                                        if pipString == "1" {
                                        }else if pipString == "0" {
                                            myUnregisteredArray.append("1")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        let intArray = myArray.map({Int($0) ?? 0})
                        let totalSum = intArray.reduce(0, +)
                        let stringTotal = String(totalSum)
                        
                        let intArrayInactive = myInactiveArray.map({Int($0) ?? 0})
                        let totalSumInactive = intArrayInactive.reduce(0, +)
                        let stringTotalInactive = String(totalSumInactive)
                        
                        let intArrayTrial = myTrialArray.map({Int($0) ?? 0})
                        let totalSumTrial = intArrayTrial.reduce(0, +)
                        let stringTotalTrial = String(totalSumTrial)
                        
                        let intArrayPaid = myPaidArray.map({Int($0) ?? 0})
                        let totalSumPaid = intArrayPaid.reduce(0, +)
                        let stringTotalPaid = String(totalSumPaid)
                        
                        let intArrayUnregistered = myUnregisteredArray.map({Int($0) ?? 0})
                        let totalSumUnregistered = intArrayUnregistered.reduce(0, +)
                        let stringTotalUnregistered = String(totalSumUnregistered)
                        
                        let intArraySponsored = mySponsoredArray.map({Int($0) ?? 0})
                        let totalSumSponsored = intArraySponsored.reduce(0, +)
                        let stringTotalSponsored = String(totalSumSponsored)
                        //                        print(intArray)
                        //                        print(totalSum)
                        
                        self.amountLabel.text = stringTotal
                        self.inactiveAmountLabel.text = stringTotalInactive
                        self.trialAmountLabel.text = stringTotalTrial
                        self.paidAmountLabel.text = stringTotalPaid
                        self.unregisteredAmountLabel.text = stringTotalUnregistered
                        self.sponsorAmountLabel.text = stringTotalSponsored
                        
                        self.refreshControl.stopAnimating()
                        self.setupLabels()
                        
                        NotificationCenter.default.post(name: Notification.Name("FinishedReloadMembers"), object: nil)
                    }
                }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CardVideoPlayer: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DashboardQuickLinksCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        layout.scrollDirection = .horizontal
        return cv
    }()
    
    let cellId = "DashboardSingleNavigationCellId"
    let myArray = ["Explore", "Chat", "Signals", "Affiliates", "Leaderboard"]
    
    let colorsArray = [UIColor.clear, UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1), UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1), UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1), UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1)]
    
    let opacityArray = [1, 0, 0, 0, 0]
    
    let iconImages = ["quick_explore", "quick_chat", "quick_signals", "quick_affiliates", "leaderboardIcon"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        
        cellHolder.register(SingleQuicklinkCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iP = myArray[indexPath.row]
        let iC = colorsArray[indexPath.row]
        let iA = opacityArray[indexPath.row]
        let iImage = iconImages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleQuicklinkCell
        cell.titleLabel.text = iP
        cell.imageHolder.backgroundColor = iC
        cell.backgroundImage.alpha = CGFloat(iA)
        cell.iconImage.image = UIImage(named: iImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if indexPath.row == 0 {
            print("explore selected")
            openSignals()
        }else if indexPath.row == 1 {
            print("chat selected")
            openChat()
        }else if indexPath.row == 2 {
            print("signals selected")
            openSignals()
        }else if indexPath.row == 3 {
            print("affiliates selected")
            openAffiliates()
        }else{
            print("leaderboard selected")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    @objc func openSignals() {
        NotificationCenter.default.post(name: Notification.Name("ExploreTapped"), object: nil)
        
    }
    
    @objc func openChat() {
        NotificationCenter.default.post(name: Notification.Name("ChatTapped"), object: nil)
    }
    
    @objc func openAffiliates() {
        NotificationCenter.default.post(name: Notification.Name("AffiliatedTapped"), object: nil)
    }
    
    @objc func openLeaderboard() {
        // opens education
        print("opening education")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Quick link cell class below

class SingleQuicklinkCell: UICollectionViewCell {
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "iconGradient")
        view.contentMode = .scaleToFill
        return view
    }()
    
    let iconImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.font = UIFont.init(name: "AvenirNextLTPro-Demi", size: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageHolder)
        imageHolder.addSubview(backgroundImage)
        imageHolder.addSubview(iconImage)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageHolder.topAnchor.constraint(equalTo: topAnchor),
            imageHolder.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: imageHolder.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor),
            
            iconImage.topAnchor.constraint(equalTo: imageHolder.topAnchor, constant: 10),
            iconImage.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 10),
            iconImage.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: -10),
            iconImage.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: -10),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DashboardAdminQuickLinksCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        layout.scrollDirection = .horizontal
        return cv
    }()
    
    let cellId = "DashboardSingleAdminNavigationCellId"
    let myArray = ["Send \nSignal", "Send \nNotification", "Upload to \nLOFtv","Team \nMembers", "Customer \nService", "Affiliate \nOverview", "Waitlist", "Coupons"]
    
    let colorsArray = [UIColor.black, UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), UIColor.black]
    
    let opacityArray = [1, 1, 1, 1, 1, 1, 1, 1]
    
    let iconImages = ["signal_quickLink-1", "notification_quickLink", "team_quickLink", "team_quickLink", "customerservice_quickLink", "team_quickLink", "team_quickLink", "coupon_quickLink"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        
        cellHolder.register(SingleAdminQuicklinkCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iP = myArray[indexPath.row]
        let iC = colorsArray[indexPath.row]
        let iA = opacityArray[indexPath.row]
//        let iImage = iconImages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleAdminQuicklinkCell
        cell.titleLabel.text = iP
        cell.backgroundImage.image = UIImage(named: iconImages[indexPath.row])
        cell.imageHolder.backgroundColor = iC
        cell.backgroundImage.alpha = CGFloat(iA)
//        cell.iconImage.image = UIImage(named: iImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if indexPath.row == 0 {
            print("create signal selected")
            sendSignal()
        }else if indexPath.row == 1 {
            print("send notification selected")
            sendNotification()
        }else if indexPath.row == 2 {
            print("Upload to loftv selected")
            loftvUpload()
        }else if indexPath.row == 3 {
            print("team members selected")
            teamMembers()
        }else if indexPath.row == 4 {
            print("customer service selected")
            teamMembers()
        }else if indexPath.row == 5 {
            print("customer service selected")
            affiliateOverview()
        }else if indexPath.row == 6 {
            print("Waitlist selected")
            waitlist()
        }else{
            print("coupons overview selected")
            coupon()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: cellHolder.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    @objc func sendSignal() {
        NotificationCenter.default.post(name: Notification.Name("SendSignalTapped"), object: nil)
    }
    
    @objc func sendNotification() {
        NotificationCenter.default.post(name: Notification.Name("SendNotificationTapped"), object: nil)
    }
    
    @objc func teamMembers() {
        NotificationCenter.default.post(name: Notification.Name("TeamMembersTapped"), object: nil)
    }
    
    @objc func customerService() {
        NotificationCenter.default.post(name: Notification.Name("CustomerServiceTapped"), object: nil)
    }
    
    @objc func loftvUpload() {
        NotificationCenter.default.post(name: Notification.Name("UploadToLOFTVTapped"), object: nil)
    }
    
    @objc func affiliateOverview() {
        NotificationCenter.default.post(name: Notification.Name("AffiliateOverviewTapped"), object: nil)
    }
    
    @objc func coupon() {
        NotificationCenter.default.post(name: Notification.Name("CouponsTapped"), object: nil)
    }
    
    @objc func waitlist() {
        NotificationCenter.default.post(name: Notification.Name("WaitlistTapped"), object: nil)
    }
    
    @objc func openLeaderboard() {
        // opens education
        print("opening education")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SingleAdminQuicklinkCell: UICollectionViewCell {
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
//        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "iconGradient")
        view.contentMode = .scaleToFill
        return view
    }()
    
    let iconImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "")
        view.isHidden = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.font = UIFont.init(name: "AvenirNextLTPro-Demi", size: 14)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageHolder)
        imageHolder.addSubview(backgroundImage)
        imageHolder.addSubview(iconImage)
        imageHolder.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageHolder.topAnchor.constraint(equalTo: topAnchor),
            imageHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 10),
            
            backgroundImage.topAnchor.constraint(equalTo: imageHolder.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor),
            
            iconImage.topAnchor.constraint(equalTo: imageHolder.topAnchor, constant: 10),
            iconImage.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 10),
            iconImage.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: -10),
            iconImage.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: -10),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DashboardFeaturesCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        layout.scrollDirection = .vertical
        return cv
    }()
    
    var estimateWidth = 160.0
    var cellMarginSize = 15
    
    let cellId = "DashboardSingleFeatureCellId"
    let myArray = ["Affiliates", "LOFtv", "Marketplace", "Logout"]
    let myArrayTwo = ["Detailed affiliates overview", "Watch webinars and exclusives", "Shop all things LOF", "All Done? Sign Out"]
    
    let iconImages = ["feature_profile", "feature_loftv", "feature_marketplace", "feature_logout"]
    
    let colorsArray = [UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1), UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 1), UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1), UIColor.init(red: 237/255, green: 54/255, blue: 46/255, alpha: 1)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        
        cellHolder.register(SingleFeatureCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
        setupGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iP = myArray[indexPath.row]
        let iD = myArrayTwo[indexPath.row]
        let iC = colorsArray[indexPath.row]
        let iconID = iconImages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleFeatureCell
        cell.titleLabel.text = iP
        cell.imageHolder.backgroundColor = iC
        cell.subtitleLabel.text = iD
        cell.iconImage.backgroundColor = .clear
        cell.iconImage.image = UIImage(named: iconID)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if indexPath.row == 0 {
            print("opening Affiliate overview")
//            profile()
        }else if indexPath.row == 1 {
            print("opening lofTV")
            lofTv()
        }else if indexPath.row == 2 {
            print("opening Marketplace")
        }else{
            print("performing logout")
            logout()
        }
    }
    
    @objc func logout() {
//        let mainController = NewLogoutVC() as UIViewController
//        let vc = NewLogoutVC()
//        let navigationController = UINavigationController(rootViewController: mainController)
//        navigationController.navigationBar.isHidden = true
//        var topVC = UIApplication.shared.keyWindow?.rootViewController
//        while((topVC?.presentedViewController) != nil) {
//            topVC = topVC!.presentedViewController
//        }
//
//        topVC?.present(navigationController, animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("logoutTapped"), object: nil)
    }
    
    @objc func lofTv() {
        NotificationCenter.default.post(name: Notification.Name("lofTVTapped"), object: nil)
        
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func profile() {
        NotificationCenter.default.post(name: Notification.Name("ProfileTapped"), object: nil)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: cellHolder.frame.height * 0.48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func setupGrid() {
        let flow = cellHolder.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.cellHolder.frame.size.width) / estimatedWidth)
        
        let margin = CGFloat(cellMarginSize * 2)
        
        let width = (self.cellHolder.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
    
}

// MARK: Feature cell class below

class SingleFeatureCell: UICollectionViewCell {
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        return view
    }()
    
    let iconImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.image = UIImage(named: "")
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AvenirNextLTPro-Bold", size: 14)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageHolder)
        imageHolder.addSubview(titleLabel)
        imageHolder.addSubview(subtitleLabel)
        imageHolder.addSubview(iconImage)
        
        NSLayoutConstraint.activate([
            imageHolder.topAnchor.constraint(equalTo: topAnchor),
            imageHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            subtitleLabel.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: -20),
            subtitleLabel.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: -20),
            
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -1),
            titleLabel.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 20),
            
            iconImage.topAnchor.constraint(equalTo: imageHolder.topAnchor, constant: 13),
            iconImage.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 10)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DashboardCalendarCell: UICollectionViewCell {
    
    let mainCardHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    let calendarImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "calendarHolder")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupViews()
    }
    
    private func setupViews() {
        addSubview(mainCardHolder)
        mainCardHolder.addSubview(calendarImage)
        
        NSLayoutConstraint.activate([
            mainCardHolder.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainCardHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            mainCardHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            mainCardHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            calendarImage.topAnchor.constraint(equalTo: mainCardHolder.topAnchor, constant: 0),
            calendarImage.bottomAnchor.constraint(equalTo: mainCardHolder.bottomAnchor, constant: 0),
            calendarImage.leadingAnchor.constraint(equalTo: mainCardHolder.leadingAnchor, constant: 0),
            calendarImage.trailingAnchor.constraint(equalTo: mainCardHolder.trailingAnchor, constant: 0),

            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
