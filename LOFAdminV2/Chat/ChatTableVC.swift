//
//  ChatTableVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Starscream
import Alamofire
import SwiftSoup
import SwiftyJSON

class ChatTableVC: UIViewController,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    var socket = WebSocket(url: URL(string: "wss://api.lionsofforex.com/ws/")!)
    let Username: String? = KeychainWrapper.standard.string(forKey: "accessToken")
    var Messages = [String]()
    var ProfileImages = [String]()
    var MessageType = [String]()

//    var selectedSession = String()
    var selectedSession = String()
    let selectedRoom = "1"
    
    var selectedRoomID = String()
    
    var DelegatedVC: ChatCategoryVC?

    let chatTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let menuBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
//        view.backgroundColor = .white
        
        return view
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .vertical
//        cv.backgroundColor = UIColor.init(red: 246/255, green: 247/255, blue: 251/255, alpha: 1)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    
    // MARK: Setup textfield
    
    let textField: TextFieldVC = {
        let tv = TextFieldVC()
        tv.tintColor = UIColor.black
        tv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tv.layer.cornerRadius = 20
        tv.clipsToBounds = true
        tv.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        tv.placeholder = "Aa"
        tv.addTarget(self, action: #selector(toggleSend), for: .valueChanged)
        tv.addTarget(self, action: #selector(toggleSend), for: .editingDidBegin)
        tv.addTarget(self, action: #selector(toggleSend), for: .editingDidEnd)
        tv.addTarget(self, action: #selector(toggleSend), for: .allEditingEvents)
        tv.addTarget(self, action: #selector(toggleSend), for: .allEvents)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let textFieldHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "emoji_message"), for: .normal)
        button.tintColor = UIColor.blue
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.clipsToBounds = true
        return button
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "send_message"), for: .normal)
        button.tintColor = UIColor.blue
        button.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "camera_message"), for: .normal)
        button.tintColor = UIColor.blue
        button.imageEdgeInsets = UIEdgeInsets(top: 7.7, left: 7.7, bottom: 7.7, right: 7.7)
        button.clipsToBounds = true
        return button
    }()
    
    let pictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "photo_message"), for: .normal)
        button.tintColor = UIColor.blue
        button.imageEdgeInsets = UIEdgeInsets(top: 7.7, left: 7.7, bottom: 7.7, right: 7.7)
        button.clipsToBounds = true
        return button
    }()
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "menu_message"), for: .normal)
        button.tintColor = UIColor.blue
        button.imageEdgeInsets = UIEdgeInsets(top: 7.7, left: 7.7, bottom: 7.7, right: 7.7)
        button.clipsToBounds = true
        return button
    }()
    
    let thumbsUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "thumb_message"), for: .normal)
        button.tintColor = UIColor.blue
        button.imageEdgeInsets = UIEdgeInsets(top: 7.7, left: 7.7, bottom: 7.7, right: 7.7)
        button.clipsToBounds = true
        return button
    }()
    
    let micButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "mic_message"), for: .normal)
        button.tintColor = UIColor.blue
        button.imageEdgeInsets = UIEdgeInsets(top: 7.7, left: 7.7, bottom: 7.7, right: 7.7)
        button.clipsToBounds = true
        return button
    }()
    
    let endButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "forward_arrow"), for: .normal)
        button.tintColor = UIColor.blue
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(handleAnimationTapped), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: Setup top bar
    let navBarTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.text = "Lions Den"
        label.textAlignment = .left
        label.contentMode = .center
        return label
    }()
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back_arrow"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
//        button.tintColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        button.tintColor = .blue
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let buttonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.backgroundColor = .clear
//        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }()
    
    let chatImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let CellId = "chatCellId"
    let NewCellId = "NewCellId"
    let MainCellId = "mainCellId"
    
    var data1 = [[String: AnyObject]]()
    var bottomConstraint = NSLayoutConstraint()
    
    var keyboardHeight = CGFloat()
    
    var isKeyboardAppear = false
    
    weak var composeViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.delegate = self
        socket.connect()
        
        let selectedMess: String? = KeychainWrapper.standard.string(forKey: "selectedMessage")
        selectedRoomID = selectedMess!
        
        let selectedSess: String? = KeychainWrapper.standard.string(forKey: "ChatSession")
        selectedSession = selectedSess!
        
        let selectedImage: String? = KeychainWrapper.standard.string(forKey: "selectedMessageImage")
        chatImage.image = UIImage(named: selectedImage!)
        
        let selectedRoomName: String? = KeychainWrapper.standard.string(forKey: "selectedMessageRoom")
        navBarTitle.text = selectedRoomName

        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        textField.delegate = self
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = textFieldHolder.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textFieldHolder.addSubview(blurEffectView)
        
        let blurEffectTwo = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectViewTwo = UIVisualEffectView(effect: blurEffectTwo)
        blurEffectViewTwo.frame = bottomView.bounds
        blurEffectViewTwo.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bottomView.addSubview(blurEffectViewTwo)
    
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: NewCellId)
        cellHolder.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: MainCellId)
        
        startTimer()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatTableVC.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatTableVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        textFieldHolder.snapshotView(afterScreenUpdates: true)
