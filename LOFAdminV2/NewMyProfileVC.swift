//
//  NewMyProfileVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 4/10/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import Lottie

protocol controlsProfile {
    func startAnimating()
    func changeProfileImageTapped()
}

class NewMyProfileVC: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, controlsProfile {
    
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
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Back_Icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2 ,bottom: 2, right: 2)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "Share_Icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .lightGray
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return button
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    let cellIdPic = "profilePicCellId"
    let cellIdMain = "profileMainCellId"
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    let myPickerController = UIImagePickerController()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        let vc = MainProfileCell()
        vc.delegate = self
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        myPickerController.allowsEditing = true
        
        cellHolder.register(ProfileImageCell.self, forCellWithReuseIdentifier: cellIdPic)
        cellHolder.register(MainProfileCell.self, forCellWithReuseIdentifier: cellIdMain)
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeProfileImageTapped), name: Notification.Name("openChangeProfile"), object: nil)
        
    }
    
    @objc func changeProfileImageTapped() {
        print("Change profile image Tapped")
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func startAnimating() {
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
//            self.pipCount()
//            self.handleWalkthrough()
//            self.fetchSignals()
//            
            
            //
        }
    }
    
    private func setupViews() {
        view.addSubview(cellHolder)
        view.addSubview(bottomSpacer)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            shareButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            shareButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            bottomSpacer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdPic, for: indexPath) as! ProfileImageCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdMain, for: indexPath) as! MainProfileCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        if section == 0 {
            return CGSize(width: cellHolder.frame.width, height: 400)
        }else{
            return CGSize(width: cellHolder.frame.width, height: 500)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }else{
            return 40
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareTapped() {
        print("share Tapped")
        let referral: String? = KeychainWrapper.standard.string(forKey: "affiliatesLink")
        startAnimating()
        displayShareSheet(shareContent: "Join the pride and start earning Today! Click the link to register \n\n\(referral ?? "")")
    }

    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
        self.animationView.stop()
        self.pageOverlay.removeFromSuperview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
}

