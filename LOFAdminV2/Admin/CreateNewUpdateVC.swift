//
//  CreateNewSignalVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/13/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import AVKit

struct NotificationSelection {
    var title = String()
    var url = String()
}

class CreateNewUpdateVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userblankprofile")
        imageView.backgroundColor = .clear
        let newColor = UIColor.white.cgColor
        imageView.layer.borderColor = newColor
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "HeaderLogo")
        return imageView
    }()
    
    let backHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 1)
        //        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
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
    
    let menuBar: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = .black
        return tView
    }()
    
    let entryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Type notification here"
        label.numberOfLines = 1
        return label
    }()
    
//    let entryField: UITextField = {
//        let textField = TextFieldVC()
//        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
//        textField.layer.cornerRadius = 0
//        let whiteColor = UIColor.white.cgColor
//        textField.layer.borderColor = whiteColor
//        textField.layer.borderWidth = 0
//        textField.textColor = .white
//        textField.tintColor = .white
//        textField.textColor = .white
//        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//        textField.layer.cornerRadius = 8
//        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.contentMode = .topLeft
//
//        return textField
//    }()
    
    let entryField: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.contentMode = .topLeft
        textField.allowsEditingTextAttributes = false
        textField.isEditable = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return textField
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Target Audience"
        label.numberOfLines = 1
        return label
    }()
    
    let typeField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.contentMode = .topLeft
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return textField
    }()
    
    let titleLabell: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.font = UIFont.init(name: "GorditaBlack", size: 13)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Notification Title"
        label.numberOfLines = 1
        return label
    }()
    
    let titleField: UITextField = {
        let textField = TextFieldVC()
        textField.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        textField.layer.cornerRadius = 0
        let whiteColor = UIColor.white.cgColor
        textField.layer.borderColor = whiteColor
        textField.layer.borderWidth = 0
        textField.textColor = .white
        textField.tintColor = .white
        textField.textColor = .white
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.contentMode = .topLeft
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return textField
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CANCEL", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
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
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SEND", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "GorditaBlack", size: 13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 36/255, green: 241/255, blue: 181/255, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let pairPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
//        iv.image = UIImage(named: "DashboardBackgroundImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let tradePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let emaPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
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
        label.text = "Send Notification"
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
        button.setTitle("SIGNAL", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.layer.zPosition = 1
        button.layer.masksToBounds = true
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    var player: AVPlayer?
    let videoURL: NSURL = Bundle.main.url(forResource: "signalsVideo", withExtension: ".mp4")! as NSURL
    
    let pairOptions = ["AUDUSD", "CHFJPY", "EURUSD", "GBPAUD", "GBPJPY", "GBPNZD", "USDCAD", "USDCHF", "USDJPY", "XAUUSD"]
    
    let tradeTypes = ["Buy", "Sell", "Buy Limit", "Buy Stop", "Sell Limit", "Sell Stop"]
    let emaLevel = ["20 EMA", "50 EMA", "200 EMA", "800 EMA"]
    
    let pickerOptions = [NotificationSelection(title: "Active Users", url: "active"), NotificationSelection(title: "All Users", url: "allusers")]
    
    let optionPicker = UIPickerView()
    
    var destinationString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        optionPicker.delegate = self
        optionPicker.dataSource = self
        
        typeField.inputView = optionPicker
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        setupView()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func updateButtonTapped() {
        print("open updates")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        let stackViewOne: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(titleLabell)
            sv.addArrangedSubview(titleField)
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.spacing = 5
            sv.axis = .vertical
            sv.alignment = .fill
            return sv
        }()
        
        let stackViewTwo: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(entryLabel)
            sv.addArrangedSubview(entryField)
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.spacing = 5
            sv.axis = .vertical
            sv.alignment = .fill
            return sv
        }()
        
        let stackViewThree: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(typeLabel)
            sv.addArrangedSubview(typeField)
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.spacing = 5
            sv.axis = .vertical
            sv.alignment = .fill
            return sv
        }()
        
        let stackViewFour: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(stackViewOne)
            sv.addArrangedSubview(stackViewTwo)
            sv.addArrangedSubview(stackViewThree)
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.spacing = 10
            sv.axis = .vertical
            sv.alignment = .fill
            return sv
        }()
        
        view.addSubview(backgroundImage)
        view.addSubview(menuBar)
        view.addSubview(topSpacer)
        view.addSubview(viewHolder)
        
//        viewHolder.addSubview(cellHolder)
        topSpacer.addSubview(totalPipLabel)
        topSpacer.addSubview(secondPipLabel)
        topSpacer.addSubview(closeButton)
        view.addSubview(bottomSpacer)
        
//        viewHolder.addSubview(entryLabel)
        viewHolder.addSubview(stackViewFour)
        viewHolder.addSubview(confirmButton)
        
        //
        NSLayoutConstraint.activate([
            menuBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
            
            stackViewFour.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 20),
            stackViewFour.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: -20),
            stackViewFour.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: 30),
            
//            entryField.heightAnchor.constraint(equalToConstant: 50),
//            entryField.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 20),
//            entryField.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: -20),
//            entryField.topAnchor.constraint(equalTo: entryLabel.bottomAnchor, constant: 5),
            
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: viewHolder.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            closeButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: topSpacer.trailingAnchor, constant: -15)

            ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let iP = pickerOptions[row]
        return iP.title
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let iP = pickerOptions[row]
        destinationString = iP.url
        typeField.text = iP.title
        view.endEditing(true)
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
    
    func playAudioMix() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    @objc func confirmButtonTapped() {
        print("Posting signal")
        // display message saying signal posted successfullly
        if entryField.text!.isEmpty || typeField.text!.isEmpty || titleField.text!.isEmpty {
            displayMessage(userMessage: "All fields required.")
        }else{
            performSend()
            displayMessage(userMessage: "Notification successfully sent.")
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    func performSend() {
        guard let myUrl = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "key=AAAA7Kq_MHM:APA91bHpRkxsJ5z7sZ3oUqDFq5VHtUs26Ogh9n4PijQYGs5vR7ZuTsefjUSP66bx0t5ibw1hRNGQNO7f0MeyXixTjWHydgfw7NTJvLDk_TXoF5Jx3yMANxz2-_0DCxG-iU5RM1Jh2agf",
            "Accept": "application/json"
        ]
        
        guard let message = entryField.text else { return }
        guard let titlePrompt = titleField.text else { return }
        
        
        let postString = ["to": "/topics/\(destinationString)", "notification": ["title": titlePrompt, "body": message, "badge": "1"]] as [String : Any]
        // send http request to perform sign in
        
        Alamofire.request(myUrl, method: .post, parameters: postString, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                
                // to get json return value
                if let result = response.result.value {
                    if let json = result as? NSDictionary {
                        print(json)
                        if let userId = json.object(forKey: "message_id") {
                            print(userId)
                            DispatchQueue.main.async {
                                self.displayMessage(userMessage: "Notification successfully sent.")
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.displayMessage(userMessage: "Could not send notification.")
                            }
                        }
                    }
                }
        }
    }
    
    @objc func closeButtonTapped() {
        print("closing page")
        navigationController?.popViewController(animated: true)
    }
    
}
