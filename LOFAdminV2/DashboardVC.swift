//
//  DashboardVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyJSON
import Alamofire

class DashboardVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
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
    
    let leaderboardCardView: UIView = {
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
        imageView.image = UIImage(named: "BlankAvatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        let whiteColor = UIColor.white.cgColor
        imageView.layer.borderColor = whiteColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dashboardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dashboard"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let leadershipTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Leaderboard"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lockedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        return view
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
    
    let leaderboardBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Achievements_Card")
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
        label.text = "Lions of Forex members around the world"
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
        layout.scrollDirection = .horizontal
        cv.showsHorizontalScrollIndicator = false
        
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var currentAmount = Int()
    var newAmount = Int()
    
    private let ExploreCellId = "exploreCellId"
    private let SignalQVCellId = "signalQVCellId"
    private let EducationQVCellId = "educationQVCellId"
    private let LogoutCellId = "logoutCellId"
    private let BottomCellId = "bottomCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KeychainWrapper.standard.set(true, forKey: "SignedInOnce")
        profileImageFetch()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        scrollingView.delegate = self
        scrollingView.isScrollEnabled = true
        scrollingView.showsVerticalScrollIndicator = false
        scrollingView.contentSize = CGSize(width: view.frame.width, height: 2000)
//        startTimer()
//        listenerConnection()
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(openMe))
        holdGesture.minimumPressDuration = 4
        holdGesture.numberOfTapsRequired = 1
        
        dashboardHolder.addGestureRecognizer(holdGesture)

        topCollectionView.dataSource = self
        topCollectionView.delegate = self
        
        topCollectionView.register(ExploreCell.self, forCellWithReuseIdentifier: ExploreCellId)
        topCollectionView.backgroundColor = .clear
        
        
        bottomCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        
        bottomCollectionView.register(BottomDashBoardCell.self, forCellWithReuseIdentifier: BottomCellId)
        bottomCollectionView.backgroundColor = .clear
        
        checkChats()
        checkImage()
        setupLayout()
        countryCount()
        loadAffiliateInfo()
        loadChatSessionId()
        startAccountCheckerTimer()
        
        KeychainWrapper.standard.set("2", forKey: "numberOfLionsQ")
        
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    @objc func openMe() {
        print("gesture")
        
        let window = UIApplication.shared.keyWindow!
        let v2 = HiddenView()
        window.addSubview(v2)
        
        //                backGroundColor.addSubview(v2)
        
        v2.topAnchor.constraint(equalTo: dashboardHolder.topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: backGroundColor.bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        startTimer()
//        if CheckInternet.Connection(){
//            gotConnection()
//        }else{
//            noConnection()
//        }
//        listenerConnection()
    }
    
    func listenerConnection() {
        
    }
    
    var timerTest: Timer?
    
    
    var isConnected: Bool?
    
    
    var isDisconnected: Bool?
    
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(DashboardVC.checkForNotifications), userInfo: nil, repeats: true)
    }
    
    @objc func checkForNotifications() {
        // fetch amount of notifications from backend
        // code to perform fetch
        let resultAmount = 1
        currentAmount = resultAmount
        // replace old amount with new amount and display notificaion
        // code to perform fetch
        let newResultAmount = 2
        newAmount = newResultAmount
        //
        
        if newAmount > currentAmount {
            // display message and create notification
            // self result amount as new value of current
            
        }
        
        
    }
    
    @objc func setConnection() {
        if CheckInternet.Connection(){
            isConnected = true
            
            isDisconnected = false
            print(isDisconnected!)
        }else{
            isConnected = false
            isDisconnected = true
            print(isConnected!)
        }
//        DispatchQueue.main.async {
//            while self.isConnected == true {
//                self.gotConnection()
//                self.hideNoConnectionView()
//            }
//            while self.isDisconnected == false {
//                self.noConnection()
//            }
//        }
        
        
    }
    
    //loop this function to check connecton continuously

    
    
    let alertHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let alertTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.contentMode = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }()
    
    let gotAlertHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gotAlertTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.contentMode = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }()
    
    func noConnectionView() {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(alertHolder)
        alertHolder.addSubview(alertTitleLabel)
        
        // layout constraints
        NSLayoutConstraint.activate([
            alertHolder.heightAnchor.constraint(equalToConstant: 40),
            alertHolder.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 5),
            alertHolder.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
            alertHolder.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
            alertTitleLabel.centerYAnchor.constraint(equalTo: alertHolder.centerYAnchor),
            alertTitleLabel.heightAnchor.constraint(equalTo: alertHolder.heightAnchor),
            alertTitleLabel.leadingAnchor.constraint(equalTo: alertHolder.leadingAnchor, constant: 15),
            alertTitleLabel.trailingAnchor.constraint(equalTo: alertHolder.trailingAnchor, constant: -25)
            ])
    }
    
    func gotConnectionView() {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(gotAlertHolder)
        gotAlertHolder.addSubview(gotAlertTitleLabel)
        
        // layout constraints
        NSLayoutConstraint.activate([
            gotAlertHolder.heightAnchor.constraint(equalToConstant: 40),
            gotAlertHolder.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 5),
            gotAlertHolder.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
            gotAlertHolder.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
            gotAlertTitleLabel.centerYAnchor.constraint(equalTo: gotAlertHolder.centerYAnchor),
            gotAlertTitleLabel.heightAnchor.constraint(equalTo: gotAlertHolder.heightAnchor),
            gotAlertTitleLabel.leadingAnchor.constraint(equalTo: gotAlertHolder.leadingAnchor, constant: 15),
            gotAlertTitleLabel.trailingAnchor.constraint(equalTo: gotAlertHolder.trailingAnchor, constant: -25)
            ])
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func noConnection() {
        noConnectionView()
 
        alertHolder.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        alertHolder.layer.cornerRadius = 5
        alertTitleLabel.text = "No Internet Connection"
        
        alertHolder.alpha = 0.0
        alertHolder.transform = CGAffineTransform(translationX: 0, y: -10)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.alertHolder.alpha = 1
                self.alertHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        }
        
        
        // comment this out
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.alertHolder.transform = CGAffineTransform(translationX: 0, y: -10)
                self.alertHolder.alpha = 0
            }, completion: { (finish) in
                UIView.animate(withDuration: 0, animations: {
                    self.alertHolder.removeFromSuperview()
                })
            })
        }
        
        
    }
    
    func hideNoConnectionView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.alertHolder.removeFromSuperview()
                self.alertHolder.transform = CGAffineTransform(translationX: 0, y: -10)
                self.alertHolder.alpha = 0
            }, completion: nil)
        }
    }
    
    func hideConnectionView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.gotAlertHolder.removeFromSuperview()
                self.gotAlertHolder.transform = CGAffineTransform(translationX: 0, y: -10)
                self.gotAlertHolder.alpha = 0
            }, completion: nil)
        }
    }
    
    @objc func openChatVC() {
        let vc = ChatVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    func gotConnection() {
        gotConnectionView()
//        let window = UIApplication.shared.keyWindow!
        
        gotAlertHolder.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        gotAlertHolder.layer.cornerRadius = 5
        gotAlertTitleLabel.text = "Connected"
        
        gotAlertHolder.alpha = 0.0
        gotAlertHolder.transform = CGAffineTransform(translationX: 0, y: -10)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
            UIView.animate(withDuration: 0.5, animations: {
                self.gotAlertHolder.alpha = 1
                self.gotAlertHolder.transform = CGAffineTransform(translationX: 0, y: -10)
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.gotAlertHolder.transform = CGAffineTransform(translationX: 0, y: -10)
                    self.gotAlertHolder.alpha = 0
                }, completion: { (finish) in
                    UIView.animate(withDuration: 0, animations: {
                        self.gotAlertHolder.removeFromSuperview()
                    })
                })
            }
        }
    }
    

    
    
    func presentNoConnectionView() {
        
    }
    
  
    
    
    private func setupLayout() {
        view.addSubview(scrollingView)
        scrollingView.addSubview(backGroundColor)
        
        view.addSubview(dashboardHolder)
        dashboardHolder.addSubview(dashboardBorderImage)
        dashboardHolder.addSubview(dashboardTitleLabel)
        dashboardHolder.addSubview(profileImage)
//        dashboardHolder.addSubview(settingsButton)
        backGroundColor.addSubview(mainCardView)
        mainCardView.addSubview(cardViewBackgroundImage)
        mainCardView.addSubview(greetingLabel)
        mainCardView.addSubview(memberCountLabel)
        mainCardView.addSubview(greetingMessage)
        
        // set up collectionview 2.
        backGroundColor.addSubview(topCollectionView)
        backGroundColor.addSubview(bottomCollectionView)
        backGroundColor.addSubview(leaderboardCardView)
        leaderboardCardView.addSubview(leaderboardBackgroundImage)
        leaderboardCardView.addSubview(leadershipTitleLabel)
        leaderboardCardView.addSubview(lockedView)
        backGroundColor.addSubview(lofCalendar)
        lofCalendar.addSubview(calendarImage)
        
        // setup constraints
        NSLayoutConstraint.activate([
            scrollingView.topAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            scrollingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundColor.heightAnchor.constraint(equalToConstant: 1000),
            backGroundColor.widthAnchor.constraint(equalTo: view.widthAnchor),
            backGroundColor.topAnchor.constraint(equalTo: scrollingView.topAnchor),
            backGroundColor.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor),
            backGroundColor.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor),
            backGroundColor.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor),