class ProfileImageCell: UICollectionViewCell {
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        view.clipsToBounds = true
        return view
    }()
    
    let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.heightAnchor.constraint(equalToConstant: 17).isActive = true
        view.widthAnchor.constraint(equalToConstant: 17).isActive = true
        view.layer.cornerRadius = 8.5
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 51/255, green: 54/255, blue: 64/255, alpha: 1)
        view.clipsToBounds = true
        return view
    }()
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 180).isActive = true
        view.widthAnchor.constraint(equalToConstant: 180).isActive = true
        view.layer.cornerRadius = 90
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let profilePic: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 150).isActive = true
        iv.layer.cornerRadius = 75
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AvenirNextLTPro-Bold", size: 30)
        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    let accountType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AvenirNextLTPro-Demi", size: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 1
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AvenirNextLTPro-Demi", size: 14)
        label.textAlignment = .center
        label.textColor = UIColor.init(white: 1, alpha: 0.7)
        
        label.text = "Acount Status: Active"
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        performProfileImageStore()
        configureLabels()
        setupViews()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(performProfileImageStore), name: Notification.Name("profileImageChanged"), object: nil)
    }
    
    func configureLabels() {
        let name: String? = KeychainWrapper.standard.string(forKey: "nameToken")
        let id: String? = KeychainWrapper.standard.string(forKey: "PackageId")
        let status: String? = KeychainWrapper.standard.string(forKey: "")
        
        titleLabel.text = name
        
        if id == "13" {
            accountType.text = "Signals Member"
        }else if id == "14" {
            accountType.text = "Essentials Member"
        }else if id == "15" {
            accountType.text = "Advanced Member"
        }else if id == "19" {
            accountType.text = "Grandfathered Package Member"
        }else if id == "31" {
            accountType.text = "Elite Member"
        }else{
            accountType.text = "LOF Member"
        }
        
        if status == "" {
            
        }else if status == "" {
            
        }else if status == "" {
            
        }else{
            
        }
    }
    
    @objc func performProfileImageStore() {
        
        let data = UserDefaults.standard.object(forKey: "savedProfileImage") as! NSData
        self.profilePic.image = UIImage(data: data as Data)
        DispatchQueue.main.async {
            print("profile fetched")
            self.firstZoom()
        }
    }
    
    func firstZoom() {
        
        self.imageHolder.transform = CGAffineTransform(scaleX: 0, y: 0)
//        self.profilePic.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.indicator.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.imageHolder.transform = CGAffineTransform(scaleX: 1, y: 1)
//            self.profilePic.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: -10)
//            self.profilePic.transform = CGAffineTransform(translationX: 0, y: -10)
            self.indicator.alpha = 0
            
        }) { (_) in
            // here
            self.bounceAnimation()
        }
    }
    
    func bounceAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.profilePic.transform = CGAffineTransform(translationX: 0, y: 0)
            self.indicator.alpha = 1
        }) { (_) in
            // here
            self.imageHolder.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.profilePic.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.addArrangedSubview(accountType)
        stackViewOne.addArrangedSubview(statusLabel)
        stackViewOne.spacing = 5
        stackViewOne.axis = .vertical
        stackViewOne.alignment = .center
        
        addSubview(topView)
        addSubview(bottomView)
        topView.addSubview(imageHolder)
        imageHolder.addSubview(profilePic)
        bottomView.addSubview(stackViewOne)
        addSubview(indicator)

        
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageHolder.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            imageHolder.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            stackViewOne.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            stackViewOne.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            
            profilePic.centerYAnchor.constraint(equalTo: imageHolder.centerYAnchor),
            profilePic.centerXAnchor.constraint(equalTo: imageHolder.centerXAnchor),
            
            indicator.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: -20),
            indicator.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: -20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MainProfileCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var delegate: controlsProfile?
    
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
    
    var estimateWidth = 160.0
    var cellMarginSize = 15
    
    let cellId = "SingleProfileCellId"
    let myArray = ["Change Plan", "Language", "Account Info", "Change Profile Picture", "Change Password", "Watch Walkthrough"]
    let colorsArray = [UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1), UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1), UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1), UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1),UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1), UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        estimateWidth = Double(cellHolder.frame.width * 0.5)
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        
        cellHolder.register(SingleProfileCell.self, forCellWithReuseIdentifier: cellId)
        
        backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        setupGrid()
        setupViews()
        
        
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
    
    private func setupViews() {
        addSubview(cellHolder)
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iD = myArray[indexPath.row]
        let iC = colorsArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleProfileCell
        cell.titleLabel.text = iD
        cell.imageHolder.backgroundColor = iC
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: cellHolder.frame.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("change plan tapped")
        }else if indexPath.row == 1 {
            print("change language tapped")
        }else if indexPath.row == 2 {
            print("account info tapped")
        }else if indexPath.row == 3 {
            print("change profile photo tapped")
            openChangeProfilePhoto()
        }else if indexPath.row == 4 {
            print("change password tapped")
            openChangePassword()
        }else{
            print("watch walkthrough tapped")
            resetWalkthrough()
            openWalkthrough()
        }
    }
    
    @objc func openChangePassword() {
        // present view controller
        let mainController = ChangePasswordVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        
        topVC?.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func openChangeProfilePhoto() {
        self.delegate?.changeProfileImageTapped()
        NotificationCenter.default.post(name: Notification.Name("openChangeProfile"), object: nil)
    }
    
    @objc func openWalkthrough() {
        // present view controller
        let layout = UICollectionViewFlowLayout()
        let mainController = WalkthroughSwipingController(collectionViewLayout: layout) as UICollectionViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        layout.scrollDirection = .horizontal
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        
        topVC?.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func resetWalkthrough() {
        KeychainWrapper.standard.removeObject(forKey: "SawSignalsWalkthrough")
        KeychainWrapper.standard.removeObject(forKey: "SawResourcesWalkthrough")
        KeychainWrapper.standard.removeObject(forKey: "SawEducationWalkthrough")
        KeychainWrapper.standard.removeObject(forKey: "SawNotificationsWalkthrough")
        KeychainWrapper.standard.removeObject(forKey: "SawAffiliatesWalkthrough")
        KeychainWrapper.standard.removeObject(forKey: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SingleProfileCell: UICollectionViewCell {
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        return view
    }()
    
    let iconImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "")
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AvenirNextLTPro-Demi", size: 12)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
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
//        imageHolder.addSubview(subtitleLabel)
        imageHolder.addSubview(iconImage)
        
        NSLayoutConstraint.activate([
            imageHolder.topAnchor.constraint(equalTo: topAnchor),
            imageHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            
//            subtitleLabel.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: -20),
//            subtitleLabel.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 20),
//            subtitleLabel.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: -20),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            titleLabel.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: -15),
            
            iconImage.topAnchor.constraint(equalTo: imageHolder.topAnchor, constant: 13),
            iconImage.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor, constant: 10)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewMyProfileVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //start loading
        self.dismiss(animated: true, completion: nil)
        startAnimating()
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
//        self.profileImage.image = image
        
        let imageData:NSData = image!.jpegData(compressionQuality: 0.5)! as NSData
//        let imageForReload: NSData = image!.pngData()! as NSData
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as String
        
        
        
        print(imageStr)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let profileURL = "data:image/jpeg;base64,\(imageStr)"
            let myUrl = URL(string: "https://api.lionsofforex.com/myaccount/photo")
            let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
            let accessText = accessToken
            let postString = [ "email": accessText, "photo": profileURL, "format": "jpeg"] as! [String: String]
            // send http request to perform sign in
            
            Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    // to get json return value
                    if let result = response.result.value {
                        let json = result as! NSDictionary
//                        print(json)
                        if let userId = json.value(forKey: "success") {
                            let newURL = userId as! String
                            // end animation
                            self.pageOverlay.removeFromSuperview()
                            self.animationView.stop()
                            self.displayMessage(userMessage: "profile image upload success")
                            NotificationCenter.default.post(name: Notification.Name("profileImageChanged"), object: nil)
                            KeychainWrapper.standard.set(true, forKey: "ProfileImageChanged")
                            KeychainWrapper.standard.set(true, forKey: "DashboardProfileImageChanged")
                            KeychainWrapper.standard.set(true, forKey: "SwipingProfileImageChanged")
                            print(newURL)
                            UserDefaults.standard.set(imageData, forKey: "savedProfileImage")
                        }
                        if let errorId = json.value(forKey: "error") {
                            let errorURL = errorId as! String
                            print(errorURL)
                            self.pageOverlay.removeFromSuperview()
                            self.animationView.stop()
                            self.displayMessage(userMessage: "profile image upload failed")
                            // end animation
                            KeychainWrapper.standard.set(false, forKey: "ProfileImageChanged")
                            KeychainWrapper.standard.set(false, forKey: "DashboardProfileImageChanged")
                            KeychainWrapper.standard.set(false, forKey: "SwipingProfileImageChanged")
                        }
                        
                        
                    }
            }
        }
        
        
        
    }
    
}
