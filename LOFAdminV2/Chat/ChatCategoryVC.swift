//
//  ChatCategoryVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Lottie

class ChatCategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //        cv.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        cv.backgroundColor = .white
        
        layout.scrollDirection = .vertical
        return cv
    }()
    
    let menuNavBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        //        view.backgroundColor = .black
        view.backgroundColor = .white
        
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return view
    }()
    
    lazy var mainVC: ChatTableVC = {
        let vc = ChatTableVC()
        vc.DelegatedVC = self
        return vc
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        view.backgroundColor = .white
        return view
    }()
    
    let navBarTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        //        label.textColor = .white
        label.textColor = .black
        label.text = "Chatroom"
        label.textAlignment = .left
        label.contentMode = .center
        return label
    }()
    
    // MARK: Setup searchbar
    let searchHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 65).isActive = true
        return view
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.layer.cornerRadius = 5
        sb.clipsToBounds = true
        sb.barTintColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        sb.placeholder = "Search.."
        sb.isUserInteractionEnabled = false
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "MessagesBack"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    let spacerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ""), for: .normal)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = UIColor.black
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        //        button.backgroundColor = .clear
        button.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 0.4)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let spacerButtonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ""), for: .normal)
        button.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 0.2)
        button.layer.cornerRadius = 20
        button.isHidden = true
        button.clipsToBounds = true
        //        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let chatImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        //        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let chatrooms = ["Search", "Lions Den", "Lions Den Español", "Signals", "Essentials Members", "Advanced Members", "Elite Members"]
    let chatroomDescriptions = ["search", "Our general members chat, available to all members!", "Our general members chat, available to all members!", "Get real-time signals with updates, and trade analysis.", "An essentials members only chat.", "An advanced members only chat- more signals & trading support.", "The Elite only members chat- expert signals, trading support, signal analysis, & exclusive opportunitues!"]
    let chatroomId = ["0", "1", "7", "2", "3", "4", "5"]
    let chatroomImage = ["LionsDen", "LionsDen", "LionsDen", "Signals", "Essentials", "Advanced", "Elite"]
    let ChatRoomCellId = "chatRoomCellId"
    let SearchCellId = "searchCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        //        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        cellHolder.register(ChatRoomCell.self, forCellWithReuseIdentifier: ChatRoomCellId)
        cellHolder.register(SearchCellView.self, forCellWithReuseIdentifier: SearchCellId)
        
        setupView()
        startAnimations()
        
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
            self.profileImageFetch()
            
            //
        }
    }
    
    func setupView() {
        view.addSubview(menuNavBar)
        view.addSubview(menuTop)
        menuNavBar.addSubview(chatImage)
        menuNavBar.addSubview(navBarTitle)
        menuNavBar.addSubview(spacerButton)
        menuNavBar.addSubview(spacerButtonTwo)
        
        //        view.addSubview(searchHolder)
        //        searchHolder.addSubview(searchBar)
        
        view.addSubview(cellHolder)
        view.addSubview(bottomSpacer)
        
        
        NSLayoutConstraint.activate([
            menuNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: menuNavBar.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            
            bottomSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 0),
            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            menuTop.bottomAnchor.constraint(equalTo: menuNavBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            
            //            searchHolder.topAnchor.constraint(equalTo: menuNavBar.bottomAnchor),
            //            searchHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            searchHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //
            //            searchBar.topAnchor.constraint(equalTo: searchHolder.topAnchor, constant: 10),
            //            searchBar.bottomAnchor.constraint(equalTo: searchHolder.bottomAnchor, constant: -10),
            //            searchBar.leadingAnchor.constraint(equalTo: searchHolder.leadingAnchor, constant: 10),
            //            searchBar.trailingAnchor.constraint(equalTo: searchHolder.trailingAnchor, constant: -10),
            
            // MARK: setup menubar elements
            chatImage.heightAnchor.constraint(equalToConstant: 40),
            chatImage.widthAnchor.constraint(equalToConstant: 40),
            chatImage.centerYAnchor.constraint(equalTo: menuNavBar.centerYAnchor),
            chatImage.leadingAnchor.constraint(equalTo: menuNavBar.leadingAnchor, constant: 20),
            
            navBarTitle.leadingAnchor.constraint(equalTo: chatImage.trailingAnchor, constant: 10),
            navBarTitle.heightAnchor.constraint(equalToConstant: 40),
            navBarTitle.trailingAnchor.constraint(equalTo: spacerButton.leadingAnchor, constant: -20),
            navBarTitle.centerYAnchor.constraint(equalTo: menuNavBar.centerYAnchor),
            
            spacerButton.heightAnchor.constraint(equalToConstant: 40),
            spacerButton.widthAnchor.constraint(equalToConstant: 40),
            spacerButton.centerYAnchor.constraint(equalTo: menuNavBar.centerYAnchor),
            spacerButton.trailingAnchor.constraint(equalTo: menuNavBar.trailingAnchor, constant: -20),
            
            spacerButtonTwo.heightAnchor.constraint(equalToConstant: 40),
            spacerButtonTwo.widthAnchor.constraint(equalToConstant: 40),
            spacerButtonTwo.centerYAnchor.constraint(equalTo: menuNavBar.centerYAnchor),
            spacerButtonTwo.trailingAnchor.constraint(equalTo: spacerButton.leadingAnchor, constant: -10),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    func profileImageFetch() {
        if let imageURLID: String = KeychainWrapper.standard.string(forKey: "profileImageUrl") {
            if let url = URL(string: "https://members.lionsofforex.com/\(imageURLID)") {
                self.chatImage.setImageWith(url)
                DispatchQueue.main.async {
                    self.animationView.stop()
                    self.pageOverlay.removeFromSuperview()
                }
            }
        }
    }
    
    //    func profileImageFetch() {
    //        let imageUrl: String? = KeychainWrapper.standard.string(forKey: "profileImageUrl")
    //
    //        if imageUrl == nil {
    //            self.chatImage.image = UIImage(named: "userblankprofile-1")
    //        }else{
    //            let profileString = ("https://members.lionsofforex.com\(imageUrl ?? "")") as String
    //            print(profileString)
    //
    //            self.chatImage.setImageFromURl(stringImageUrl: profileString)
    //        }
    //
    //    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let PackageId: String? = KeychainWrapper.standard.string(forKey: "currentPlan")
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCellId, for: indexPath) as! SearchCellView
            return cell
        }else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
            //            let image = chatroomImage
            
            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
            cell.subLabel.text = chatroomDescriptions[indexPath.row]
            cell.titleLabel.text = chatrooms[indexPath.row]
            return cell
        }else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
            //            let image = chatroomImage
            
            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
            cell.subLabel.text = chatroomDescriptions[indexPath.row]
            cell.titleLabel.text = chatrooms[indexPath.row]
            return cell
        }else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
            //            let image = chatroomImage
            
            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
            cell.subLabel.text = chatroomDescriptions[indexPath.row]
            cell.titleLabel.text = chatrooms[indexPath.row]
            return cell
        }else if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
            //            let image = chatroomImage
            
