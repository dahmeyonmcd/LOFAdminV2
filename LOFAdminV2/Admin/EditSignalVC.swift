//
//  EditSignalVC.swift
//  LionsofForexAdminApp
//
//  Created by UnoEast on 4/30/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import Lottie
import AVKit

class EditSignalVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        layout.scrollDirection = .vertical
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.footerReferenceSize = CGSize(width: cv.frame.width, height: 400)
        cv.isScrollEnabled = true
        return cv
    }()
    
    let viewHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        return view
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let menuBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    let menuBar: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = .black
        return tView
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Adding New Signal"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let totalPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Admin"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Update Signal"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.contentMode = .bottomLeft
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "mb"), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(goBackTapped), for: .touchUpInside)
        return button
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.layer.zPosition = 1
        button.layer.masksToBounds = true
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
//        iv.image = UIImage(named: "DashboardBackgroundImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleToFill
        return iv
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
    
    let pairOptions = ["AUDUSD", "CHFJPY", "EURUSD", "GBPAUD", "GBPJPY", "GBPNZD", "USDCAD", "USDCHF", "USDJPY", "XAUUSD"]
    let tradeTypes = ["Buy", "Sell", "Buy Limit", "Buy Stop", "Sell Limit", "Sell Stop"]
    let tradeStyle = ["Swing", "Scalp"]
    let emaLevel = ["20 EMA", "50 EMA", "200 EMA", "800 EMA"]
    
    var player: AVPlayer?
    let videoLink = "BackgroundVideo"
    let videoURL: NSURL = Bundle.main.url(forResource: "signalsVideo", withExtension: ".mp4")! as NSURL
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    fileprivate let cellId = "updateSignalCellId"
    fileprivate let headerId = "updateHeaderSignalCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(UpdateSignalCell.self, forCellWithReuseIdentifier: cellId)
        
        cellHolder.register(UpdateSignalFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerId)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        setupView()
        
        player = AVPlayer(url: videoURL as URL)
        playAudioMix()
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        player?.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: Notification.Name("UpdateSignalError"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorSending), name: Notification.Name("ErrorSendingSignalUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displaySuccess), name: Notification.Name("SuccessfullySentUpdateSignal"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayCloseSuccess), name: Notification.Name("SuccessfullyClosedSignal"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopLoading), name: Notification.Name("SuccessfullySentSignalUpdateStopLoading"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startLoading), name: Notification.Name("SuccessfullyUpdatedSignalStartLoading"), object: nil)
    }
    
    @objc func startLoading() {
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
    }
    
    @objc func stopLoading() {
        self.pageOverlay.removeFromSuperview()
    }
    
    @objc func postSignals() {
        
    }
    
    @objc func goBackTapped() {
        navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func updateButtonTapped() {
        print("open updates")
        let vc = CreateNewUpdateVC()
        navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UpdateSignalCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 730)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerId, for: indexPath) as! UpdateSignalFooter
        return headerView
    }
    
    
    private func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(menuBar)
        view.addSubview(topSpacer)
        
        view.addSubview(viewHolder)
        viewHolder.addSubview(cellHolder)
        topSpacer.addSubview(totalPipLabel)
        topSpacer.addSubview(secondPipLabel)
        topSpacer.addSubview(backButton)
        view.addSubview(bottomSpacer)
        
        //
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            viewHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topSpacer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 50),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            totalPipLabel.leadingAnchor.constraint(equalTo: topSpacer.leadingAnchor, constant: 20),
            totalPipLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            secondPipLabel.leadingAnchor.constraint(equalTo: totalPipLabel.trailingAnchor, constant: 5),
            secondPipLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: viewHolder.topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: topSpacer.trailingAnchor, constant: -20)
            ])
    }
    
    @objc func displayError() {
        self.displayMessage(userMessage: "Please fill out all fields.")
    }
    
    @objc func displaySuccess() {
        self.displayMessage(userMessage: "Signal successfully updated.")
    }
    
    @objc func displayCloseSuccess() {
        self.displayMessage(userMessage: "Signal successfully closed.")
    }
    
    @objc func displayErrorSending() {
        self.displayMessage(userMessage: "Could not send signal.")
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
    
    //    @objc func confirmButtonTapped() {
    //        print("Posting signal")
    //        // display message saying signal posted successfullly
    //        displayMessage(userMessage: "Signal successfully sent.")
    //    }
    //
    @objc func closeButtonTapped() {
        print("Posting signal")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func playAudioMix() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class UpdateSignalCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let entryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Entry"
        label.numberOfLines = 1
        return label
    }()
    
    let entryField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    let pairLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Pair"
        label.numberOfLines = 1
        return label
    }()
    
    let pairField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    let tradeTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Trade Type"
        label.numberOfLines = 1
        return label
    }()
    
    let tradeTypeField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    let riskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Risk/Reward"
        label.numberOfLines = 1
        return label
    }()
    
    let riskField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.isHidden = false
        return textField
    }()
    
    let slLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Stop Loss"
        label.numberOfLines = 1
        return label
    }()
    
    let slField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    let tradingStyleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Trade Style"
        label.numberOfLines = 1
        return label
    }()
    
    let tradingStyleField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    let tpOneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Take Profit 1"
        label.numberOfLines = 1
        return label
    }()
    
    let tpOneField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    let tpTwoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Take Profit 2"
        label.numberOfLines = 1
        return label
    }()
    
    let tpTwoField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Message"
        label.numberOfLines = 1
        return label
    }()
    
    let messageField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.isHidden = true
        
        return textField
    }()
    
    let pairPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let tradePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let stylePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let emaPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let pairOptions = ["AUDCAD", "AUDCHF","AUDJPY", "AUDNZD", "AUDUSD","CADCHF", "CADJPY", "CHFJPY", "EURAUD", "EURCAD", "EURCHF", "EURGBP", "EURJPY", "EURNZD", "EURUSD", "GBPAUD", "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "GBPUSD", "MXNUSD", "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD", "USDCHF", "XAUUSD", "US30"]
    let tradeTypes = ["Buy", "Sell", "Buy Limit", "Buy Stop", "Sell Limit", "Sell Stop"]
    let tradeStyle = ["Swing", "Scalp"]
    let emaLevel = ["20 EMA", "50 EMA", "200 EMA", "800 EMA"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pairPicker.delegate = self
        tradePicker.delegate = self
        emaPicker.delegate = self
        stylePicker.delegate = self
        
        tradeTypeField.inputView = tradePicker
        pairField.inputView = pairPicker
        tradingStyleField.inputView = stylePicker
        
        backgroundColor = .clear
        
        setupView()
        setupLabels()
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendSignal), name: Notification.Name("createSignalTapped"), object: nil)
    }
    
    
    
    private func setupLabels() {
        let entryPrice: String? = KeychainWrapper.standard.string(forKey: "selectedEntry")
        let pair: String? = KeychainWrapper.standard.string(forKey: "selectedSymbol")
        let type: String? = KeychainWrapper.standard.string(forKey: "selectedType")
        let style: String? = KeychainWrapper.standard.string(forKey: "selectedStyle")
        let tp1: String? = KeychainWrapper.standard.string(forKey: "selectedTP")
        let tp2: String? = KeychainWrapper.standard.string(forKey: "selectedTP2")
        let sl: String? = KeychainWrapper.standard.string(forKey: "selectedSL")
        let riskReward: String? = KeychainWrapper.standard.string(forKey: "selectedRiskReward")
        
        entryField.text = entryPrice
        pairField.text = pair
        tradeTypeField.text = type
        tradingStyleField.text = style
        tpOneField.text = tp1
        tpTwoField.text = tp2
        slField.text = sl
        riskField.text = riskReward
    }
    
    private func setupView() {
        let tradeStyleStackView = UIStackView()
        tradeStyleStackView.addArrangedSubview(tradingStyleLabel)
        tradeStyleStackView.addArrangedSubview(tradingStyleField)
        tradeStyleStackView.spacing = 5
        //        tradeStyleStackView.alignment = .leading
        //        tradeStyleStackView.distribution = .fill
        tradeStyleStackView.axis = .vertical
        tradeStyleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let typeStackView = UIStackView()
        typeStackView.addArrangedSubview(tradeTypeLabel)
        typeStackView.addArrangedSubview(tradeTypeField)
        typeStackView.spacing = 5
        //        typeStackView.alignment = .leading
        //        typeStackView.distribution = .fillProportionally
        typeStackView.axis = .vertical
        typeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let pairStackView = UIStackView()
        pairStackView.addArrangedSubview(pairLabel)
        pairStackView.addArrangedSubview(pairField)
        pairStackView.spacing = 5
        //        pairStackView.alignment = .leading
        //        pairStackView.distribution = .fillProportionally
        pairStackView.axis = .vertical
        pairStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let entryStackView = UIStackView()
        entryStackView.addArrangedSubview(entryLabel)
        entryStackView.addArrangedSubview(entryField)
        entryStackView.spacing = 5
        //        entryStackView.alignment = .leading
        //        entryStackView.distribution = .fillProportionally
        entryStackView.axis = .vertical
        entryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let slStackView = UIStackView()
        slStackView.addArrangedSubview(slLabel)
        slStackView.addArrangedSubview(slField)
        slStackView.spacing = 5
        //        slStackView.alignment = .leading
        //        slStackView.distribution = .fillProportionally
        slStackView.axis = .vertical
        slStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tpOneStackView = UIStackView()
        tpOneStackView.addArrangedSubview(tpOneLabel)
        tpOneStackView.addArrangedSubview(tpOneField)
        tpOneStackView.spacing = 5
        //        tpOneStackView.alignment = .leading
        //        tpOneStackView.distribution = .fillProportionally
        tpOneStackView.axis = .vertical
        tpOneStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tpTwoStackView = UIStackView()
        tpTwoStackView.addArrangedSubview(tpTwoLabel)
        tpTwoStackView.addArrangedSubview(tpTwoField)
        tpTwoStackView.spacing = 5
        //        tpTwoStackView.alignment = .leading
        //        tpTwoStackView.distribution = .fillProportionally
        tpTwoStackView.axis = .vertical
        tpTwoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let riskTwoStackView = UIStackView()
        riskTwoStackView.addArrangedSubview(riskLabel)
        riskTwoStackView.addArrangedSubview(riskField)
        riskTwoStackView.spacing = 5
        //        riskTwoStackView.alignment = .leading
        //        riskTwoStackView.distribution = .fillProportionally
        riskTwoStackView.axis = .vertical
        riskTwoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView()
        mainStackView.addArrangedSubview(tradeStyleStackView)
        mainStackView.addArrangedSubview(typeStackView)
        mainStackView.addArrangedSubview(pairStackView)
        mainStackView.addArrangedSubview(entryStackView)
        mainStackView.addArrangedSubview(slStackView)
        mainStackView.addArrangedSubview(tpOneStackView)
        mainStackView.addArrangedSubview(tpTwoStackView)
        mainStackView.addArrangedSubview(riskTwoStackView)
        mainStackView.spacing = 15
        //        mainStackView.alignment = .leading
        mainStackView.distribution = .fill
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(mainStackView)
        
        //
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            ])
    }
    
    // MARK: UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == tradePicker {
            return tradeTypes.count
        }else if pickerView == pairPicker {
            return pairOptions.count
        }else if pickerView == stylePicker {
            return tradeStyle.count
        }else {
            return emaLevel.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == tradePicker {
            return tradeTypes[row]
        }else if pickerView == pairPicker {
            return pairOptions[row]
        }else if pickerView == stylePicker {
            return tradeStyle[row]
        }else {
            return emaLevel[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == tradePicker {
            tradeTypeField.text = tradeTypes[row]
        }else if pickerView == pairPicker {
            pairField.text = pairOptions[row]
        }else if pickerView == stylePicker {
            tradingStyleField.text = tradeStyle[row]
        }else {
            slField.text = emaLevel[row]
        }
    }
    
    func sendNewSignal() {
        let myUrl = URL(string: "http://api.lionsofforex.com/adminv2/update_signal")
        guard let id: String = KeychainWrapper.standard.string(forKey: "selectedID") else { return }
        guard let stoploss = slField.text else { return }
        guard let style = tradingStyleField.text else { return }
//        guard let symbol = pairField.text else { return }
//        guard let type = tradeTypeField.text else { return }
        guard let entryprice = entryField.text else { return }
        guard let takeprofit = tpOneField.text else { return }
        guard let takeprofit2 = tpTwoField.text else { return }
        guard let riskreward = riskField.text else { return }

        let postString: [String: Any] = ["signal_id": id, "volume": style, "stoploss": stoploss, "entryprice": entryprice, "takeprofit": takeprofit, "takeprofit2": takeprofit2, "riskreward": riskreward]
        // send http request to perform sign in
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                // to get json return value
                if let result = response.result.value {
                    if let json = result as? NSDictionary {
                        print(json)
                        if let userId = json.object(forKey: "success") {
                            print(userId)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalUpdateStopLoading"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullySentUpdateSignal"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("ReloadSignals"), object: nil)
                            }
                        }else{
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalUpdateStopLoading"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("ErrorSendingSignalUpdate"), object: nil)
                            }
                        }
                    }else{
                        NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalUpdateStopLoading"), object: nil)
                        NotificationCenter.default.post(name: Notification.Name("ErrorSendingSignalUpdate"), object: nil)
                    }
                }else{
                    NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalUpdateStopLoading"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("ErrorSendingSignalUpdate"), object: nil)
                }
        }
    }
    
    @objc func sendSignal() {
        NotificationCenter.default.post(name: Notification.Name("SuccessfullyUpdatedSignalStartLoading"), object: nil)
        sendNewSignal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UpdateSignalFooter: UICollectionViewCell {
    
    let pipsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Pips"
        label.numberOfLines = 1
        return label
    }()
    
    let pipsField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.cornerRadius = 7
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Insert pips to close", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "GorditaBlack", size: 13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 36/255, green: 241/255, blue: 181/255, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLOSE", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "GorditaBlack", size: 13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 36/255, green: 241/255, blue: 181/255, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupViews()
        
        setupButtons()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(confirmButtonTapped))
        confirmButton.addGestureRecognizer(tapGesture)
        
        let closetapGesture = UITapGestureRecognizer(target: self, action: #selector(pipsButtonTapped))
        closeButton.addGestureRecognizer(closetapGesture)
    }
    
    func setupButtons() {
        if let pips = KeychainWrapper.standard.string(forKey: "selectedPips") {
            if pips == "" {
                closeButton.alpha = 1
                closeButton.isUserInteractionEnabled = true
            }else{
                closeButton.alpha = 0.7
                closeButton.isUserInteractionEnabled = false
                pipsField.isUserInteractionEnabled = false
                
                if let pips = KeychainWrapper.standard.string(forKey: "selectedPips") {
                    pipsField.text = "\(pips) pips"
                }
            }
        }
    }
    
    private func setupViews() {
        let pipsStackView = UIStackView()
        pipsStackView.addArrangedSubview(pipsLabel)
        pipsStackView.addArrangedSubview(pipsField)
        pipsStackView.spacing = 5
        //        typeStackView.alignment = .leading
        //        typeStackView.distribution = .fillProportionally
        pipsStackView.axis = .vertical
        pipsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView()
        mainStackView.addArrangedSubview(confirmButton)
        mainStackView.addArrangedSubview(pipsStackView)
        mainStackView.addArrangedSubview(closeButton)
        mainStackView.spacing = 15
        //        mainStackView.alignment = .leading
        mainStackView.distribution = .fill
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            ])
    }
    
    
    @objc func closeButtonTapped() {
        let myUrl = URL(string: "http://api.lionsofforex.com/admin/update_signal")
        guard let id: String = KeychainWrapper.standard.string(forKey: "selectedID") else { return }
        guard let pips = pipsField.text else { return }
        
        let postString: [String: Any] = ["signal_id": id, "pips": pips]
        // send http request to perform sign in
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                // to get json return value
                if let result = response.result.value {
                    if let json = result as? NSDictionary {
                        print(json)
                        if let userId = json.object(forKey: "success") {
                            print(userId)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalUpdateStopLoading"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullyClosedSignal"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("ReloadSignals"), object: nil)
                            }
                        }else{
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalUpdateStopLoading"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("ErrorSendingSignalUpdate"), object: nil)
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalUpdateStopLoading"), object: nil)
                        NotificationCenter.default.post(name: Notification.Name("ErrorSendingSignalUpdate"), object: nil)
                    }
                }
        }
    }
    
    @objc func pipsButtonTapped() {
        if pipsField.text!.isEmpty {
            NotificationCenter.default.post(name: Notification.Name("UpdateSignalError"), object: nil)
        }else{
            NotificationCenter.default.post(name: Notification.Name("SuccessfullyUpdatedSignalStartLoading"), object: nil)
            DispatchQueue.main.async {
                self.closeButtonTapped()
            }
        }
    }
    
    
    @objc func confirmButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("createSignalTapped"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