//            dashboardHolder.heightAnchor.constraint(equalToConstant: 160),
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
            profileImage.heightAnchor.constraint(equalToConstant: 60),
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor, constant: -25),
//            settingsButton.bottomAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
//            settingsButton.heightAnchor.constraint(equalToConstant: 20),
//            settingsButton.widthAnchor.constraint(equalToConstant: 70),
//            settingsButton.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor, constant: -28),
            profileImage.bottomAnchor.constraint(equalTo: dashboardHolder.bottomAnchor, constant: -10),
            mainCardView.topAnchor.constraint(equalTo: scrollingView.topAnchor, constant: 30),
            mainCardView.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 25),
            mainCardView.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -25),
            mainCardView.heightAnchor.constraint(lessThanOrEqualTo: backGroundColor.heightAnchor, multiplier: 0.22),
            greetingLabel.topAnchor.constraint(equalTo: mainCardView.topAnchor, constant: 25),
            greetingLabel.leadingAnchor.constraint(equalTo: mainCardView.leadingAnchor, constant: 20),
            cardViewBackgroundImage.topAnchor.constraint(equalTo: mainCardView.topAnchor),
            cardViewBackgroundImage.bottomAnchor.constraint(equalTo: mainCardView.bottomAnchor),
            cardViewBackgroundImage.leadingAnchor.constraint(equalTo: mainCardView.leadingAnchor),
            cardViewBackgroundImage.trailingAnchor.constraint(equalTo: mainCardView.trailingAnchor),
            greetingMessage.bottomAnchor.constraint(equalTo: mainCardView.bottomAnchor, constant: -20),
            greetingMessage.leadingAnchor.constraint(equalTo: mainCardView.leadingAnchor, constant: 20),
            greetingMessage.trailingAnchor.constraint(equalTo: mainCardView.trailingAnchor, constant: -20),
            memberCountLabel.bottomAnchor.constraint(equalTo: greetingMessage.topAnchor, constant: -3),
            memberCountLabel.leadingAnchor.constraint(equalTo: mainCardView.leadingAnchor, constant: 20),
            memberCountLabel.trailingAnchor.constraint(equalTo: mainCardView.trailingAnchor, constant: -25),
            topCollectionView.topAnchor.constraint(equalTo: mainCardView.bottomAnchor, constant: 30),
            topCollectionView.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalTo: backGroundColor.heightAnchor, multiplier: 0.09),
            bottomCollectionView.heightAnchor.constraint(equalTo: backGroundColor.heightAnchor, multiplier: 0.16),
            bottomCollectionView.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 30),
            bottomCollectionView.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor),
            
            leaderboardCardView.heightAnchor.constraint(equalToConstant: 89),
            leaderboardCardView.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 25),
            leaderboardCardView.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -25),
            leaderboardCardView.topAnchor.constraint(equalTo: bottomCollectionView.bottomAnchor, constant: 30),
            
            leaderboardBackgroundImage.topAnchor.constraint(equalTo: leaderboardCardView.topAnchor),
            leaderboardBackgroundImage.bottomAnchor.constraint(equalTo: leaderboardCardView.bottomAnchor),
            leaderboardBackgroundImage.leadingAnchor.constraint(equalTo: leaderboardCardView.leadingAnchor),
            leaderboardBackgroundImage.trailingAnchor.constraint(equalTo: leaderboardCardView.trailingAnchor),
            
            lockedView.topAnchor.constraint(equalTo: leaderboardCardView.topAnchor),
            lockedView.bottomAnchor.constraint(equalTo: leaderboardCardView.bottomAnchor),
            lockedView.leadingAnchor.constraint(equalTo: leaderboardCardView.leadingAnchor),
            lockedView.trailingAnchor.constraint(equalTo: leaderboardCardView.trailingAnchor),
            
            lofCalendar.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor, constant: 30),
            lofCalendar.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor, constant: -30),
            lofCalendar.topAnchor.constraint(equalTo: leaderboardCardView.bottomAnchor, constant: 30),
            lofCalendar.heightAnchor.constraint(equalToConstant: 250),
            calendarImage.heightAnchor.constraint(equalTo: lofCalendar.heightAnchor),
            calendarImage.widthAnchor.constraint(equalTo: lofCalendar.widthAnchor),
            calendarImage.topAnchor.constraint(equalTo: lofCalendar.topAnchor),
            calendarImage.bottomAnchor.constraint(equalTo: lofCalendar.bottomAnchor),
            calendarImage.leadingAnchor.constraint(equalTo: lofCalendar.leadingAnchor),
            calendarImage.trailingAnchor.constraint(equalTo: lofCalendar.trailingAnchor),
            
            leadershipTitleLabel.topAnchor.constraint(equalTo: leaderboardCardView.topAnchor, constant: 30),
            leadershipTitleLabel.bottomAnchor.constraint(equalTo: leaderboardCardView.bottomAnchor, constant: -30),
            leadershipTitleLabel.leadingAnchor.constraint(equalTo: leaderboardCardView.leadingAnchor, constant: 30),
            leadershipTitleLabel.trailingAnchor.constraint(equalTo: leaderboardCardView.trailingAnchor, constant: -30),
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == topCollectionView) {
            return 5
        }else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == topCollectionView) {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.tabTitle.text = "Explore"
                cell.tabHolderImage.image = UIImage(named: "Gradient1")
                cell.iconImage.image = UIImage(named: "ExploreIcon_Large")
                return cell
                
            }else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.tabTitle.text = "Chat"
                cell.tabHolderImage.image = UIImage(named: "Gradient2")
                cell.iconImage.image = UIImage(named: "Deselected_Chat_Icon")
                return cell
                
            }else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.tabTitle.text = "Signals"
                cell.tabHolderImage.image = UIImage(named: "Gradient3")
                cell.iconImage.image = UIImage(named: "SignalIcon_large")
                return cell
                
            }else if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.tabTitle.text = "Affiliates"
                cell.tabHolderImage.image = UIImage(named: "Gradient1")
                cell.iconImage.image = UIImage(named: "ExploreIcon_Large")
                return cell
                
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.tabTitle.text = "Logout"
                cell.tabHolderImage.image = UIImage(named: "Gradient4")
                cell.iconImage.image = UIImage(named: "")
                return cell
                
            }
        }else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCellId, for: indexPath) as! BottomDashBoardCell
                cell.tabTitle.text = "Watch LOFtv Now"
                cell.tabHolderImage.image = UIImage(named: "LOFTVBackground")
                cell.iconImage.image = UIImage(named: "LOFTVIcon_Large")
                return cell
            }else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCellId, for: indexPath) as! BottomDashBoardCell
                cell.tabTitle.text = "Shop All Things LOF"
                cell.tabHolderImage.image = UIImage(named: "MARKETPLACEBackground")
                cell.iconImage.image = UIImage(named: "MarketplaceIcon_Large")
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCellId, for: indexPath) as! BottomDashBoardCell
                cell.tabTitle.text = "My Profile"
                cell.tabHolderImage.image = UIImage(named: "SOCIALBackground")
                cell.iconImage.image = UIImage(named: "ProfileIcon_Large")
                return cell
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
        let offsetY: CGFloat = scrollView.contentOffset.y
        if offsetY < -64 {
            let progress:CGFloat = CGFloat(fabsf(Float(offsetY + 50)) / 100)
            self.dashboardBorderImage.transform = CGAffineTransform(scaleX: 1 + progress, y: 1 + progress)
//            self.dashboardTitleLabel.font.pointSize.advanced(by: 5) = CGAffineTransform(scaleX: 1 + progress, y: 1 + progress)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == topCollectionView) {
            return CGSize(width: backGroundColor.frame.width * 0.6, height: topCollectionView.frame.height)
        }else {
            return CGSize(width: topCollectionView.frame.width * 0.85, height: bottomCollectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == topCollectionView) {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.isSelected = true
                print("Explore Tapped")
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                let swipingController = SwipingController(collectionViewLayout: layout)
                self.present(swipingController, animated: true, completion: nil)
                
            }else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.isSelected = true
                print("ChatTapped")
                openChat()
                
            }else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.isSelected = true
                print("Signals QuickView Tapped")
                openSignals()
                
            }else if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.isSelected = true
                print("Affiliates Progress QuickView Tapped")
                let affiliateVC = AffiliatesPageTwoVC()
                affiliateVC.modalTransitionStyle = .crossDissolve
                present(affiliateVC, animated: true, completion: nil)

            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCellId, for: indexPath) as! ExploreCell
                cell.isSelected = true
                print("Logout Tapped")
                let window = UIApplication.shared.keyWindow!
                let v2 = LogoutVC()
                window.addSubview(v2)

                v2.topAnchor.constraint(equalTo: dashboardHolder.topAnchor).isActive = true
                v2.bottomAnchor.constraint(equalTo: backGroundColor.bottomAnchor).isActive = true
                v2.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor).isActive = true
                v2.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor).isActive = true

            }
        } else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCellId, for: indexPath) as! BottomDashBoardCell
                cell.isSelected = true
                print("Watch LOFtv Tapped")
                let lofTV = lofTVVC()
                lofTV.modalTransitionStyle = .crossDissolve
                present(lofTV, animated: true, completion: nil)
                
            }else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCellId, for: indexPath) as! BottomDashBoardCell
                cell.isSelected = true
                