//        view.update
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatTableVC.keepAlive), userInfo: nil, repeats: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data1.count
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        self.textFieldHolder.frame.origin.y -= keyboardHeight - bottomView.frame.height
//        self.cellHolder.frame.origin.y -= keyboardHeight
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        if (textField.text?.isEmpty)! {
////            print("empty")
////
////        }else{
////            print("sending")
////        }
//    }
    
    @objc func toggleSend() {
        if (textField.text?.isEmpty)! {
            sendButton.isHidden = true
            thumbsUpButton.isHidden = false
            
        }else{
            sendButton.isHidden = false
            thumbsUpButton.isHidden = true
        }
    }
    
    @objc func handleAnimation() {
        if isKeyboardAppear == true {
            print("textfield is focused")
            textFieldHolder.addSubview(endButton)
            endButton.leadingAnchor.constraint(equalTo: textFieldHolder.leadingAnchor, constant: 10).isActive = true
            endButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor).isActive = true
            endButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            endButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            sendButton.trailingAnchor.constraint(equalTo: textFieldHolder.trailingAnchor, constant: -5).isActive = true
            sendButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor).isActive = true
            sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            
            textField.leadingAnchor.constraint(equalTo: endButton.trailingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10).isActive = true
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true

            
            self.menuButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.cameraButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.pictureButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.micButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.endButton.transform = CGAffineTransform(translationX: 100, y: 0)
            
            self.endButton.alpha = 1 //0
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.endButton.alpha = 1
                self.menuButton.transform = CGAffineTransform(translationX: -500, y: 0)
                self.cameraButton.transform = CGAffineTransform(translationX: -500, y: 0)
                self.pictureButton.transform = CGAffineTransform(translationX: -500, y: 0)
                self.micButton.transform = CGAffineTransform(translationX: -500, y: 0)
                self.endButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.textField.layoutIfNeeded()
            }) { (_) in
                //
//                self.thumbsUpButton.isHidden = true
//                self.menuButton.isHidden = true
//                self.micButton.isHidden = true
//                self.cameraButton.isHidden = true
//                self.pictureButton.isHidden = true
//                self.textField.layoutIfNeeded()
            }
        }else{
            print("textfield is focused")
            self.endButton.alpha = 1
            textField.leadingAnchor.constraint(equalTo: micButton.trailingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: thumbsUpButton.leadingAnchor, constant: -10).isActive = true
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            self.textField.layer.zPosition = 100
            self.endButton.layer.zPosition = 1
            
            self.menuButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.cameraButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.pictureButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.micButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.endButton.transform = CGAffineTransform(translationX: 0, y: 0)
            
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.textField.layoutIfNeeded()
                self.endButton.alpha = 1 //0
                self.menuButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.cameraButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.pictureButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.micButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.endButton.transform = CGAffineTransform(translationX: 100, y: 0)
            }) { (_) in
                //
                self.endButton.removeFromSuperview()
            }
        }
    }
    
    @objc func handleAnimationTapped() {
        if isKeyboardAppear == true {
            print("textfield is focused")
            self.endButton.alpha = 1
            textField.leadingAnchor.constraint(equalTo: micButton.trailingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: thumbsUpButton.leadingAnchor, constant: -10).isActive = true
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            
            
            self.menuButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.cameraButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.pictureButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.micButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.endButton.transform = CGAffineTransform(translationX: 0, y: 0)
            
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.textField.layoutIfNeeded()
                self.endButton.alpha = 1 //0
                self.menuButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.cameraButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.pictureButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.micButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.endButton.transform = CGAffineTransform(translationX: 100, y: 0)
            }) { (_) in
                //
                self.endButton.removeFromSuperview()
            }
        }else{
            
        }
    }
    // setup cell
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let messageIndex = data1[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCellId, for: indexPath) as! ChatLogMessageCell
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let msgText = messageIndex["message"]?.description
        let estimatedFrame = NSString(string: msgText!).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        let iP = data1[indexPath.row]
        let firstName: String? = KeychainWrapper.standard.string(forKey: "nameToken")
        let firstID = firstName?.components(separatedBy: " ")[0]
        let messageString = iP["message"]?.description
        //            let strOne = iP["name"]?.description
        let name = iP["name"]?.description
        
        if name == firstID {
            
            //outgoing sending message
            
            cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8,y:  0,width:  estimatedFrame.width + 16,height:  estimatedFrame.height + 20)
            
            cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10,y: -4,width: estimatedFrame.width + 16 + 8 + 10,height: estimatedFrame.height + 20 + 6)
            
            cell.profileImageView.isHidden = true
            cell.userLabel.isHidden = true
            
            cell.textBubbleView.backgroundColor = .clear
            cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
            cell.bubbleImageView.tintColor = UIColor.init(red: 83/255, green: 223/255, blue: 193/255, alpha: 1)
            cell.messageTextView.textColor = UIColor.white
