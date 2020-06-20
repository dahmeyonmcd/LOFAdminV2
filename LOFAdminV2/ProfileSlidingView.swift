//
//  ProfileSlidingView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class ProfileSlidingView: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let imageeView = UIImageView()
        imageeView.image = UIImage(named: "ProfileBackgroundImage")
        imageeView.contentMode = .scaleAspectFill
        imageeView.translatesAutoresizingMaskIntoConstraints = false
        return imageeView
    }()
    
    let bottomViewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userblankprofile-1")
        imageView.contentMode = .scaleAspectFill
        let newColor = UIColor.white.cgColor
        imageView.layer.borderColor = newColor
        imageView.layer.borderWidth = 4
        imageView.layer.cornerRadius = 65
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        let userName: String = KeychainWrapper.standard.string(forKey: "nameToken") ?? "User"
        label.text = userName
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changeProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Profile Image", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(changeProfileImageTapped), for: .touchUpInside)
        return button
    }()
    
    let membershipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.text = "Membership: Active"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pageIndicator: UIPageControl = {
        let pC = UIPageControl()
        pC.translatesAutoresizingMaskIntoConstraints = false
        pC.numberOfPages = 4
        pC.currentPage = 1
        pC.currentPageIndicatorTintColor = .white
        pC.pageIndicatorTintColor = .gray
        return pC
    }()
    
    let saveChangesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        button.addTarget(self, action: #selector(saveChangesTapped), for: .touchUpInside)
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonUnderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imagePicker = UIImagePickerController()
    
    let ProfileCellOneId = "profilePageOneCellId"
    let ProfileCellTwoId = "profilePageTwoCellId"
    let ProfileCellThreeId = "profilePageThreeCellId"
    let ProfileCellFourId = "profilePageFourCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageFetch()
        collectionView.isPagingEnabled = true
        collectionView.isSpringLoaded = false
        collectionView.register(ProfilePageOneCell.self, forCellWithReuseIdentifier: ProfileCellOneId)
        collectionView.register(ProfilePageTwoCell.self, forCellWithReuseIdentifier: ProfileCellTwoId)
        collectionView.register(ProfilePageThreeCell.self, forCellWithReuseIdentifier: ProfileCellThreeId)
        collectionView.register(ProfilePageFourCell.self, forCellWithReuseIdentifier: ProfileCellFourId)
        collectionView.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        setupOverView()
        setupKeyboardDismissRecognizer()
    }
    
    func setImageRadius() {
        let newColor = UIColor.white.cgColor
        profileImage.layer.borderColor = newColor
        profileImage.layer.borderWidth = 4
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
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
    
    func setupOverView() {
        view.addSubview(topView)
        topView.addSubview(backgroundImage)
        topView.addSubview(bottomViewHolder)
        topView.addSubview(profileImage)
        bottomViewHolder.addSubview(changeProfileButton)
        bottomViewHolder.addSubview(nameLabel)
        bottomViewHolder.addSubview(membershipLabel)
        bottomViewHolder.addSubview(pageIndicator)
        topView.addSubview(backHomeButton)
        view.addSubview(saveChangesButton)
        view.addSubview(buttonUnderView)
        
        // setup constraints
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 400),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.5),
            backgroundImage.widthAnchor.constraint(equalTo: topView.widthAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            bottomViewHolder.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor),
            bottomViewHolder.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomViewHolder.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            bottomViewHolder.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            bottomViewHolder.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.5),
            profileImage.widthAnchor.constraint(equalToConstant: 130),
            profileImage.heightAnchor.constraint(equalToConstant: 130),
            profileImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            pageIndicator.bottomAnchor.constraint(equalTo: bottomViewHolder.bottomAnchor),
            pageIndicator.centerXAnchor.constraint(equalTo: bottomViewHolder.centerXAnchor),
            pageIndicator.heightAnchor.constraint(equalToConstant: 15),
            membershipLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            membershipLabel.leadingAnchor.constraint(equalTo: bottomViewHolder.leadingAnchor, constant: 30),
            membershipLabel.trailingAnchor.constraint(equalTo: bottomViewHolder.trailingAnchor, constant: -30),
            membershipLabel.centerXAnchor.constraint(equalTo: bottomViewHolder.centerXAnchor),
            membershipLabel.heightAnchor.constraint(equalToConstant: 20),
            nameLabel.topAnchor.constraint(equalTo: changeProfileButton.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: bottomViewHolder.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            backHomeButton.heightAnchor.constraint(equalToConstant: 40),
            backHomeButton.widthAnchor.constraint(equalToConstant: 40),
            backHomeButton.trailingAnchor.constraint(equalTo: bottomViewHolder.trailingAnchor, constant: -20),
            backHomeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            saveChangesButton.heightAnchor.constraint(equalToConstant: 50),
            saveChangesButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            saveChangesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonUnderView.topAnchor.constraint(equalTo: saveChangesButton.bottomAnchor),
            buttonUnderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            changeProfileButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            changeProfileButton.leadingAnchor.constraint(equalTo: bottomViewHolder.leadingAnchor, constant: 30),
            changeProfileButton.trailingAnchor.constraint(equalTo: bottomViewHolder.trailingAnchor, constant: -30),
            changeProfileButton.centerXAnchor.constraint(equalTo: bottomViewHolder.centerXAnchor),
            changeProfileButton.heightAnchor.constraint(equalToConstant: 20),
            
            ])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellOneId, for: indexPath) as! ProfilePageOneCell
            return cell
            
        }else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellTwoId, for: indexPath) as! ProfilePageTwoCell
            return cell
            
        }else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellThreeId, for: indexPath) as! ProfilePageThreeCell
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellFourId, for: indexPath) as! ProfilePageFourCell
            return cell
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
    }
    
    @objc func dashboardTapped() {
        print("Dashboard Tapped")
        dismiss(animated: true, completion: nil)
    }
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func changeProfileImageTapped() {
        print("Change profile image Tapped")
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("ButtonCapture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func saveChangesTapped() {
        print("save changes tapped")
    }
    
    @objc func goToPageTwo() {
//        let vc = AffiliatesPageTwoVC()
//        present(vc, animated: false, completion: nil)
    }
    
}
