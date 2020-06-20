//
//  TeamMemberExpandedVC.swift
//  LionsofForexAdminApp
//
//  Created by UnoEast on 4/29/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class TeamMemberExpandedVC: UIView {
    
    let clearBackGround: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let cardBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "CloseButton"), for: .normal)
        button.tintColor = .black
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "CloseButton"), for: .normal)
        button.tintColor = .black
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.addTarget(self, action: #selector(addMember), for: .touchUpInside)
        return button
    }()
    
//    let profileLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        label.textAlignment = .center
//        label.text = "Symbol"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    let UpdateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "Update"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "See Profile"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let updateAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update Member", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        button.addTarget(self, action: #selector(openPageTapped), for: .touchUpInside)
        return button
    }()
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Profile", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        button.addTarget(self, action: #selector(openPageTapped), for: .touchUpInside)
        return button
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remove", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.addTarget(self, action: #selector(launchRemove), for: .touchUpInside)
        return button
    }()
    
    let refundButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Refund", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.addTarget(self, action: #selector(launchRefund), for: .touchUpInside)
        return button
    }()
    // remove components
    
    let removeDialogBox: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.widthAnchor.constraint(equalToConstant: 270).isActive = true
        return view
    }()
    
    let removeYesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("YES", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 0
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let removeNoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("NO", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 0
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.addTarget(self, action: #selector(removeNoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let refundYesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("YES", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 0
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.addTarget(self, action: #selector(refundButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let refundNoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("NO", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 0
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.addTarget(self, action: #selector(removeNoButtonTapped), for: .touchUpInside)
        return button
    }()

    let blurViewOne = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurThis = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurThis)
        
        blurView.frame = bounds
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(profileButton)
        stackViewOne.addArrangedSubview(updateButton)
        stackViewOne.addArrangedSubview(removeButton)
        stackViewOne.addArrangedSubview(refundButton)
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.spacing = 10
        stackViewOne.axis = .vertical
        stackViewOne.alignment = .center
//        stackViewOne.distribution = .fillEqually
        
        addSubview(clearBackGround)
        clearBackGround.addSubview(cardBackground)
        cardBackground.addSubview(closeButton)

        cardBackground.addSubview(stackViewOne)
//        cardBackground.addSubview(updateButton)
        
        //        cardBackground.addSubview(animationView)
        
        
        // setup constraints for views
        NSLayoutConstraint.activate([
            clearBackGround.topAnchor.constraint(equalTo: topAnchor),
            clearBackGround.bottomAnchor.constraint(equalTo: bottomAnchor),
            clearBackGround.trailingAnchor.constraint(equalTo: trailingAnchor),
            clearBackGround.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackground.widthAnchor.constraint(equalToConstant: 300),
            cardBackground.heightAnchor.constraint(equalToConstant: 400),
            cardBackground.centerXAnchor.constraint(equalTo: clearBackGround.centerXAnchor),
            cardBackground.centerYAnchor.constraint(equalTo: clearBackGround.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 15),
            
            stackViewOne.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            stackViewOne.centerXAnchor.constraint(equalTo: cardBackground.centerXAnchor, constant: 0),
//            stackViewOne.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 20),
//            stackViewOne.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
            
            ])
    }
    
    @objc func closePage() {
        KeychainWrapper.standard.removeObject(forKey: "SelectedMemberEmail")
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    @objc func addMember() {
        
    }
    
    @objc func launchRemove() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(removeYesButton)
        stackViewOne.addArrangedSubview(removeNoButton)
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.spacing = 1
        stackViewOne.axis = .horizontal
        stackViewOne.alignment = .center
        stackViewOne.distribution = .fillEqually
        
        blurViewOne.frame = bounds
        
        blurViewOne.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(blurViewOne)
        addSubview(removeDialogBox)
        removeDialogBox.addSubview(stackViewOne)
        
        NSLayoutConstraint.activate([
            removeDialogBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            removeDialogBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackViewOne.bottomAnchor.constraint(equalTo: removeDialogBox.bottomAnchor),
            stackViewOne.leadingAnchor.constraint(equalTo: removeDialogBox.leadingAnchor),
            stackViewOne.trailingAnchor.constraint(equalTo: removeDialogBox.trailingAnchor)
            ])
    }
    
    @objc func launchRefund() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(refundYesButton)
        stackViewOne.addArrangedSubview(refundNoButton)
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.spacing = 1
        stackViewOne.axis = .horizontal
        stackViewOne.alignment = .center
        stackViewOne.distribution = .fillEqually
        
        blurViewOne.frame = bounds
        
        blurViewOne.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(blurViewOne)
        addSubview(removeDialogBox)
        removeDialogBox.addSubview(stackViewOne)
        
        NSLayoutConstraint.activate([
            removeDialogBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            removeDialogBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackViewOne.bottomAnchor.constraint(equalTo: removeDialogBox.bottomAnchor),
            stackViewOne.leadingAnchor.constraint(equalTo: removeDialogBox.leadingAnchor),
            stackViewOne.trailingAnchor.constraint(equalTo: removeDialogBox.trailingAnchor)
            ])
    }
    
    @objc func removeNoButtonTapped() {
        blurViewOne.removeFromSuperview()
        removeDialogBox.removeFromSuperview()
    }
    
    @objc func removeButtonTapped() {
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
                    let userId = json.value(forKey: "success") as! String
                    self.closePage()
                    print(userId)
                }else{
                    self.removeDialogBox.removeFromSuperview()
                    self.blurViewOne.removeFromSuperview()
                }
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
    
    @objc func openPageTapped() {
        // opens swiping controller
        let mainController = EditSignalVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        //        navigationController.modalTransitionStyle = .crossDissolve
        topVC?.present(navigationController, animated: true, completion: nil)
        //        NotificationCenter.default.post(name: Notification.Name("UpdateSignalTapped"), object: nil)
        print("opening page with signalID: \(KeychainWrapper.standard.string(forKey: "selectedID") ?? "")")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