//            if PackageId == "13" {
//                cell.isUserInteractionEnabled = false
//                cell.indicatorImage.image = UIImage(named: "ChatLocked")
//                cell.indicatorView.layer.cornerRadius = 0
//                cell.indicatorView.backgroundColor = .clear
//            }
            
            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
            cell.subLabel.text = chatroomDescriptions[indexPath.row]
            cell.titleLabel.text = chatrooms[indexPath.row]
            return cell
        }else if indexPath.row == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
            //            let image = chatroomImage
            
//            if PackageId == "13" {
//                cell.isUserInteractionEnabled = false
//                cell.indicatorImage.image = UIImage(named: "ChatLocked")
//                cell.indicatorView.layer.cornerRadius = 0
//                cell.indicatorView.backgroundColor = .clear
//            }
//            if PackageId == "14" {
//                cell.isUserInteractionEnabled = false
//                cell.indicatorImage.image = UIImage(named: "ChatLocked")
//                cell.indicatorView.layer.cornerRadius = 0
//                cell.indicatorView.backgroundColor = .clear
//            }
            
            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
            cell.subLabel.text = chatroomDescriptions[indexPath.row]
            cell.titleLabel.text = chatrooms[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
            
//            if PackageId == "13" {
//                cell.isUserInteractionEnabled = false
//                cell.indicatorImage.image = UIImage(named: "ChatLocked")
//                cell.indicatorView.layer.cornerRadius = 0
//                cell.indicatorView.backgroundColor = .clear
//            }
//            if PackageId == "14" {
//                cell.isUserInteractionEnabled = false
//                cell.indicatorImage.image = UIImage(named: "ChatLocked")
//                cell.indicatorView.layer.cornerRadius = 0
//                cell.indicatorView.backgroundColor = .clear
//            }
//            if PackageId == "15" {
//                cell.isUserInteractionEnabled = false
//                cell.indicatorImage.image = UIImage(named: "ChatLocked")
//                cell.indicatorView.layer.cornerRadius = 0
//                cell.indicatorView.backgroundColor = .clear
//            }
            //            let image = chatroomImage
            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
            cell.subLabel.text = chatroomDescriptions[indexPath.row]
            cell.titleLabel.text = chatrooms[indexPath.row]
            return cell
        }
        //        if indexPath.row == 0 {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCellId, for: indexPath) as! SearchCellView
        //            return cell
        //        }else if indexPath.row == 1 {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
        ////            let image = chatroomImage
        //
        //            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
        //            cell.subLabel.text = chatroomDescriptions[indexPath.row]
        //            cell.titleLabel.text = chatrooms[indexPath.row]
        //            return cell
        //        }else if indexPath.row == 2 {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
        //            //            let image = chatroomImage
        //
        //            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
        //            cell.subLabel.text = chatroomDescriptions[indexPath.row]
        //            cell.titleLabel.text = chatrooms[indexPath.row]
        //            return cell
        //        }else if indexPath.row == 3 {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
        //
        //
        //            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
        //            cell.subLabel.text = chatroomDescriptions[indexPath.row]
        //            cell.titleLabel.text = chatrooms[indexPath.row]
        //            return cell
        //        }else if indexPath.row == 4 {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
        //            //            let image = chatroomImage
        //
        //
        //            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
        //            cell.subLabel.text = chatroomDescriptions[indexPath.row]
        //            cell.titleLabel.text = chatrooms[indexPath.row]
        //            return cell
        //        }else{
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomCellId, for: indexPath) as! ChatRoomCell
        //
        //            //            let image = chatroomImage
        //            cell.chatImage.image = UIImage(named: chatroomImage[indexPath.item])
        //            cell.subLabel.text = chatroomDescriptions[indexPath.row]
        //            cell.titleLabel.text = chatrooms[indexPath.row]
        //            return cell
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let iD = chatroomId[indexPath.item] as? String
        //        let iP = chatroomImage[indexPath.item] as? String
        //        let iC = chatrooms[indexPath.item] as? String
        
        if indexPath.row == 0 {
            
        }else{
            print("cell selected")
            KeychainWrapper.standard.set(chatroomId[indexPath.item], forKey: "selectedMessage")
            KeychainWrapper.standard.set(chatroomImage[indexPath.item], forKey: "selectedMessageImage")
            KeychainWrapper.standard.set(chatrooms[indexPath.item], forKey: "selectedMessageRoom")
            //            mainVC.selectedRoomID = iD!
            // sets room id
            DispatchQueue.main.async {
                
                let vc = ChatViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: cellHolder.frame.width, height: 55)
        }else{
            return CGSize(width: cellHolder.frame.width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: true)
    }
    
}

