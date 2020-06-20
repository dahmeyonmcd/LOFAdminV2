//
//  SignalOpenVC.swift
//  Lions of Forex
//
//  Created by UnoEast on 5/29/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import MessageUI

class ProfileOpenVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMessageComposeViewControllerDelegate {
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        
        return mb
    }()
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.86)
        view.layer.cornerRadius = 0
        return view
    }()
    
    let removePromptHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        return view
    }()
    
    let removeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.text = "Are you sure?"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let removeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "This action is permanent"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let acceptRemoveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(removeButtonTappedd), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelRemoveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCancelRemove), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let acceptRefundButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(refundButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelRefundButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCancelRemove), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        layout.scrollDirection = .vertical
        return cv
    }()
    
    // MARK: Loading
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
    // MARK: END LOADING
    
    let menuBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userblankprofile")
        imageView.backgroundColor = .clear
        let newColor = UIColor.white.cgColor
        imageView.layer.borderColor = newColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        //        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "GradientHeaderImage")
        return imageView
    }()
    
    let backHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "backbuttonArrow"), for: .normal)
        //        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let menuBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    
    private let cellId = "ProfileTopCellId"
    private let bottomCellId = "ProfileBottomCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(ProfileOpenTopCell.self, forCellWithReuseIdentifier: cellId)
        cellHolder.register(ProfileOpenBottomCell.self, forCellWithReuseIdentifier: bottomCellId)
        
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(dashboardTapped), name: Notification.Name("CloseThisJawn"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(callMember), name: Notification.Name("CallCurrentMember"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageMember), name: Notification.Name("MessageCurrentMember"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openRemoveBox), name: Notification.Name("RemoveCurrentMemberTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openRefundBox), name: Notification.Name("RefundCurrentMemberTapped"), object: nil)
        
        setupMenuBar()
        
    }
    
    @objc func openRemoveBox() {
        let buttonStackView = UIStackView()
        buttonStackView.addArrangedSubview(acceptRemoveButton)
        buttonStackView.addArrangedSubview(cancelRemoveButton)
        buttonStackView.axis = .horizontal
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        
        let titleStackView = UIStackView()
        titleStackView.addArrangedSubview(removeTitleLabel)
        titleStackView.addArrangedSubview(removeSubtitleLabel)
        titleStackView.axis = .vertical
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.spacing = 5
        
        view.addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(removePromptHolder)
        removePromptHolder.addSubview(titleStackView)
        removePromptHolder.addSubview(buttonStackView)
        
        
        
        NSLayoutConstraint.activate([
            backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            removePromptHolder.centerYAnchor.constraint(equalTo: backgroundOverlay.centerYAnchor),
            removePromptHolder.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 30),
            removePromptHolder.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -30),
            
            buttonStackView.bottomAnchor.constraint(equalTo: removePromptHolder.bottomAnchor, constant: -20),
            buttonStackView.leadingAnchor.constraint(equalTo: removePromptHolder.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: removePromptHolder.trailingAnchor, constant: -20),
            
            titleStackView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20),
            titleStackView.leadingAnchor.constraint(equalTo: removePromptHolder.leadingAnchor, constant: 20),
            titleStackView.topAnchor.constraint(equalTo: removePromptHolder.topAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: removePromptHolder.trailingAnchor, constant: -20),
            ])
        
        backgroundOverlay.alpha = 0
        removePromptHolder.transform = CGAffineTransform(translationX: 0, y: 1000)
        
        DispatchQueue.main.async {
            self.backgroundOverlay.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
                self.backgroundOverlay.alpha = 1
                
            }, completion: { (_) in
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
                    self.removePromptHolder.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: { (_) in
                    //
                })
            })
        }
    }
    
    @objc func openRefundBox() {
        let buttonStackView = UIStackView()
        buttonStackView.addArrangedSubview(acceptRefundButton)
        buttonStackView.addArrangedSubview(cancelRefundButton)
        buttonStackView.axis = .horizontal
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        
        let titleStackView = UIStackView()
        titleStackView.addArrangedSubview(removeTitleLabel)
        titleStackView.addArrangedSubview(removeSubtitleLabel)
        titleStackView.axis = .vertical
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.spacing = 5
        
        view.addSubview(backgroundOverlay)
        backgroundOverlay.addSubview(removePromptHolder)
        removePromptHolder.addSubview(titleStackView)
        removePromptHolder.addSubview(buttonStackView)
        
        
        
        NSLayoutConstraint.activate([
            backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            removePromptHolder.centerYAnchor.constraint(equalTo: backgroundOverlay.centerYAnchor),
            removePromptHolder.leadingAnchor.constraint(equalTo: backgroundOverlay.leadingAnchor, constant: 30),
            removePromptHolder.trailingAnchor.constraint(equalTo: backgroundOverlay.trailingAnchor, constant: -30),
            
            buttonStackView.bottomAnchor.constraint(equalTo: removePromptHolder.bottomAnchor, constant: -20),
            buttonStackView.leadingAnchor.constraint(equalTo: removePromptHolder.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: removePromptHolder.trailingAnchor, constant: -20),
            
            titleStackView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20),
            titleStackView.leadingAnchor.constraint(equalTo: removePromptHolder.leadingAnchor, constant: 20),
            titleStackView.topAnchor.constraint(equalTo: removePromptHolder.topAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: removePromptHolder.trailingAnchor, constant: -20),
            ])
        
        backgroundOverlay.alpha = 0
        removePromptHolder.transform = CGAffineTransform(translationX: 0, y: 1000)
        
        DispatchQueue.main.async {
            self.backgroundOverlay.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
                self.backgroundOverlay.alpha = 1
                
            }, completion: { (_) in
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
                    self.removePromptHolder.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: { (_) in
                    //
                })
            })
        }
    }
    
    @objc func messageMember() {
        if let busPhone = KeychainWrapper.standard.string(forKey: "SelectedMemberMobile") {
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Hi, Thank you for being a part of the LOF Team"
                controller.recipients = [busPhone]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func callMember() {
        if let busPhone = KeychainWrapper.standard.string(forKey: "SelectedMemberMobile") {
            print("calling...")
            if let url = URL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancelRemove() {
        self.backgroundOverlay.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
            self.removePromptHolder.transform = CGAffineTransform(translationX: 0, y: 1000)
            
            
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
                self.backgroundOverlay.alpha = 0
            }, completion: { (_) in
                //
            })
        })
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addSubview(menuTop)
        view.addSubview(cellHolder)
        menuBar.addSubview(menuBarLabel)
        menuBar.addSubview(backHomeButton)
        menuBar.addSubview(headerImage)
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: 50),
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            menuBarLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            menuBarLabel.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            menuBarLabel.widthAnchor.constraint(equalTo: menuBar.widthAnchor, multiplier: 0.4),
            
            backHomeButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            backHomeButton.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 10),
            
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerImage.heightAnchor.constraint(equalToConstant: 40),
            headerImage.widthAnchor.constraint(equalToConstant: 70),
            headerImage.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            headerImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            ])
        
    }
    
    
    
    @objc func closePage() {
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberEmail")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberName")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberPhoto")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberMobile")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberCountry")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberExperience")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberMonths")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberTrial")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberPassword")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberId")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberPackage")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberJoined")
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberStatus")
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @objc func refundButtonTapped() {
        let mainID: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberEmail")
        let myUrl = URL(string: "http://api.lionsofforex.com/adminv2/remove_refund_member")
        let postString = ["email": mainID] as! [String: String]
        // send http request to perform sign in
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    let userId = json.value(forKey: "success") as! String
                    print(userId)
                }
        }
    }
    
    @objc func removeButtonTappedd() {
        let mainID: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberEmail")
        let myUrl = URL(string: "http://api.lionsofforex.com/adminv2/remove_member")
        let postString = ["email": mainID] as! [String: String]
        // send http request to perform sign in
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                // to get json return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    print(json)
                    if let userId = json.value(forKey: "success") as? String {
                        self.closePage()
                        print(userId)
                        self.handleCancelRemove()
                    }else{
                        print("error")
                    }
                    
                }else{
                    
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileOpenTopCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bottomCellId, for: indexPath) as! ProfileOpenBottomCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return .init(width: cellHolder.frame.width, height: 400)
        }else{
            return .init(width: cellHolder.frame.width, height: 430)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func dashboardTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class ProfileOpenTopCell: UICollectionViewCell {
    
    let cardBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 0
        return view
    }()
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 70).isActive = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let SymbolTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let UpdateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Update"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let TypeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Package"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let DateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let PipTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Pips"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Experience"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Country"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpTwoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Date Joined"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let EntryTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Mobile"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let StatusTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Status"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let symbolAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "name value"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pipAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpTwoAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let entryAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let updateAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    //    let closeViewButton: UIButton = {
    //        let button = UIButton(type: .system)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.setTitle("Close", for: .normal)
    //        button.backgroundColor = .green
    //        button.layer.cornerRadius = 8
    //        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
    //        return button
    //    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        loadProfileData()
        
        setupLayout()
    }
    
    func loadProfileData() {
//        let profileId: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberId")
        let profileName: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberName")
        let profilePhoto: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberPhoto")
        let profileExperience: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberExperience")
        let profilePackage: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberPackage")
        let profileStatus: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberStatus")
//        let profilePassword: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberPassword")
        let profileMobile: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberMobile")
        let profileEmail: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberEmail")
//        let profileCountry: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberCountry")
        let profileJoined: String? = KeychainWrapper.standard.string(forKey: "SelectedMemberJoined")
        //        let thPips:Int? = Int(mainPips!)
        
        symbolAmountLabel.text = profileName
        dateAmountLabel.text = profileEmail
        
        if profilePackage == "12" {
            typeAmountLabel.text = "Essentials Member"
        }else if profilePackage == "13"{
            typeAmountLabel.text = "Signals Member"
        }else if profilePackage == "14"{
            typeAmountLabel.text = "Advanced Member"
        }else if profilePackage == "15"{
            typeAmountLabel.text = "Elite Member"
        }else{
            typeAmountLabel.text = "Godfathered Member"
        }
        
        if profileStatus == "0" {
            statusAmountLabel.text = "Inactive"
        }else if profileStatus == "1" {
            statusAmountLabel.text = "Active"
        }else{
            statusAmountLabel.text = "Unknown"
        }
        
        if let timestring = KeychainWrapper.standard.string(forKey: "SelectedMemberJoined") {
            if let unixTimestamp = Double(timestring) {
                let date = Date(timeIntervalSince1970: unixTimestamp)
//                let date = Date(timeIntervalSince1970: unixtimeInterval)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                let strDate = dateFormatter.string(from: date)
                tpTwoAmountLabel.text = strDate
            }else{
                tpTwoAmountLabel.text = profileJoined
            }
//            let unixTimestamp = 1480134638.0
            
        }
        
        
        entryAmountLabel.text = profileMobile
        slAmountLabel.text = profileExperience
        
        if let countryCode = KeychainWrapper.standard.string(forKey: "SelectedMemberCountry") {
            
            tpAmountLabel.text = countryCode
        }
        
//        tpTwoAmountLabel.text = profileJoined
        
        profileImage.setImageWith(URL(string: "https://members.lionsofforex.com/\(profilePhoto ?? "")")!)
//        updateAmountLabel.text = mainUpdate
    }
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
    
    private func setupLayout() {
        let symbolStackView = UIStackView()
        symbolStackView.addArrangedSubview(SymbolTitleLabel)
        symbolStackView.addArrangedSubview(symbolAmountLabel)
        symbolStackView.spacing = 2
        symbolStackView.axis = .vertical
        symbolStackView.alignment = .leading
        symbolStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateStackView = UIStackView()
        dateStackView.addArrangedSubview(DateTitleLabel)
        dateStackView.addArrangedSubview(dateAmountLabel)
        dateStackView.spacing = 2
        dateStackView.axis = .vertical
        dateStackView.alignment = .leading
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let typeStackView = UIStackView()
        typeStackView.addArrangedSubview(TypeTitleLabel)
        typeStackView.addArrangedSubview(typeAmountLabel)
        typeStackView.spacing = 2
        typeStackView.axis = .vertical
        typeStackView.alignment = .leading
        typeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let entryStackView = UIStackView()
        entryStackView.addArrangedSubview(EntryTitleLabel)
        entryStackView.addArrangedSubview(entryAmountLabel)
        entryStackView.spacing = 2
        entryStackView.axis = .vertical
        entryStackView.alignment = .leading
        entryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let slStackView = UIStackView()
        slStackView.addArrangedSubview(slTitleLabel)
        slStackView.addArrangedSubview(slAmountLabel)
        slStackView.spacing = 2
        slStackView.axis = .vertical
        slStackView.alignment = .leading
        slStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tpStackView = UIStackView()
        tpStackView.addArrangedSubview(tpTitleLabel)
        tpStackView.addArrangedSubview(tpAmountLabel)
        tpStackView.spacing = 2
        tpStackView.axis = .vertical
        tpStackView.alignment = .leading
        tpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tpTwoStackView = UIStackView()
        tpTwoStackView.addArrangedSubview(tpTwoTitleLabel)
        tpTwoStackView.addArrangedSubview(tpTwoAmountLabel)
        tpTwoStackView.spacing = 2
        tpTwoStackView.axis = .vertical
        tpTwoStackView.alignment = .leading
        tpTwoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let updateStackView = UIStackView()
        updateStackView.addArrangedSubview(UpdateTitleLabel)
        updateStackView.addArrangedSubview(updateAmountLabel)
        updateStackView.spacing = 2
        updateStackView.axis = .vertical
        updateStackView.alignment = .leading
        updateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let statusStackView = UIStackView()
        updateStackView.addArrangedSubview(StatusTitleLabel)
        updateStackView.addArrangedSubview(statusAmountLabel)
        updateStackView.spacing = 2
        updateStackView.axis = .vertical
        updateStackView.alignment = .leading
        updateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackViewOne = UIStackView()
        mainStackViewOne.addArrangedSubview(profileImage)
        mainStackViewOne.addArrangedSubview(symbolStackView)
        mainStackViewOne.addArrangedSubview(dateStackView)
        mainStackViewOne.addArrangedSubview(typeStackView)
        mainStackViewOne.addArrangedSubview(entryStackView)
        mainStackViewOne.addArrangedSubview(tpStackView)
        mainStackViewOne.addArrangedSubview(tpTwoStackView)
        mainStackViewOne.addArrangedSubview(slStackView)
        mainStackViewOne.addArrangedSubview(statusStackView)
        mainStackViewOne.spacing = 5
        mainStackViewOne.axis = .vertical
        mainStackViewOne.alignment = .leading
        mainStackViewOne.distribution = .fill
        mainStackViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        //        addSubview(clearBackGround)
        addSubview(cardBackground)
        
        cardBackground.addSubview(mainStackViewOne)
        
        //        cardBackground.addSubview(animationView)
        
        
        // setup constraints for views
        NSLayoutConstraint.activate([
            cardBackground.topAnchor.constraint(equalTo: topAnchor),
            cardBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            
            
            mainStackViewOne.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 30),
            mainStackViewOne.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 40),
            mainStackViewOne.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -40),
            //            mainStackViewOne.bottomAnchor.constraint(equalTo: cardBackground.bottomAnchor, constant: -40),
            ])
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ProfileOpenBottomCell: UICollectionViewCell {
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 224/255, green: 32/255, blue: 32/255, alpha: 1)
        button.tintColor = .gray
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        //        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //        button.imageEdgeInsets = InsetView
//        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let refundButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 224/255, green: 32/255, blue: 32/255, alpha: 1)
        button.tintColor = .gray
        button.setTitle("Refund", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        //        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //        button.imageEdgeInsets = InsetView
        //        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 56/255, green: 116/255, blue: 13/255, alpha: 1)
        button.tintColor = .gray
        button.setTitle("Update", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        //        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //        button.imageEdgeInsets = InsetView
//        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        return button
    }()
    
    let callButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 56/255, green: 116/255, blue: 13/255, alpha: 1)
        button.tintColor = .gray
        button.setTitle("Call", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        //        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //        button.imageEdgeInsets = InsetView
//        button.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let textButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 56/255, green: 116/255, blue: 13/255, alpha: 1)
        button.tintColor = .gray
        button.setTitle("Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        //        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //        button.imageEdgeInsets = InsetView
//        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
        
        let callGesture = UITapGestureRecognizer(target: self, action: #selector(callButtonTapped))
        callButton.addGestureRecognizer(callGesture)
        
        let messageGesture = UITapGestureRecognizer(target: self, action: #selector(messageButtonTapped))
        textButton.addGestureRecognizer(messageGesture)
        
        let removeGesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped))
        closeButton.addGestureRecognizer(removeGesture)
        
        let refundGesture = UITapGestureRecognizer(target: self, action: #selector(refundButtonTapped))
        refundButton.addGestureRecognizer(refundGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(closeButton)
        addSubview(refundButton)
        addSubview(updateButton)
        addSubview(callButton)
        addSubview(textButton)
        
        NSLayoutConstraint.activate([
            
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            refundButton.heightAnchor.constraint(equalToConstant: 50),
            refundButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -15),
            refundButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            refundButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            callButton.heightAnchor.constraint(equalToConstant: 50),
            callButton.bottomAnchor.constraint(equalTo: refundButton.topAnchor, constant: -15),
            callButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            callButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            textButton.heightAnchor.constraint(equalToConstant: 50),
            textButton.bottomAnchor.constraint(equalTo: callButton.topAnchor, constant: -15),
            textButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            textButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.bottomAnchor.constraint(equalTo: textButton.topAnchor, constant: -15),
            updateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            updateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            ])
    }
    
    @objc func dashboardTapped() {
        NotificationCenter.default.post(name: Notification.Name("CloseThisJawn"), object: nil)
    }
    
    @objc func refundButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("RefundCurrentMemberTapped"), object: nil)
    }
    
    @objc func removeButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("RemoveCurrentMemberTapped"), object: nil)
    }
    
    @objc func callButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("CallCurrentMember"), object: nil)
    }
    
    @objc func messageButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("MessageCurrentMember"), object: nil)
    }
    
}