//                print("Marketplace Tapped")
//                print("Present Coming Soon")
//                let window = UIApplication.shared.keyWindow
//                let v2 = ShopPlaceholderVC(frame: (window?.bounds)!)
//
//                backGroundColor.addSubview(v2)
//
//                v2.topAnchor.constraint(equalTo: backGroundColor.topAnchor).isActive = true
//                v2.bottomAnchor.constraint(equalTo: backGroundColor.bottomAnchor).isActive = true
//                v2.leadingAnchor.constraint(equalTo: backGroundColor.leadingAnchor).isActive = true
//                v2.trailingAnchor.constraint(equalTo: backGroundColor.trailingAnchor).isActive = true
                
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCellId, for: indexPath) as! BottomDashBoardCell
                cell.isSelected = true
                print("My Profile Tapped")
                let profileController = MyProfileVC()
                profileController.modalTransitionStyle = .crossDissolve
                present(profileController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    func checkImage() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DashboardVC.checkForProfileImageUpdate), userInfo: nil, repeats: true)
    }
    
    func checkChats() {
        DispatchQueue.main.async {
            let myUrl = URL(string: "https://api.lionsofforex.com/myaccount/user")
            let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
            let accessText = accessToken
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
                            
                        }else if packageID == "19" {
                            print("Grandfathered Package")
                            KeychainWrapper.standard.set("19", forKey: "PackageId")
                            
                        }else{
                            print("Elite")
                            KeychainWrapper.standard.set("31", forKey: "PackageId")
                        }
                        
                        if let errorId = json.value(forKey: "error") {
                            let errorURL = errorId as! String
                            print(errorURL)
                        }
                        
                        
                    }
            }
        }
    }
    
    func startAccountCheckerTimer() {
        Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(DashboardVC.checkStatus), userInfo: nil, repeats: true)
        
        // run function daily and check for status
        
        let userName: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        // position Activity indicator in the center
        let window = UIApplication.shared.keyWindow!
        myActivityIndicator.center = window.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        // Send HTTP Request to perform sign in
        let myUrl = URL(string: "http://api.lionsofforex.com/myaccount/user")
        
        let postString = ["email": userName] as! [String: String]
        
        let task = Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    
                    if let Result = json.value(forKey: "error") {
                        // if error rerunn this function
                        
                        
//                        self.displayMessage(userMessage: "\(String(describing: Result))")
                        print(Result)
                        
                    }
                    else {
                        let userId = json.object(forKey: "success") as! NSDictionary
                    
                        let status = userId.object(forKey: "active") as! String
                        
                        if status == "1" {
                            print("user active")
                        }else if status == "2" {
                            print("account needs attention")
                        }else{
                            print("account inactive")
                            self.performUserLogout()
                            
//                            DispatchQueue.main.async {
//                                let unregisteredVC = UnregisteredVC()
//                                let appDelegate = UIApplication.shared.delegate
//                                appDelegate?.window??.rootViewController = unregisteredVC
//                            }
                            
                        }
                        
                    }
                    
                    
                }
        }
        task.resume()
        
    }
    
    @objc func checkStatus() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (collectionView == topCollectionView) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        } else {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if (collectionView == topCollectionView) {
            return 30
        }else {
            return 20
        }
    }
    

    func performUserLogout() {
        print("Logging Out...")
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
        KeychainWrapper.standard.removeObject(forKey: "affiliateLock")
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
        KeychainWrapper.standard.removeObject(forKey: "ChatSession")
//        KeychainWrapper.standard.removeObject(forKey: "SignedInOnce")
        
        let loginVC = LoginVC()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = loginVC
//        self.present(loginVC, animated: true, completion: nil)
        
    }
    
    func profileImageFetch() {
        let imageUrl: String? = KeychainWrapper.standard.string(forKey: "profileImageUrl")
        
        if imageUrl == nil {
            self.profileImage.image = UIImage(named: "userblankprofile-1")
        }else{
            let profileString = ("https://members.lionsofforex.com\(imageUrl ?? "")") as String
            print(profileString)
            
            self.profileImage.setImageFromURl(stringImageUrl: profileString)
        }
        
        
    }
    
    @objc func checkForProfileImageUpdate() {
        let image: Bool? = KeychainWrapper.standard.bool(forKey: "DashboardProfileImageChanged")
        if image == nil {
            // perform skip image fetch
            
        }else if image == false {
            // perform skip image fetch
        }else{
            // perform image fetch
            profileImageFetch()
            KeychainWrapper.standard.set(false, forKey: "DashboardProfileImageChanged")
        }
    }
    
    func loadAffiliateInfo() {
        let myUrl = URL(string: "http://api.lionsofforex.com/affiliates/lions")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
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
    }
    
    func loadChatSessionId() {
        let myUrl = URL(string: "http://api.lionsofforex.com/chat/session")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
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
                    let saveNumberOfLions = KeychainWrapper.standard.set(userId, forKey: "ChatSession")
                    print(saveNumberOfLions)
                }
        }
    }
    
    func countryCount(){
        
        let myUrl = URL(string: "http://api.lionsofforex.com/dashboard/countries_count")
        var request = URLRequest(url: myUrl!)
        let postString = ["": ""]
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
                    if let innerJson = jsondata.array {
                        for result in innerJson {
                            if let data  = result.dictionary {
                                
                                let pip = data["subscribers"]
                                let date = data["country_name"]
                                if  let pipString:String = pip?.description,
                                    let dateString:String = date?.description {
                                    if pipString != "null" {
                                        
                                        myArray.append(pipString)
                                        arrayTwo.append(dateString)
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
                        KeychainWrapper.standard.set(stringTotal, forKey: "lofMembers")
                        let numberOfMembers: String? = KeychainWrapper.standard.string(forKey: "lofMembers")
                        self.memberCountLabel.text = "\(numberOfMembers ?? "---") Active Members"
                    }
                }
        }
    }
    
    @objc func settingsTapped() {
        print("Opening Settings")
        let settingsVC = SettingsVC()
        settingsVC.modalTransitionStyle = .crossDissolve
        present(settingsVC, animated: true, completion: nil)
    }
    
//    @objc func moreButtonTapped() {
//        print("more tapped")
////        let viewToAdd = AffiliatesPageTwoVC()
//        let window = UIApplication.shared.keyWindow
//        let v2 = AffiliatesPageTwoVC(frame: (window?.bounds)!)
//        view.addSubview(v2)
//
//        v2.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        v2.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        v2.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        v2.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//    }
    
    
    @objc func openSignals() {
        // opens swiping controller
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingController = SwipingController(collectionViewLayout: layout)
        self.present(swipingController, animated: true, completion: nil)
    }
    
    @objc func openChat() {
        // opens swiping controller
        let mainController = ChatCategoryVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        //        navigationController.modalTransitionStyle = .crossDissolve
        topVC?.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func openChatCategories() {
        let mainController = ChatCategoryVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        //        navigationController.modalTransitionStyle = .crossDissolve
        topVC?.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func openEducation() {
        // opens education
        print("opening education")
    }
    
    
}