class ChatRoomCell: UICollectionViewCell {
    
    let spacerLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.alpha = 0 // 0.3
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    let indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        view.heightAnchor.constraint(equalToConstant: 14).isActive = true
        view.widthAnchor.constraint(equalToConstant: 14).isActive = true
        return view
    }()
    
    let indicatorImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "Indicator")
        iv.clipsToBounds = true
        return iv
    }()
    
    let chatImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.layer.cornerRadius = 30
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.contentMode = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.darkGray
        label.text = "Text description goes here"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.contentMode = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        backgroundColor = UIColor.white
        
        setupView()
    }
    
    @objc func setupView() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.alignment = .leading
        stackViewOne.axis = .vertical
        stackViewOne.spacing = 5
        stackViewOne.distribution = .equalSpacing
        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.addArrangedSubview(subLabel)
        
        addSubview(spacerLine)
        addSubview(chatImage)
        addSubview(stackViewOne)
        addSubview(indicatorView)
        indicatorView.addSubview(indicatorImage)
        
        
        NSLayoutConstraint.activate([
            spacerLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            spacerLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            spacerLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            chatImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            chatImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackViewOne.leadingAnchor.constraint(equalTo: chatImage.trailingAnchor, constant: 10),
            stackViewOne.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackViewOne.trailingAnchor.constraint(equalTo: indicatorView.leadingAnchor, constant: -20),
            
            indicatorImage.topAnchor.constraint(equalTo: indicatorView.topAnchor),
            indicatorImage.bottomAnchor.constraint(equalTo: indicatorView.bottomAnchor),
            indicatorImage.leadingAnchor.constraint(equalTo: indicatorView.leadingAnchor),
            indicatorImage.trailingAnchor.constraint(equalTo: indicatorView.trailingAnchor),
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SearchCellView: UICollectionViewCell {
    
    // MARK: Setup searchbar
    let searchHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = UIColor.init(red: 217/255, green: 222/255, blue: 233/255, alpha: 1)
        view.backgroundColor = UIColor.white
        view.heightAnchor.constraint(equalToConstant: 65).isActive = true
        return view
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.layer.cornerRadius = 5
        sb.clipsToBounds = true
        sb.barTintColor = .clear
        sb.placeholder = "Search"
        sb.isUserInteractionEnabled = false
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        addSubview(searchHolder)
        addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchHolder.topAnchor.constraint(equalTo: topAnchor),
            searchHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            searchBar.topAnchor.constraint(equalTo: searchHolder.topAnchor, constant: 5),
            searchBar.bottomAnchor.constraint(equalTo: searchHolder.bottomAnchor, constant: -5),
            searchBar.leadingAnchor.constraint(equalTo: searchHolder.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: searchHolder.trailingAnchor, constant: -10),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