//            cell.textBubbleView.backgroundColor = UIColor.init(red: 83/255, green: 223/255, blue: 193/255, alpha: 1)
            cell.messageTextView.text = messageString
            cell.userLabel.text = name
            cell.dateLabel.isHidden = true
            
            
        } else {
            
            
            cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0,  width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            
            cell.messageTextView.textColor = UIColor.black
            cell.textBubbleView.backgroundColor = UIColor.clear
            cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            cell.bubbleImageView.tintColor = UIColor.init(red: 233/255, green: 234/255, blue: 236/255, alpha: 1)
            cell.dateLabel.text = iP["time"]?.description
            //                let strTwo = iP.slice(from: "<\\/p>\\n ", to: "\\n <\\/div>\\n <\\/div>\\n <\\/li>")
            cell.messageTextView.text = iP["message"]?.description
            cell.userLabel.text = name
            if let photoString = iP["photo"]?.description {
//                let strTwo = photoString.slice(from: "<\\/p>\\n ", to: "\\n <\\/div>\\n <\\/div>\\n <\\/li>")
//                let pstring1 = photoString.components(separatedBy: "assets/")[1]
//                print(pstring1)
                if let url:URL = NSURL(string: photoString) as URL? {
                    
                    cell.profileImageView.setImageWith(url, placeholderImage: UIImage(named: ""))
                }
            }
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let iP = data1[indexPath.row]
        
        
        if let messageText = iP["message"]?.description {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)],context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 30, right: 0)
