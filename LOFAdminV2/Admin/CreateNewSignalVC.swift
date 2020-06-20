//
//  CreateNewSignalVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/13/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON
import AVKit
import Lottie

class CreateNewSignalVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    let topSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let viewHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
//        iv.image = UIImage(named: "DashboardBackgroundImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let menuBar: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = .black
        return tView
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Admin"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Add New Signal"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.contentMode = .bottomLeft
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "mb"), for: .normal)
        button.tintColor = .white
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
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
    
    var player: AVPlayer?
    let videoLink = "BackgroundVideo"
    let videoURL: NSURL = Bundle.main.url(forResource: "signalsVideo", withExtension: ".mp4")! as NSURL
    
    let pairOptions = ["AUDCAD", "AUDCHF","AUDJPY", "AUDNZD", "AUDUSD","CADCHF", "CADJPY", "CHFJPY", "EURAUD", "EURCAD", "EURCHF", "EURGBP", "EURJPY", "EURNZD", "EURUSD", "GBPAUD", "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "GBPUSD", "MXNUSD", "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD", "USDCHF", "USDCAD", "USDJPY", "XAUUSD", "US30"]
    let tradeTypes = ["Buy", "Sell", "Buy Limit", "Buy Stop", "Sell Limit", "Sell Stop"]
    let tradeStyle = ["Swing", "Scalp"]
    let emaLevel = ["20 EMA", "50 EMA", "200 EMA", "800 EMA"]
    
    fileprivate let cellId = "sendSignalCellId"
    fileprivate let headerId = "sendHeaderSignalCellId"
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
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
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(CreateSignalCell.self, forCellWithReuseIdentifier: cellId)
        
        cellHolder.register(CreateSignalFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerId)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeButtonTapped), name: Notification.Name("closeCreateSignalPage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: Notification.Name("SendSignalError"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorSending), name: Notification.Name("ErrorSendingSignal"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorPackage), name: Notification.Name("SelectPackageError"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displaySuccess), name: Notification.Name("SuccessfullySentSignal"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopLoading), name: Notification.Name("SuccessfullySentSignalStopLoading"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startLoading), name: Notification.Name("SuccessfullySentSignalStartLoading"), object: nil)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func updateButtonTapped() {
        print("open updates")
        let vc = CreateNewUpdateVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CreateSignalCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 1000) // 750
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerId, for: indexPath) as! CreateSignalFooter
        return headerView
    }
    
    func playAudioMix() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(menuBar)
        view.addSubview(topSpacer)
        view.addSubview(viewHolder)
        viewHolder.addSubview(cellHolder)
        topSpacer.addSubview(mainTitleLabel)
        topSpacer.addSubview(subLabel)
        topSpacer.addSubview(closeButton)
        
        //
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topSpacer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 50),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainTitleLabel.leadingAnchor.constraint(equalTo: topSpacer.leadingAnchor, constant: 20),
            mainTitleLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            subLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor, constant: 5),
            subLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: viewHolder.topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor),
            
            viewHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            viewHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: topSpacer.trailingAnchor, constant: -15)
            ])
    }
    
    @objc func displayError() {
        self.displayMessage(userMessage: "Please fill out all fields.")
    }
    
    @objc func displaySuccess() {
        self.newDisplayMessage(userMessage: "Signal successfully sent.")
    }
    
    @objc func displayErrorSending() {
        self.displayMessage(userMessage: "Could not send signal.")
    }
    
    @objc func displayErrorPackage() {
        self.displayMessage(userMessage: "Please select packages.")
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
    
    func newDisplayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    // Code in this block will trigger when OK button tapped
                    print("OK Button Tapped")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
//
    @objc func closeButtonTapped() {
        print("closing page")
        navigationController?.popViewController(animated: true)
    }
    
}

class CreateSignalCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let v2 = CreateSignalView(frame: self.frame)
        
        addSubview(v2)
        
        NSLayoutConstraint.activate([
            v2.topAnchor.constraint(equalTo: topAnchor),
            v2.leadingAnchor.constraint(equalTo: leadingAnchor),
            v2.trailingAnchor.constraint(equalTo: trailingAnchor),
            v2.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
    
}

class CreateSignalView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        //        textField.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.23)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        // original width is 2
        textField.layer.borderWidth = 0 // 0.5
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
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Type"
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
        label.text = "Risk/reward"
        label.numberOfLines = 1
        return label
    }()
    
    let packageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Select Package"
        label.numberOfLines = 1
        return label
    }()
    
    let signalsBox: UIView = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        view.layer.cornerRadius = 3
        view.layer.zPosition = 1000
        view.addTarget(self, action: #selector(handleSignalTap), for: .touchUpInside)
        return view
    }()
    
    let signalsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        //        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Signals"
        label.numberOfLines = 1
        return label
    }()
    
    let advancedBox: UIView = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        view.layer.cornerRadius = 3
        view.layer.zPosition = 1000
        view.addTarget(self, action: #selector(handleAdvancedTap), for: .touchUpInside)
        return view
    }()
    
    let essentialsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        //        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Essentials"
        label.numberOfLines = 1
        return label
    }()
    
    let eliteBox: UIView = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        view.layer.cornerRadius = 3
        view.layer.zPosition = 1000
        view.addTarget(self, action: #selector(handleEliteTap), for: .touchUpInside)
        return view
    }()
    
    let eliteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        //        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Elite"
        label.numberOfLines = 1
        return label
    }()
    
    let advancedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        //        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Advanced"
        label.numberOfLines = 1
        return label
    }()
    
    let essentialsBox: UIView = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        view.layer.cornerRadius = 3
        view.layer.zPosition = 1000
        view.addTarget(self, action: #selector(handleEssentialsTap), for: .touchUpInside)
        return view
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
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Additional message"
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
    
//    let messageLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
//        label.font = UIFont.init(name: "GorditaBlack", size: 13)
//        label.textAlignment = .left
//        label.textColor = .white
//        label.text = "Additional Message"
//        label.numberOfLines = 1
//        return label
//    }()
    
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
    
    var packageSelect = ["signals": false, "essentials": false, "advanced": false, "elite": false]
    
    var signalsIsSelected = Bool()
    var essentialsIsSelected = Bool()
    var advancedIsSelected = Bool()
    var grandfatheredIsSelected = Bool()
    var eliteIsSelected = Bool()
    
    let pairOptions = ["AUDCAD", "AUDCHF","AUDJPY", "AUDNZD", "AUDUSD","CADCHF", "CADJPY", "CHFJPY", "EURAUD", "EURCAD", "EURCHF", "EURGBP", "EURJPY", "EURNZD", "EURUSD", "GBPAUD", "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "GBPUSD", "MXNUSD", "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD", "USDCHF", "USDCAD", "USDJPY", "XAUUSD", "US30"]
    let tradeTypes = ["Buy", "Sell", "Buy Limit", "Buy Stop", "Sell Limit", "Sell Stop"]
    let tradeStyle = ["Swing", "Scalp"]
    let emaLevel = ["20 EMA", "50 EMA", "200 EMA", "800 EMA"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        signalsIsSelected = false
        essentialsIsSelected = false
        advancedIsSelected = false
        grandfatheredIsSelected = false
        eliteIsSelected = false
        
        pairPicker.delegate = self
        tradePicker.delegate = self
        emaPicker.delegate = self
        stylePicker.delegate = self
        
        tradeTypeField.inputView = tradePicker
        pairField.inputView = pairPicker
        tradingStyleField.inputView = stylePicker
        
        backgroundColor = .clear
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendSignal), name: Notification.Name("createSignalTapped"), object: nil)
        
    }
    
    @objc func handleSignalTap() {
        if signalsIsSelected == false {
            signalsBox.backgroundColor = .white
            signalsIsSelected = true
            packageSelect.updateValue(true, forKey: "signals")
            print(packageSelect)
        }else{
            signalsBox.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
            signalsIsSelected = false
            packageSelect.updateValue(false, forKey: "signals")
            print(packageSelect)
        }
    }
    
    @objc func handleEssentialsTap() {
        if essentialsIsSelected == false {
            essentialsBox.backgroundColor = .white
            essentialsIsSelected = true
            packageSelect.updateValue(true, forKey: "essentials")
            print(packageSelect)
        }else{
            essentialsBox.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
            essentialsIsSelected = false
            packageSelect.updateValue(false, forKey: "essentials")
            print(packageSelect)
        }
    }
    
    @objc func handleAdvancedTap() {
        if advancedIsSelected == false {
            advancedBox.backgroundColor = .white
            advancedIsSelected = true
            packageSelect.updateValue(true, forKey: "advanced")
            print(packageSelect)
        }else{
            advancedBox.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
            advancedIsSelected = false
            packageSelect.updateValue(false, forKey: "advanced")
            print(packageSelect)
        }
    }
    
    @objc func handleEliteTap() {
        if eliteIsSelected == false {
            eliteBox.backgroundColor = .white
            eliteIsSelected = true
            packageSelect.updateValue(true, forKey: "elite")
            print(packageSelect)
        }else{
            eliteBox.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
            eliteIsSelected = false
            packageSelect.updateValue(false, forKey: "elite")
            print(packageSelect)
        }
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
        typeStackView.addArrangedSubview(typeLabel)
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
        
        let messageStackView = UIStackView()
        messageStackView.addArrangedSubview(messageLabel)
        messageStackView.addArrangedSubview(messageField)
        messageStackView.spacing = 5
        //        riskTwoStackView.alignment = .leading
        //        riskTwoStackView.distribution = .fillProportionally
        messageStackView.axis = .vertical
        messageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let signalsStackView = UIStackView()
        signalsStackView.addArrangedSubview(signalsBox)
        signalsStackView.addArrangedSubview(signalsLabel)
        signalsStackView.spacing = 5
        //        riskTwoStackView.alignment = .leading
        //        riskTwoStackView.distribution = .fillProportionally
        signalsStackView.axis = .horizontal
        signalsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let essentialsStackView = UIStackView()
        essentialsStackView.addArrangedSubview(essentialsBox)
        essentialsStackView.addArrangedSubview(essentialsLabel)
        essentialsStackView.spacing = 5
        //        riskTwoStackView.alignment = .leading
        //        riskTwoStackView.distribution = .fillProportionally
        essentialsStackView.axis = .horizontal
        essentialsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let eliteStackView = UIStackView()
        eliteStackView.addArrangedSubview(eliteBox)
        eliteStackView.addArrangedSubview(eliteLabel)
        eliteStackView.spacing = 5
        //        riskTwoStackView.alignment = .leading
        //        riskTwoStackView.distribution = .fillProportionally
        eliteStackView.axis = .horizontal
        eliteStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let advancedStackView = UIStackView()
        advancedStackView.addArrangedSubview(advancedBox)
        advancedStackView.addArrangedSubview(advancedLabel)
        advancedStackView.spacing = 5
        //        riskTwoStackView.alignment = .leading
        //        riskTwoStackView.distribution = .fillProportionally
        advancedStackView.axis = .horizontal
        advancedStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let boxesStackView = UIStackView()
        boxesStackView.addArrangedSubview(signalsStackView)
        boxesStackView.addArrangedSubview(essentialsStackView)
        boxesStackView.addArrangedSubview(advancedStackView)
        boxesStackView.addArrangedSubview(eliteStackView)
        boxesStackView.spacing = 15
        //        riskTwoStackView.alignment = .leading
        //        riskTwoStackView.distribution = .fillProportionally
        boxesStackView.axis = .vertical
        boxesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainBoxesStackView = UIStackView()
        mainBoxesStackView.addArrangedSubview(packageLabel)
        mainBoxesStackView.addArrangedSubview(boxesStackView)
        mainBoxesStackView.spacing = 10
        //        riskTwoStackView.alignment = .leading
        //        riskTwoStackView.distribution = .fillProportionally
        mainBoxesStackView.axis = .vertical
        mainBoxesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView()
        mainStackView.addArrangedSubview(tradeStyleStackView)
        mainStackView.addArrangedSubview(typeStackView)
        mainStackView.addArrangedSubview(pairStackView)
        mainStackView.addArrangedSubview(entryStackView)
        mainStackView.addArrangedSubview(slStackView)
        mainStackView.addArrangedSubview(tpOneStackView)
        mainStackView.addArrangedSubview(tpTwoStackView)
        mainStackView.addArrangedSubview(riskTwoStackView)
        mainStackView.addArrangedSubview(messageStackView)
        mainStackView.addArrangedSubview(mainBoxesStackView)
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
            endEditing(true)
        }else if pickerView == pairPicker {
            pairField.text = pairOptions[row]
            endEditing(true)
        }else if pickerView == stylePicker {
            tradingStyleField.text = tradeStyle[row]
            endEditing(true)
        }else {
            slField.text = emaLevel[row]
            endEditing(true)
        }
    }
    
    func sendNewSignal() {
        guard let myUrl = URL(string: "https://api.lionsofforex.com/adminv2/send_signal") else { return }
        
        guard let stoploss = slField.text else { return }
        guard let style = tradingStyleField.text else { return }
        guard let symbol = pairField.text else { return }
        guard let type = tradeTypeField.text else { return }
        guard let entryprice = entryField.text else { return }
        guard let takeprofit = tpOneField.text else { return }
        guard let takeprofit2 = tpTwoField.text else { return }
        guard let riskreward = riskField.text else { return }
        guard let message = messageField.text else { return }
        
        var postFill = [String]()
        
        let packageSelectDict = packageSelect as NSDictionary
        
        if packageSelectDict.value(forKey: "signals") as! Bool == true {
            postFill.append("13")
            
        }
        if packageSelectDict.value(forKey: "essentials") as! Bool == true {
            postFill.append("14")
        }
        if packageSelectDict.value(forKey: "advanced") as! Bool == true {
            postFill.append("15")
        }
        if packageSelectDict.value(forKey: "elite") as! Bool == true {
            postFill.append("31")
        }else{
            
        }
        
        print(postFill.joined(separator: ","))
        

        let option = """
        Type: \(type)
        Pair: \(symbol)
        Entry: \(entryprice)
        TP1: \(takeprofit)
        TP2: \(takeprofit2)
        SL: \(stoploss)
        Style: \(style)
        """
        // send http request to perform sign in
        
        let postString: [String: String] = ["style": style, "type": type, "symbol": symbol, "entryprice": entryprice, "stoploss": stoploss, "takeprofit": takeprofit, "takeprofit2": takeprofit2, "riskreward": riskreward, "additionalMessage": message, "personalNote": "", "packages": postFill.joined(separator: ",")]
        
        Alamofire.request(myUrl, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)

                // to get json return value
                if let result = response.result.value {
                    if let json = result as? NSDictionary {
                        if let userId = json.object(forKey: "success") {
                            print(json)
                            print(userId)
                            DispatchQueue.main.async {
                                self.clearFields()
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalStopLoading"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignal"), object: nil)
                                
                            }
                        }else{
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalStopLoading"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name("ErrorSendingSignal"), object: nil)
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalStopLoading"), object: nil)
                        NotificationCenter.default.post(name: Notification.Name("ErrorSendingSignal"), object: nil)
                    }
                }
        }
        
        guard let notificationURL = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "key=AAAA7Kq_MHM:APA91bHpRkxsJ5z7sZ3oUqDFq5VHtUs26Ogh9n4PijQYGs5vR7ZuTsefjUSP66bx0t5ibw1hRNGQNO7f0MeyXixTjWHydgfw7NTJvLDk_TXoF5Jx3yMANxz2-_0DCxG-iU5RM1Jh2agf",
            "Accept": "application/json"
        ]
        
        
        let postStringNotification = ["to": "/topics/active", "notification": ["title": "New Signal", "body": option, "badge": "1"]] as [String : Any]
        // send http request to perform sign in
        
        Alamofire.request(notificationURL, method: .post, parameters: postStringNotification, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                
                // to get json return value
                if let result = response.result.value {
                    if let json = result as? NSDictionary {
                        print(json)
                        if let userId = json.object(forKey: "message_id") {
                            print(userId)
                            
                        }else{
                            print("Could not send notification.")
                        }
                    }
                }
        }
    }
    
    func sendNotification() {
        
    }
    
    func clearFields() {
        slField.text = ""
        tradingStyleField.text = ""
        pairField.text = ""
        tradeTypeField.text = ""
        entryField.text = ""
        tpOneField.text = ""
        tpTwoField.text = ""
        riskField.text = ""
        messageField.text = ""
    }
    
    @objc func sendSignal() {
        if (tradeTypeField.text?.isEmpty)! || (pairField.text?.isEmpty)! || (entryField.text?.isEmpty)! || (slField.text?.isEmpty)! || (tradingStyleField.text?.isEmpty)! || (tpOneField.text?.isEmpty)! {
            print(packageSelect.values.description)
            NotificationCenter.default.post(name: Notification.Name("SendSignalError"), object: nil)
        }else if packageSelect.values.description == "[false, false, false, false]"{
            NotificationCenter.default.post(name: Notification.Name("SelectPackageError"), object: nil)
        }else{
            NotificationCenter.default.post(name: Notification.Name("SuccessfullySentSignalStartLoading"), object: nil)
            sendNewSignal()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CreateSignalFooter: UICollectionViewCell {
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SEND", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "GorditaBlack", size: 13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 36/255, green: 241/255, blue: 181/255, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CANCEL", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 36/255, green: 241/255, blue: 181/255, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(confirmButtonTapped))
        confirmButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupViews() {
        addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            confirmButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0),
            ])
    }
    
    @objc func closeButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("closeCreateSignalPage"), object: nil)
    }
    
    @objc func confirmButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("createSignalTapped"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