//        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 45
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.cellHolder.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomView.frame.height)
            self.textFieldHolder.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomView.frame.height)
            
            self.keyboardHeight = keyboardSize.height
            
            let item = self.collectionView(self.cellHolder, numberOfItemsInSection: 0) - 1
            let lastItemIndex = IndexPath(item: item, section: 0)
            self.cellHolder.scrollToItem(at: lastItemIndex, at: .top, animated: true)
            
            //
            
            if isKeyboardAppear == false {
                isKeyboardAppear = true
            }else{
                isKeyboardAppear = true
            }
            DispatchQueue.main.async {
                self.handleAnimation()
            }
            
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.textFieldHolder.frame.origin.y += keyboardSize.height
            self.cellHolder.frame.origin.y += keyboardSize.height
            
            self.cellHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            self.textFieldHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            
            //
            if isKeyboardAppear == true {
                isKeyboardAppear = false
            }else{
                isKeyboardAppear = false
            }
            
            DispatchQueue.main.async {
                self.handleAnimation()
            }
            
        }
    }

    @objc func keepAlive() {
//        print("keep alive")
        socket.write(string: "{\"mode\": \"keepalive\"}")
    }
    
    // MARK: Setup send buttons
    @objc func sendMessage() {
        if (textField.text?.isEmpty)! {
            print("nothing in field")
        }else{
            let text = textField.text
            let room = selectedRoomID
            let session = selectedSession
            
            socket.write(string: "{\"room\": \"\(room)\",\"session\": \"\(session)\",\"text\": \"\(text ?? "")\"}")
        }
        
    }
    
    func messageReceived(_ message: String, senderName: String, senderTime: String, senderImageURL: String) {
        
    }

    // MARK: Setupview
    func setupView() {
        view.addSubview(cellHolder)
        view.addSubview(textFieldHolder)
        
        textFieldHolder.addSubview(textField)
        
        textFieldHolder.addSubview(thumbsUpButton)
        textFieldHolder.addSubview(sendButton)
        textFieldHolder.addSubview(menuButton)
        textFieldHolder.addSubview(cameraButton)
        textFieldHolder.addSubview(pictureButton)
        textFieldHolder.addSubview(micButton)
        textFieldHolder.addSubview(emojiButton)
        
        view.addSubview(menuBar)
        view.addSubview(menuTop)
        view.addSubview(bottomView)
        
        menuBar.addSubview(backButton)
        menuBar.addSubview(navBarTitle)
        menuBar.addSubview(buttonTwo)
        menuBar.addSubview(chatImage)
        
//        sendButton.layer.cornerRadius = chatImage.frame.height / 2
//        sendButton.layoutIfNeeded()
        
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: textFieldHolder.topAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            thumbsUpButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            thumbsUpButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            thumbsUpButton.trailingAnchor.constraint(equalTo: textFieldHolder.trailingAnchor, constant: -10),
            thumbsUpButton.widthAnchor.constraint(equalTo: thumbsUpButton.heightAnchor),
            
            sendButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            sendButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: textFieldHolder.trailingAnchor, constant: -10),
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),
            
            // MARK SETUP BOTTOM BUTTONS
            
            menuButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            menuButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            menuButton.leadingAnchor.constraint(equalTo: textFieldHolder.leadingAnchor, constant: 0),
            menuButton.widthAnchor.constraint(equalTo: menuButton.heightAnchor),
            
            cameraButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: 0),
            cameraButton.widthAnchor.constraint(equalTo: cameraButton.heightAnchor),
            
            pictureButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            pictureButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            pictureButton.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 0),
            pictureButton.widthAnchor.constraint(equalTo: pictureButton.heightAnchor),
            
            micButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            micButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            micButton.leadingAnchor.constraint(equalTo: pictureButton.trailingAnchor, constant: 0),
            micButton.widthAnchor.constraint(equalTo: micButton.heightAnchor),
            
            emojiButton.topAnchor.constraint(equalTo: textField.topAnchor, constant: 3),
            emojiButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: -3),
            emojiButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            emojiButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -3),
            emojiButton.widthAnchor.constraint(equalTo: emojiButton.heightAnchor),
            
            textFieldHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textFieldHolder.heightAnchor.constraint(equalToConstant: 60),
            textFieldHolder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textFieldHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textField.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: micButton.trailingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: thumbsUpButton.leadingAnchor, constant: -5),
            
            
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: menuBar.topAnchor, constant: 5),
            backButton.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: -5),
            backButton.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 0),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            navBarTitle.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            navBarTitle.leadingAnchor.constraint(equalTo: chatImage.trailingAnchor, constant: 5),
            navBarTitle.trailingAnchor.constraint(equalTo: buttonTwo.leadingAnchor, constant: -10),
            
            buttonTwo.topAnchor.constraint(equalTo: menuBar.topAnchor, constant: 5),
            buttonTwo.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: -5),
            buttonTwo.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -5),
            buttonTwo.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            chatImage.heightAnchor.constraint(equalToConstant: 30),
            chatImage.widthAnchor.constraint(equalTo: chatImage.heightAnchor),
            chatImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            chatImage.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 0),
            
            bottomView.topAnchor.constraint(equalTo: textFieldHolder.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            ])
        
        self.sendButton.isHidden = true
        
//        self.emojiButton.layer.cornerRadius = self.emojiButton.frame.height / 2
    }
    
    @objc func closePage() {
        // Remove strings
        navigationController?.popViewController(animated: true)
        selectedRoomID.removeAll()
        KeychainWrapper.standard.removeObject(forKey: "selectedMessage")
        KeychainWrapper.standard.removeObject(forKey: "selectedMessageImage")
        KeychainWrapper.standard.removeObject(forKey: "selectedMessageRoom")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

class ChatViewCell: UITableViewCell {
    
    
    let CellId = "chatCellId"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: CellId)
        
        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


// MARK: - WebSocketDelegate
extension ChatTableVC : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {

        socket.write(string: "{\"mode\": \"setup\",\"room\": \"\(selectedRoomID)\"}")
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatTableVC.keepAlive), userInfo: nil, repeats: true)

    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        // MARK: Strip HTML
        // 1
//        guard let data = text.data(using: .utf16),
//            let jsonData = try? JSONSerialization.jsonObject(with: data),
//            let jsonDict = jsonData as? [String: Any],
//            let messageType = jsonDict["type"] as? String else {
//                return
//        }
//        print(text)
        
        // MARK: setup new parse
//        print(text)
        guard let data = text.data(using: .utf16) else { return }
        
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let jsonData = jsonData {
            let jsonDict = JSON(jsonData)
//            print(jsonDict)
            if let innerJson = jsonDict["tmpl"].array {
                for results in innerJson {
                    if let active = results.dictionary {
                        let isRecieved = active["type"]
                        print(active as [String: AnyObject])
                        if  let recievedString:String = isRecieved?.description {
                            if recievedString == "received" {
                                self.data1.append(active as [String : AnyObject])
                            }else if recievedString == "sent"{
                                self.data1.append(active as [String : AnyObject])
                            }else{
                                self.data1.append(active as [String : AnyObject])
                            }
                        }
                    }
                    
                    if self.data1.count > 0 {
                        self.cellHolder.reloadData()
                        let item = self.collectionView(self.cellHolder, numberOfItemsInSection: 0) - 1
                        let lastItemIndex = IndexPath(item: item, section: 0)
                        self.cellHolder.scrollToItem(at: lastItemIndex, at: .top, animated: true)
//                        self.refresherControl.endRefreshing()
//                        self.animationView.stop()
//                        self.pageOverlay.removeFromSuperview()
                    }
                }
            }

        }else{
            print("oops something went wrong")
        }
        
//        socket.write(string: "{\"mode\": \"setup\",\"room\": \"\(selectedRoomID)\"}")
        

    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
   
}
class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.backgroundColor = UIColor.init(red: 233/255, green: 234/255, blue: 236/255, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.text = "Username here"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        label.text = "9:21am"
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(userLabel)
        addSubview(dateLabel)
        
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        
        userLabel.bottomAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: -7).isActive = true
        userLabel.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor).isActive = true
        userLabel.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor).isActive = true
        
        profileImageView.backgroundColor = UIColor.black
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
    
}

class ChatCollectionViewCell: UICollectionViewCell {
    
    let messageTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tv.isEditable = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutIfNeeded()
        
        
        setupView()
    }
    
    func setupView() {
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        
        NSLayoutConstraint.activate([
            textBubbleView.topAnchor.constraint(equalTo: topAnchor),
            textBubbleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textBubbleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textBubbleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            messageTextView.topAnchor.constraint(equalTo: topAnchor),
            messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

class MessageCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mark Zuckerberg"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friend's message and something else..."
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        profileImageView.image = UIImage(named: "zuckprofile")
        hasReadImageView.image = UIImage(named: "zuckprofile")
        
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}
