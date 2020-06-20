//
//  ViewController.swift
//  GroupedMessagesLBTA
//
//  Created by Brian Voong on 8/25/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import AVKit
import Starscream
import Alamofire
import SwiftyJSON
import AFNetworking
import Photos
import SwiftKeychainWrapper

struct ChatMessage {
    var id: String
    var text: String
    var sender: String
    var senderId: String
    var isIncoming: Bool
    var isReaction: Bool
    var heart: Bool
    var haha: Bool
    var wow: Bool
    var sad: Bool
    var angry: Bool
    var like: Bool
    var date: Date
    var photo: String
    var reactions: String
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var socket = WebSocket(url: URL(string: "wss://api.lionsofforex.com/ws/")!)
    let Username: String? = "LOF"
    
    var selectedSession = String()
    
    var selectedRoom = String()
    
    var selectedRoomID = String()
    var images = [PHAsset]()
    var firstId = String()
    var lastId = String()
    
    
//    var DelegatedVC: ChatCategoryVC?
    
    let menuBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
//    let messageCountHolder: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        return view
//    }()
    
    // MARK: Setup top bar
    let navBarTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.text = "Room"
        label.textAlignment = .left
        label.contentMode = .center
        return label
    }()
    
    let navBarSubtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .lightGray
        label.text = "Chatroom"
        label.textAlignment = .left
        label.contentMode = .center
        return label
    }()
    
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back_arrow"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(goBackTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let buttonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "info_icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.backgroundColor = .clear
        //        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.isHidden = false
        button.addTarget(self, action: #selector(loadInfo), for: .touchUpInside)
        return button
    }()
    
    let buttonThree: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "reload_icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7.6, left: 7.6, bottom: 7.6, right: 7.6)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.backgroundColor = .clear
        //        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        button.isHidden = false
        return button
    }()
    
    let chatImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return iv
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
        tv.tintColor = .blue
        tv.isUserInteractionEnabled = true
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
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.4)
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.4)
        return view
    }()
    
    let reactionHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        view.layer.cornerRadius = 18
        return view
    }()
    
    let reactionLabel: UILabel = {
        let label = UILabel()
        label.text = "Reactions"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reactionCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08)
        button.setImage(UIImage(named: "reaction_close"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.layer.cornerRadius = 25 / 2
        button.tintColor = UIColor.black
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(closeReactionsPopup), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    let backgroundOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        return view
    }()
    
    let countHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08)
        view.heightAnchor.constraint(equalToConstant: 26).isActive = true
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.layer.cornerRadius = 13
        return view
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "All(0)"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "emoji_message"), for: .normal)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.clipsToBounds = true
        return button
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "send_message"), for: .normal)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
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
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 7.3, left: 7.3, bottom: 7.3, right: 7.3)
        button.clipsToBounds = true
        return button
    }()
    
    let pictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "photo_message"), for: .normal)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 7.7, left: 7.7, bottom: 7.7, right: 7.7)
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(openPhotos), for: .touchUpInside)
        return button
    }()
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "menu_message"), for: .normal)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 7.3, left: 7.3, bottom: 7.3, right: 7.3)
        button.clipsToBounds = true
        return button
    }()
    
    let thumbsUpButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "moneyBag_arrow")?.withRenderingMode(.alwaysOriginal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 7.2, left: 7.2, bottom: 7.2, right: 7.2)
        button.addTarget(self, action: #selector(sendMoneyBag), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    let micButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "mic_message"), for: .normal)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 7.3, left: 7.3, bottom: 7.3, right: 7.3)
        button.clipsToBounds = true
        return button
    }()
    
    let endButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "forward_arrow"), for: .normal)
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        button.addTarget(self, action: #selector(handleAnimationTapped), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        // configuration options
        let iconHeight: CGFloat = 38
        let padding: CGFloat = 6
        
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry")]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            // required for hit testing
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width =  numIcons * iconHeight + (numIcons + 1) * padding
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        // shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackView.frame = containerView.frame
        return containerView
    }()
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return tv
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let expandPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        button.setImage(UIImage(named: ""), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.widthAnchor.constraint(equalToConstant: 45).isActive = true
        button.layer.cornerRadius = 22.5
        button.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 7.7, left: 7.7, bottom: 7.7, right: 7.7)
        button.addTarget(self, action: #selector(sendMoneyBag), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    let popSound = URL(fileURLWithPath: Bundle.main.path(forResource: "popSound", ofType: "mp3")!)
    
    let popSoundDown = URL(fileURLWithPath: Bundle.main.path(forResource: "popSoundDown", ofType: "mp3")!)
    
    let scrollSound = URL(fileURLWithPath: Bundle.main.path(forResource: "scrollSound2", ofType: "mp3")!)
    
    let sendSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sendMessage", ofType: "mp3")!)
    
    var audioPlayer = AVAudioPlayer()
    var audioPlayerTwo = AVAudioPlayer()
    
    var selectedID = String()
    var selectedReaction = String()
    var selectedIndex = IndexPath()
    
    var oldestId = String()
    
//    fileprivate let cellId = "id123"
    fileprivate let cellId = "id1234"
    fileprivate let reactionCellId = "reactionCellId"
    fileprivate let photoCellId = "photoCellId"
    
    var chatMessages = [ChatMessage]()
    
    var chatIds = [[String]]()
    
    var heartReactionsArray = [[String: AnyObject]]()
    var hahaReactionsArray = [[String: AnyObject]]()
    var wowReactionsArray = [[String: AnyObject]]()
    var sadReactionsArray = [[String: AnyObject]]()
    var angryReactionsArray = [[String: AnyObject]]()
    var likeReactionsArray = [[String: AnyObject]]()
    
    var reactionsArray = [[String: AnyObject]]()
    
    var reactionsAmount = String()
    
    var mockReactions = [["name": "Louis Monteiro", "react": "0", "photo": "louis"], ["name": "Roy Taylor", "react": "4", "photo": "roy"], ["name": "Berto Delvanicci", "react": "3", "photo": "berto"], ["name": "Dahmeyon McDonald", "react": "2", "photo": "roy"], ["name": "Louis Monteiro", "react": "5", "photo": "louis"]]
    
    var delegate: ChatMessageCell?
    var reactionsPopUpisOpened: Bool = false
    var isPhotosOpened: Bool = false
    
    var keyboardHeight = CGFloat()
    
    var bottomConstraint: NSLayoutConstraint!
    var photobottomConstraint: NSLayoutConstraint!
    
    var loadedMore: Bool = false
    var isKeyboardAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        let selectedMess: String? = KeychainWrapper.standard.string(forKey: "selectedMessage")
        selectedRoom = selectedMess!
        
        let selectedSess: String? = KeychainWrapper.standard.string(forKey: "ChatSession")
        selectedSession = selectedSess!
        
        let selectedImage: String? = KeychainWrapper.standard.string(forKey: "selectedMessageImage")
        chatImage.image = UIImage(named: selectedImage!)
        
        let selectedRoomName: String? = KeychainWrapper.standard.string(forKey: "selectedMessageRoom")
        navBarTitle.text = selectedRoomName
        
        //check for session id and user id
        
        
        textField.delegate = self
        
        navigationController?.isNavigationBarHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        cellHolder.register(ReactionCell.self, forCellWithReuseIdentifier: reactionCellId)
        
        photosCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: photoCellId)
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.allowsSelection = true

        socket.delegate = self
        socket.connect()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openReactionsPopup), name: Notification.Name("OpenReactionsPopup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadAllReactions), name: Notification.Name("OpenReactionsPopup"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadIt), name: Notification.Name("SelectedNewMessageColor"), object: nil)
        
        
        
        let photoDismissGesture = UITapGestureRecognizer(target: self, action: #selector(closePhotosView))
        let keyDismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(keyDismissGesture)
        
        if isPhotosOpened == true {
            view.addGestureRecognizer(photoDismissGesture)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMenu), name: Notification.Name("SelectedNewMessageColor"), object: nil)

        reloadMenu()
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(closeReactionsPopup))
        backgroundOverlay.addGestureRecognizer(dismissGesture)
        
        setupLongPressGesture()
        setupViews()
        
        getImages()
        
    }
    
    @objc func goBackTapped() {
        navigationController?.popViewController(animated: true)
        selectedRoomID.removeAll()
        KeychainWrapper.standard.removeObject(forKey: "selectedMessage")
        KeychainWrapper.standard.removeObject(forKey: "selectedMessageImage")
        KeychainWrapper.standard.removeObject(forKey: "selectedMessageRoom")
    }
    
    func checkForID() {
        
        if UserDefaults.standard.string(forKey: "ChatSession") == "" {
            // start anmation and fetch session id
            fetchSession()
        }else{
            if UserDefaults.standard.string(forKey: "selectedUserId") == "" {
                // start anmation and fetch user id
                
            }else{
                
            }
        }
    }
    
    func fetchSession() {
        let myUrl = URL(string: "http://api.lionsofforex.com/chat/session")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        //        let accessText = accessToken
        if accessToken != nil {
            let postString = ["email": accessToken] as! [String: String]
            // send http request to perform sign in
            
            Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    // to get json return value
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        //                        print(json)
                        if let userId = json.value(forKey: "success") as? String {
                            KeychainWrapper.standard.set(userId, forKey: "ChatSession")
                            
                            // Dismiss animation
                        }
                    }
            }
        }else{
            return
        }
    }
    
    func fetchUserId() {
        DispatchQueue.main.async {
            let myUrl = URL(string: "https://api.lionsofforex.com/myaccount/user")
            let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
            let accessText = accessToken
            if accessText != nil {
                let postString = [ "email": accessText] as! [String: String]
                // send http request to perform sign in
                
                Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        print(response)
                        // to get json return value
                        if let result = response.result.value {
                            if let json = result as? NSDictionary {
                                if let userId = json.object(forKey: "success") as? NSDictionary {
                                    if let id = userId.object(forKey: "id") as? String {
                                        KeychainWrapper.standard.set(id, forKey: "selectedUserId")
                                    }else{
                                        return
                                    }
                                }
                                
                                if let errorId = json.value(forKey: "error") {
                                    if let errorURL = errorId as? String {
                                        print(errorURL)
                                    }else{
                                        return
                                    }
                                }
                            }
                        }
                }
            }else{
                return
            }
        }
    }
    
    @objc func loadAllReactions() {
        // MARK: CLEAR ALL
        heartReactionsArray.removeAll()
        hahaReactionsArray.removeAll()
        wowReactionsArray.removeAll()
        sadReactionsArray.removeAll()
        angryReactionsArray.removeAll()
        likeReactionsArray.removeAll()
        
        if selectedReaction != "" {
            let parsedJSON = selectedReaction
            let reactions = parsedJSON
            if let reactionData = reactions.data(using: .utf8) {
                let reactionjsonData = try? JSONSerialization.jsonObject(with: reactionData, options: .allowFragments)
                
                if let reactjsonData = reactionjsonData {
                    let reactionjsonDict = JSON(reactjsonData)
                    
                    
                    
                    if let reactionsinnerJson = reactionjsonDict.array {
                        //                                                                print(reactionsinnerJson[2])
                        
                        if let heart = reactionsinnerJson[0].arrayObject {
                            if heart.count > 0 {
                                for results in heart {
                                    if let active = results as? NSDictionary {
                                        let name = active.value(forKey: "name")
                                        let photo = active.value(forKey: "photo")
                                        let postString = ["name": name, "photo": photo] as [String: AnyObject]
                                        
                                        heartReactionsArray.append(postString)
                                    }
                                }
                            }
                            if let haha = reactionsinnerJson[1].arrayObject {
                                if haha.count > 0 {
                                    for results in haha {
                                        if let active = results as? NSDictionary {
                                            let name = active.value(forKey: "name")
                                            let photo = active.value(forKey: "photo")
                                            let postString = ["name": name, "photo": photo] as [String: AnyObject]
                                            
                                            hahaReactionsArray.append(postString)
                                        }
                                    }
                                }
                                if let wow = reactionsinnerJson[2].arrayObject {
                                    if wow.count > 0 {
                                        for results in wow {
                                            if let active = results as? NSDictionary {
                                                let name = active.value(forKey: "name")
                                                let photo = active.value(forKey: "photo")
                                                let postString = ["name": name, "photo": photo] as [String: AnyObject]
                                                
                                                wowReactionsArray.append(postString)
                                            }
                                        }
                                    }
                                    if let sad = reactionsinnerJson[3].arrayObject {
                                        if sad.count > 0 {
                                            for results in sad {
                                                if let active = results as? NSDictionary {
                                                    let name = active.value(forKey: "name")
                                                    let photo = active.value(forKey: "photo")
                                                    let postString = ["name": name, "photo": photo] as [String: AnyObject]
                                                    
                                                    sadReactionsArray.append(postString)
                                                }
                                            }
                                        }
                                        if let angry = reactionsinnerJson[4].arrayObject {
                                            if angry.count > 0 {
                                                for results in angry {
                                                    if let active = results as? NSDictionary {
                                                        let name = active.value(forKey: "name")
                                                        let photo = active.value(forKey: "photo")
                                                        let postString = ["name": name, "photo": photo] as [String: AnyObject]
                                                        
                                                        angryReactionsArray.append(postString)
                                                    }
                                                }
                                            }
                                            if let like = reactionsinnerJson[5].arrayObject {
                                                if like.count > 0 {
                                                    for results in like {
                                                        if let active = results as? NSDictionary {
                                                            let name = active.value(forKey: "name")
                                                            let photo = active.value(forKey: "photo")
                                                            let postString = ["name": name, "photo": photo] as [String: AnyObject]
                                                            
                                                            likeReactionsArray.append(postString)
                                                        }
                                                    }
                                                }
                                                
                                                if heart.count + haha.count + wow.count + sad.count + angry.count + like.count > 0 {
                                                    
                                                    
                                                    self.reactionsAmount = String(heart.count + haha.count + wow.count + sad.count + angry.count + like.count)
                                                    
                                                    print("you have reactions to show")
                                                    
                                                    // MARK Append message
                                                    cellHolder.reloadData()
                                                    
                                                    
                                                }else{
                                                    
                                                    print("no reactions")
                                                    cellHolder.reloadData()
                                                    
                                                    // MARK Append message
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if self.chatMessages.count > 0 {
                // mark
            }
        }else{
            print("no message id focused")
        }
    }
    
    
    
    @objc func reloadMenu() {
        if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "" {
            self.micButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.menuButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.cameraButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.pictureButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.micButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.emojiButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.thumbsUpButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.sendButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.endButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Blue" {
            self.micButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.menuButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.cameraButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.pictureButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.micButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.emojiButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.thumbsUpButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.sendButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.endButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Red" {
            self.micButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
            self.menuButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
            self.cameraButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
            self.pictureButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
            self.micButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
            self.emojiButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
            self.thumbsUpButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
            self.sendButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
            self.endButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
        }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Purple" {
            self.micButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
            self.menuButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
            self.cameraButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
            self.pictureButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
            self.micButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
            self.emojiButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
            self.thumbsUpButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
            self.sendButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
            self.endButton.tintColor = UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
        }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Green" {
            self.micButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
            self.menuButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
            self.cameraButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
            self.pictureButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
            self.micButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
            self.emojiButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
            self.thumbsUpButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
            self.sendButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
            self.endButton.tintColor = UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
        }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Pink" {
            self.micButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
            self.menuButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
            self.cameraButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
            self.pictureButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
            self.micButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
            self.emojiButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
            self.thumbsUpButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
            self.sendButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
            self.endButton.tintColor = UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
        }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Orange" {
            self.micButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
            self.menuButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
            self.cameraButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
            self.pictureButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
            self.micButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
            self.emojiButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
            self.thumbsUpButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
            self.sendButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
            self.endButton.tintColor = UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
        }else{
            self.micButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.menuButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.cameraButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.pictureButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.micButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.emojiButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.thumbsUpButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.sendButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
            self.endButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
        }
    }
    
    @objc func reloadIt() {
        tableView.reloadData()
    }
    
    @objc func loadInfo() {
        let vc = MessageInfoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getImages() {
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects({ (object, count, stop) in
            // self.cameraAssets.add(object)
            self.images.append(object)
        })
        
        //In order to get latest image first, we just reverse the array
        self.images.reverse()
        
        // To show photos, I have taken a UICollectionView
        self.photosCollectionView.reloadData()
    }
    
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
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.tableView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomView.frame.height)
            self.textFieldHolder.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomView.frame.height)
            
            self.keyboardHeight = keyboardSize.height
            
//            let item = self.collectionView(self.cellHolder, numberOfItemsInSection: 0) - 1
//            let lastItemIndex = IndexPath(item: item, section: 0)
//            self.cellHolder.scrollToItem(at: lastItemIndex, at: .top, animated: true)
            
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
//            self.textFieldHolder.frame.origin.y += keyboardSize.height
//            self.tableView.frame.origin.y += keyboardSize.height
            
            self.tableView.transform = CGAffineTransform(translationX: 0, y: 0)
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
    
    @objc func goBack() {
        print("go back tapped")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupViews() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectTwo = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        let blurEffectViewTwo = UIVisualEffectView(effect: blurEffectTwo)
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectViewTwo.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(navBarTitle)
        stackViewOne.addArrangedSubview(navBarSubtitle)
        stackViewOne.axis = .vertical
        stackViewOne.spacing = 0
        stackViewOne.alignment = .leading
        
        let stackViewTwo = UIStackView()
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        stackViewTwo.addArrangedSubview(chatImage)
        stackViewTwo.addArrangedSubview(stackViewOne)
        stackViewTwo.axis = .horizontal
        stackViewTwo.spacing = 10
        stackViewTwo.alignment = .center
        
        view.addSubview(tableView)
        view.addSubview(textFieldHolder)
        view.addSubview(bottomView)
        textFieldHolder.addSubview(blurEffectView)
        bottomView.addSubview(blurEffectViewTwo)
        view.addSubview(photosCollectionView)
        
        textFieldHolder.addSubview(textField)

        textFieldHolder.addSubview(thumbsUpButton)
        textFieldHolder.addSubview(sendButton)
        textFieldHolder.addSubview(menuButton)
        textFieldHolder.addSubview(cameraButton)
        textFieldHolder.addSubview(pictureButton)
        textFieldHolder.addSubview(micButton)
        textFieldHolder.addSubview(emojiButton)
        
        view.addSubview(expandPhotoButton)
        
        view.addSubview(menuBar)
        view.addSubview(menuTop)
        menuBar.addSubview(backButton)
//        menuBar.addSubview(navBarTitle)
        menuBar.addSubview(stackViewTwo)
        menuBar.addSubview(buttonTwo)
        menuBar.addSubview(buttonThree)
        
        //        sendButton.layer.cornerRadius = chatImage.frame.height / 2
        //        sendButton.layoutIfNeeded()
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
//            tableView.bottomAnchor.constraint(equalTo: textFieldHolder.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: textFieldHolder.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textFieldHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textFieldHolder.heightAnchor.constraint(equalToConstant: 60),
            
            textFieldHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: textFieldHolder.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: textFieldHolder.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: textFieldHolder.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: textFieldHolder.trailingAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            thumbsUpButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            thumbsUpButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            thumbsUpButton.trailingAnchor.constraint(equalTo: textFieldHolder.trailingAnchor, constant: -10),
            thumbsUpButton.widthAnchor.constraint(equalTo: thumbsUpButton.heightAnchor),
//
            sendButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            sendButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: textFieldHolder.trailingAnchor, constant: -10),
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),

            // MARK SETUP BOTTOM BUTTONS

            menuButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            menuButton.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            menuButton.leadingAnchor.constraint(equalTo: textFieldHolder.leadingAnchor, constant: 7),
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

            textField.centerYAnchor.constraint(equalTo: textFieldHolder.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: micButton.trailingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: thumbsUpButton.leadingAnchor, constant: -5),
            
            photosCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
//            photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            expandPhotoButton.bottomAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: -15),
            expandPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
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
            
            stackViewTwo.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            stackViewTwo.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 0),
//            stackViewTwo.trailingAnchor.constraint(equalTo: buttonTwo.leadingAnchor, constant: -10),
            
//            navBarTitle.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
//            navBarTitle.leadingAnchor.constraint(equalTo: chatImage.trailingAnchor, constant: 5),
//            navBarTitle.trailingAnchor.constraint(equalTo: buttonTwo.leadingAnchor, constant: -10),
            
            buttonTwo.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor, constant: 0),
            buttonTwo.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -5),
            
            buttonThree.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor, constant: 0),
            buttonThree.trailingAnchor.constraint(equalTo: buttonTwo.leadingAnchor, constant: -5),
            ])
        
        let con = view.frame.height / 0.35
        
        bottomConstraint = textFieldHolder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        photobottomConstraint = photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: con)
//        photobottomConstraint.constant += con
        
        
        bottomConstraint.isActive = true
        photobottomConstraint.isActive = true
        
        blurEffectView.frame = textFieldHolder.bounds
        blurEffectViewTwo.frame = bottomView.bounds
        
        
//        self.photosCollectionView.transform = CGAffineTransform(translationX: 0, y: photosCollectionView.frame.height)
//        self.textFieldHolder.transform = CGAffineTransform(translationX: 0, y: photosCollectionView.frame.height)
//        self.textFieldHolder.layoutIfNeeded()
//        self.tableView.layoutIfNeeded()
//        self.photosCollectionView.isHidden = true
        
        
        self.sendButton.isHidden = true
        
//        DispatchQueue.main.async {
//            self.photosCollectionView.frame.origin.y -= (self.photosCollectionView.frame.height + self.view.safeAreaInsets.bottom)
//        }
    }
    
    @objc func closeReactionsPopup() {
        if reactionsPopUpisOpened == true {
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                self.reactionHolder.transform = CGAffineTransform(translationX: 0, y: 1000)
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundOverlay.alpha = 0
                }, completion: { (_) in
                    // MARK:
                    self.reactionsPopUpisOpened = false
                    self.heartReactionsArray.removeAll()
                    self.hahaReactionsArray.removeAll()
                    self.wowReactionsArray.removeAll()
                    self.sadReactionsArray.removeAll()
                    self.angryReactionsArray.removeAll()
                    self.likeReactionsArray.removeAll()
                    self.cellHolder.reloadData()
                    self.selectedReaction = ""
                })
            }) { (_) in
                // MARK:
            }
        }
    }
    
    @objc func openPhotos() {
        if isPhotosOpened == false {
            
            
            let con = view.frame.height / 0.35
            self.bottomConstraint.constant -= (self.photosCollectionView.frame.height)
            self.photobottomConstraint.constant -= con
            UIView.animate(withDuration: 0, animations: {
                self.textFieldHolder.layoutIfNeeded()
                self.photosCollectionView.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
                
                self.menuButton.isUserInteractionEnabled = false
                self.cameraButton.isUserInteractionEnabled = false
                self.micButton.isUserInteractionEnabled = false
                
                self.menuButton.tintColor = .lightGray
                self.cameraButton.tintColor = .lightGray
                self.micButton.tintColor = .lightGray
                
            }) { (_) in
                self.isPhotosOpened = true
            }
        }else{
            let con = view.frame.height / 0.35
            self.bottomConstraint.constant += (self.photosCollectionView.frame.height)
            self.photobottomConstraint.constant += con
            UIView.animate(withDuration: 0, animations: {
                self.textFieldHolder.layoutIfNeeded()
                self.photosCollectionView.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
                
                self.menuButton.isUserInteractionEnabled = true
                self.cameraButton.isUserInteractionEnabled = true
                self.micButton.isUserInteractionEnabled = true
                
                self.menuButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
                self.cameraButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
                self.micButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
                
            }) { (_) in
                self.isPhotosOpened = false
            }
        }
    }
    
    @objc func closePhotosView() {
        if isPhotosOpened == true {
            let con = view.frame.height / 0.35
            self.bottomConstraint.constant += (self.photosCollectionView.frame.height)
            self.photobottomConstraint.constant += con
            UIView.animate(withDuration: 0, animations: {
                self.textFieldHolder.layoutIfNeeded()
                self.photosCollectionView.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
                
                self.menuButton.isUserInteractionEnabled = true
                self.cameraButton.isUserInteractionEnabled = true
                self.micButton.isUserInteractionEnabled = true
                
                self.menuButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
                self.cameraButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
                self.micButton.tintColor = UIColor.init(red: 0/255, green: 131/255, blue: 230/255, alpha: 1)
                
            }) { (_) in
                self.isPhotosOpened = false
            }
        }
    }
    
    @objc func openReactionsPopup() {
        if reactionsPopUpisOpened == false {
            let stackViewOne = UIStackView()
            stackViewOne.addArrangedSubview(reactionLabel)
            stackViewOne.addArrangedSubview(reactionCloseButton)
            stackViewOne.translatesAutoresizingMaskIntoConstraints = false
            stackViewOne.alignment = .leading
            stackViewOne.axis = .horizontal
            
            view.addSubview(backgroundOverlay)
            view.addSubview(reactionHolder)
            
            reactionHolder.addSubview(stackViewOne)
            reactionHolder.addSubview(cellHolder)
            reactionHolder.addSubview(countHolder)
            countHolder.addSubview(countLabel)
            
            NSLayoutConstraint.activate([
                backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                reactionHolder.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
                reactionHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
                reactionHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                reactionHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                
                stackViewOne.topAnchor.constraint(equalTo: reactionHolder.topAnchor, constant: 15),
                stackViewOne.leadingAnchor.constraint(equalTo: reactionHolder.leadingAnchor, constant: 20),
                stackViewOne.trailingAnchor.constraint(equalTo: reactionHolder.trailingAnchor, constant: -20),
                
                cellHolder.topAnchor.constraint(equalTo: stackViewOne.bottomAnchor, constant: 18),
                cellHolder.bottomAnchor.constraint(equalTo: reactionHolder.bottomAnchor, constant: 0),
                cellHolder.leadingAnchor.constraint(equalTo: reactionHolder.leadingAnchor, constant: 0),
                cellHolder.trailingAnchor.constraint(equalTo: reactionHolder.trailingAnchor, constant: 0),
                
                countHolder.bottomAnchor.constraint(equalTo: reactionHolder.bottomAnchor, constant: -13),
                countHolder.centerXAnchor.constraint(equalTo: reactionHolder.centerXAnchor),
                
                countLabel.topAnchor.constraint(equalTo: countHolder.topAnchor, constant: 0),
                countLabel.bottomAnchor.constraint(equalTo: countHolder.bottomAnchor, constant: 0),
                countLabel.leadingAnchor.constraint(equalTo: countHolder.leadingAnchor, constant: 0),
                countLabel.trailingAnchor.constraint(equalTo: countHolder.trailingAnchor, constant: 0),
                
                ])
            
            let amount = String(mockReactions.count)
            countLabel.text = "All(\(amount))"
            
            reactionHolder.transform = CGAffineTransform(translationX: 0, y: 1000)
            backgroundOverlay.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                self.backgroundOverlay.alpha = 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.reactionHolder.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: { (_) in
                    // MARK:
                    self.reactionsPopUpisOpened = true
                })
            }) { (_) in
                // MARK:
            }
        }
    }
    
    fileprivate func setupLongPressGesture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            handleGestureEnd(gesture: gesture)
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureEnd(gesture: UIGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconsContainerView)
        
        // clean up the animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let stackView = self.iconsContainerView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            
            self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
            self.iconsContainerView.alpha = 0
            
            
        }, completion: { (_) in
            self.iconsContainerView.removeFromSuperview()
        })
        
        if pressedLocation.x >= -1000 && pressedLocation.x <= 50 {
//            print("like")
            handleLike()
        }
        if pressedLocation.x >= 51 && pressedLocation.x <= 89 {
//            print("heart")
            handleHeart()
        }
        if pressedLocation.x >= 95 && pressedLocation.x <= 132 {
//            print("wow")
            handleWow()
        }
        if pressedLocation.x >= 137 && pressedLocation.x <= 175 {
//            print("haha")
            handleHaha()
        }
        if pressedLocation.x >= 177 && pressedLocation.x <= 220 {
//            print("sad")
            handleSad()
        }
        if pressedLocation.x >= 225 && pressedLocation.x <= 1000 {
//            print("angry")
            handleAngry()
        }
    }
    
    @objc func handleThumbsUp() {
        chatMessages.append(ChatMessage(id: "193", text: "💰", sender: "self", senderId: "15", isIncoming: false, isReaction: false, heart: false, haha: false, wow: false, sad: false, angry: false, like: false, date: Date.dateFromCustomString(customString: "06/15/2019"), photo: "self", reactions: ""))
        tableView.reloadData()
//        if chatMessages.count > 0 {
//            tableView.scrollToRow(at: IndexPath(item:chatMessages.count-1, section: 0), at: .bottom, animated: true)
//        }
    }
    
    func handleLike() {
        print("liking message: \(selectedID)")
        if selectedID != "" {
            print("liking message: \(selectedID)")
        }
    }
    
    func handleHeart() {
        if selectedID != "" {
            print("heart reacting to message: \(selectedID)")
            let indexPath = selectedIndex
            let url = URL(string: "http://api.lionsofforex.com/chat/react")
            let poststring = ["session": selectedSession, "message_id": selectedID, "react": "0"]
            
            Alamofire.request(url!, method: .post, parameters: poststring, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    // to get json return value
                    if let result = response.result.value {
                        if let json = result as? NSDictionary {
                            if let userId = json.value(forKey: "success") as? String {
                                print("reacted to \(self.selectedID) with hearts")
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                                print(userId)
                            }else{
                                print("error reacting to message: \(self.selectedID)")
                            }
                        }
                    }
            }
        }
    }
    
    func handleWow() {
        if selectedID != "" {
            print("wow reacting to message: \(selectedID)")
            let indexPath = selectedIndex
            let url = URL(string: "http://api.lionsofforex.com/chat/react")
            let poststring = ["session": selectedSession, "message_id": selectedID, "react": "2"]
            
            Alamofire.request(url!, method: .post, parameters: poststring, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    // to get json return value
                    if let result = response.result.value {
                        if let json = result as? NSDictionary {
                            if let userId = json.value(forKey: "success") as? String {
                                print("reacted to \(self.selectedID) with wow")
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                                print(userId)
                            }else{
                                print("error reacting to message: \(self.selectedID)")
                            }
                        }
                    }
            }
        }
    }
    
    func handleHaha() {
        if selectedID != "" {
            print("haha reacting to message: \(selectedID)")
            let indexPath = selectedIndex
            let url = URL(string: "http://api.lionsofforex.com/chat/react")
            let poststring = ["session": selectedSession, "message_id": selectedID, "react": "1"]
            
            Alamofire.request(url!, method: .post, parameters: poststring, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    // to get json return value
                    if let result = response.result.value {
                        if let json = result as? NSDictionary {
                            if let userId = json.value(forKey: "success") as? String {
                                print("reacted to \(self.selectedID) with haha")
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                                print(userId)
                            }else{
                                print("error reacting to message: \(self.selectedID)")
                            }
                        }
                    }
            }
        }
    }
    
    func handleSad() {
        if selectedID != "" {
            print("sad reacting to message: \(selectedID)")
            let indexPath = selectedIndex
            let url = URL(string: "http://api.lionsofforex.com/chat/react")
            let poststring = ["session": selectedSession, "message_id": selectedID, "react": "3"]
            
            Alamofire.request(url!, method: .post, parameters: poststring, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    // to get json return value
                    if let result = response.result.value {
                        if let json = result as? NSDictionary {
                            if let userId = json.value(forKey: "success") as? String {
                                print("reacted to \(self.selectedID) with sad")
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                                print(userId)
                            }else{
                                print("error reacting to message: \(self.selectedID)")
                            }
                        }
                    }
            }
        }
    }
    
    func handleAngry() {
        if selectedID != "" {
            print("angry reacting to message: \(selectedID)")
            let indexPath = selectedIndex
            let url = URL(string: "http://api.lionsofforex.com/chat/react")
            let poststring = ["session": selectedSession, "message_id": selectedID, "react": "4"]
            
            Alamofire.request(url!, method: .post, parameters: poststring, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    // to get json return value
                    if let result = response.result.value {
                        if let json = result as? NSDictionary {
                            if let userId = json.value(forKey: "success") as? String {
                                print("reacted to \(self.selectedID) with angry")
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                                print(userId)
                            }else{
                                print("error reacting to message: \(self.selectedID)")
                            }
                        }
                    }
            }
        }
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconsContainerView)
        print(pressedLocation.x)
        
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height / 2)
        
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
                do {
                    self.audioPlayerTwo = try AVAudioPlayer(contentsOf: self.scrollSound)
                    self.audioPlayerTwo.play()
                } catch {
                    // couldn't load file :(
                }
                
            })
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconsContainerView)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: popSound)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
        }
        
        let pressedLocation = gesture.location(in: self.view)
        print(pressedLocation.x)
        
        // transformation of the red box
        let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        iconsContainerView.alpha = 0
        self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
        })

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if chatMessages.count < 0 {
            return 0
        }else{
            return 1
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView {
            // UITableView only moves in one direction, y axis
            let currentOffset = scrollView.contentOffset.y
            print(currentOffset)
            if currentOffset <= -40 {
                self.loadMore()
                
            }
        }else if scrollView == cellHolder {
            print("scrolled")
        }else{
//            if isPhotosOpened == true {
//                self.textFieldHolder.frame.origin.y -= (self.photosCollectionView.frame.height)
//                self.tableView.frame.origin.y -= (self.photosCollectionView.frame.height)
//                self.photosCollectionView.frame.origin.y += (self.photosCollectionView.frame.height + self.view.safeAreaInsets.bottom)
//            }else{
//                self.textFieldHolder.frame.origin.y += (self.photosCollectionView.frame.height)
//                self.tableView.frame.origin.y += (self.photosCollectionView.frame.height)
//                self.photosCollectionView.frame.origin.y -= (self.photosCollectionView.frame.height + self.view.safeAreaInsets.bottom)
//            }
        }
        
    }
    
    func loadMore() {
        if loadedMore == false {
            if oldestId == "" {
                
            }else{
                print("loading more..................")
                guard let myUserId = KeychainWrapper.standard.string(forKey: "selectedUserId") else { return }
                let url = URL(string: "http://api.lionsofforex.com/chat/history")
                let poststring = ["session": selectedSession, "older": oldestId]
                
                Alamofire.request(url!, method: .post, parameters: poststring, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        //                print(response)
                        // to get json return value
                        if let result = response.result.value {
                            
                            if let json = result as? NSDictionary {
                                //                            print(json)
                                if let userId = json.value(forKey: "success") {
                                    //                                print(userId)
                                    //                            self.tableView.reloadRows(at: [indexPath], with: .none)
                                    let parsedText = JSON(userId)
                                    let string = parsedText.description
                                    let data = string.data(using: .utf8)!
                                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                                    
                                    if let jsonData = jsonData {
                                        let jsonDict = JSON(jsonData)
                                        
                                        // ******************** HERES MY REFETCH LOGIC *******************
                                        
                                        if let innerJson = jsonDict.array {
                                            if let last = innerJson.last?.dictionary {
                                                if let messageId = last["message_id"]?.description {
                                                    print("last message id is: \(messageId)")
                                                    self.oldestId = messageId
                                                    self.lastId = messageId
                                                }
                                            }
                                            if let first = innerJson.first?.dictionary {
                                                if let messageId = first["message_id"]?.description {
                                                    print("first message id is: \(messageId)")
//                                                    self.firstId = messageId
                                                    
                                                }
                                            }
                                        }
                                        
                                        if let innerJson = jsonDict.array {
                                            
                                            for results in innerJson {
                                                if let active = results.dictionary {
                                                    let fingerprint = active["fingerprint"]
                                                    let message = active["message"]
                                                    let messageid = active["message_id"]
                                                    let name = active["name"]
                                                    let timestamp = active["timestamp"]
                                                    let photo = active["photo"]
                                                    guard let reactions = active["reactions"]?.description else { return }
                                                    //                        print(active as [String: AnyObject])
                                                    
                                                    print("reactions description is : \(reactions)")
                                                    if let fingerprintStr:String = fingerprint?.description {
                                                        if let messageStr:String = message?.description {
                                                            if let messageidStr:String = messageid?.description {
                                                                if let nameStr:String = name?.description {
                                                                    if let timestampStr:String = timestamp?.description {
                                                                        guard let innerDate = TimeInterval(timestampStr) else { return  }
                                                                        if let photoStr:String = photo?.description {
                                                                            if fingerprintStr == myUserId {
                                                                                
                                                                                if let reactionData = reactions.data(using: .utf8) {
                                                                                    let reactionjsonData = try? JSONSerialization.jsonObject(with: reactionData, options: .allowFragments)
                                                                                    
                                                                                    //                                                                                print("reactionData is: \(reactionData)")
                                                                                    //                                                                                print("reactionJsonData is: \(reactionjsonData)")
                                                                                    
                                                                                    if let reactjsonData = reactionjsonData {
                                                                                        let reactionjsonDict = JSON(reactjsonData)
                                                                                        
                                                                                        var isHearted = Bool()
                                                                                        var isHaha = Bool()
                                                                                        var isWow = Bool()
                                                                                        var isSad = Bool()
                                                                                        var isAngry = Bool()
                                                                                        var islike = Bool()
                                                                                        var isReaction = Bool()
                                                                                        let incoming = false
                                                                                        
                                                                                        if let reactionsinnerJson = reactionjsonDict.array {
                                                                                            //                                                                                        print("reactionsinnerJson is: \(reactionsinnerJson)")
                                                                                            
                                                                                            if let heart = reactionsinnerJson[0].arrayObject {
                                                                                                if heart.count > 0 {
                                                                                                    isHearted = true
                                                                                                }
                                                                                                if let haha = reactionsinnerJson[1].arrayObject {
                                                                                                    if haha.count > 0 {
                                                                                                        isHaha = true
                                                                                                    }
                                                                                                    if let wow = reactionsinnerJson[2].arrayObject {
                                                                                                        if wow.count > 0 {
                                                                                                            isWow = true
                                                                                                        }
                                                                                                        if let sad = reactionsinnerJson[3].arrayObject {
                                                                                                            if sad.count > 0 {
                                                                                                                isSad = true
                                                                                                            }
                                                                                                            if let angry = reactionsinnerJson[4].arrayObject {
                                                                                                                if angry.count > 0 {
                                                                                                                    isAngry = true
                                                                                                                }
                                                                                                                if let like = reactionsinnerJson[5].arrayObject {
                                                                                                                    if like.count > 0 {
                                                                                                                        islike = true
                                                                                                                    }
                                                                                                                    
                                                                                                                    if heart.count + haha.count + wow.count + sad.count + angry.count + like.count > 0 {
                                                                                                                        
                                                                                                                        isReaction = true
                                                                                                                        print("you have reactions")
                                                                                                                        
                                                                                                                        // MARK Append message
                                                                                                                        let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: isReaction, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions)
                                                                                                                        
                                                                                                                        self.chatMessages.insert(newMessage, at: 0)
                                                                                                                        self.chatIds.insert([messageidStr], at: 0)
                                                                                                                        
                                                                                                                    }else{
                                                                                                                        
                                                                                                                        isReaction = false
                                                                                                                        print("no reactions")
                                                                                                                        
                                                                                                                        // MARK Append message
                                                                                                                        let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: isReaction, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions)
                                                                                                                        
                                                                                                                        self.chatMessages.insert(newMessage, at: 0)
                                                                                                                        self.chatIds.insert([messageidStr], at: 0)
                                                                                                                    }
                                                                                                                    
                                                                                                                    print("like: \(like)")
                                                                                                                }
                                                                                                                print("angry: \(angry)")
                                                                                                            }
                                                                                                            print("sad: \(sad)")
                                                                                                        }
                                                                                                        print("wow: \(wow)")
                                                                                                    }
                                                                                                    print("haha: \(haha)")
                                                                                                }
                                                                                                print("heart: \(heart)")
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                                if self.chatMessages.count > 0 {
                                                                                    self.tableView.reloadData()
                                                                                }
                                                                                
                                                                            }else{
                                                                                
                                                                                if let reactionData = reactions.data(using: .utf8) {
                                                                                    let reactionjsonData = try? JSONSerialization.jsonObject(with: reactionData, options: .allowFragments)
                                                                                    
                                                                                    //                                                                                print("incoming reactionDATA is :\(reactionjsonData)")
                                                                                    
                                                                                    if let reactjsonData = reactionjsonData {
                                                                                        let reactionjsonDict = JSON(reactjsonData)
                                                                                        
                                                                                        //                                                            print(reactionjsonDict.description)
                                                                                        var isHearted = Bool()
                                                                                        var isHaha = Bool()
                                                                                        var isWow = Bool()
                                                                                        var isSad = Bool()
                                                                                        var isAngry = Bool()
                                                                                        var islike = Bool()
                                                                                        var isReaction = Bool()
                                                                                        let incoming = true
                                                                                        
                                                                                        if let reactionsinnerJson = reactionjsonDict.array {
                                                                                            
                                                                                            //                                                                                        print("incoming reactionsinnerJson is :\(reactionsinnerJson)")
                                                                                            
                                                                                            if let heart = reactionsinnerJson[0].arrayObject {
                                                                                                if heart.count > 0 {
                                                                                                    isHearted = true
                                                                                                }
                                                                                                if let haha = reactionsinnerJson[1].arrayObject {
                                                                                                    if haha.count > 0 {
                                                                                                        isHaha = true
                                                                                                    }
                                                                                                    if let wow = reactionsinnerJson[2].arrayObject {
                                                                                                        if wow.count > 0 {
                                                                                                            isWow = true
                                                                                                        }
                                                                                                        if let sad = reactionsinnerJson[3].arrayObject {
                                                                                                            if sad.count > 0 {
                                                                                                                isSad = true
                                                                                                            }
                                                                                                            if let angry = reactionsinnerJson[4].arrayObject {
                                                                                                                if angry.count > 0 {
                                                                                                                    isAngry = true
                                                                                                                }
                                                                                                                if let like = reactionsinnerJson[5].arrayObject {
                                                                                                                    if like.count > 0 {
                                                                                                                        islike = true
                                                                                                                    }
                                                                                                                    
                                                                                                                    if heart.count + haha.count + wow.count + sad.count + angry.count + like.count > 0 {
                                                                                                                        
                                                                                                                        isReaction = true
                                                                                                                        print("you have reactions")
                                                                                                                        
                                                                                                                        // MARK Append message
                                                                                                                        let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: isReaction, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions)
                                                                                                                        
                                                                                                                        self.chatMessages.insert(newMessage, at: 0)
                                                                                                                        self.chatIds.insert([messageidStr], at: 0)
                                                                                                                        
                                                                                                                    }else{
                                                                                                                        
                                                                                                                        isReaction = false
                                                                                                                        print("no reactions")
                                                                                                                        
                                                                                                                        // MARK Append message
                                                                                                                        let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: isReaction, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions)
                                                                                                                        
                                                                                                                        self.chatMessages.insert(newMessage, at: 0)
                                                                                                                        self.chatIds.insert([messageidStr], at: 0)
                                                                                                                    }
                                                                                                                    print("like: \(like)")
                                                                                                                }
                                                                                                                print("angry: \(angry)")
                                                                                                            }
                                                                                                            print("sad: \(sad)")
                                                                                                        }
                                                                                                        print("wow: \(wow)")
                                                                                                    }
                                                                                                    print("haha: \(haha)")
                                                                                                }
                                                                                                print("heart: \(heart)")
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                                if self.chatMessages.count > 0 {
                                                                                    self.tableView.reloadData()
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                self.loadedMore = false
                                            }
                                        }
                                    }else{
                                        print("oops something went wrong")
                                    }
                                }else{
                                    print("error fetching")
                                }
                            }
                        }
                }
            }
        }else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let firstMessageInSection = chatMessages.first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: firstMessageInSection.date)
            
            let label = DateHeaderLabel()
            label.text = dateString
            
            let containerView = UIView()
            
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
            
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chatMessages.count < 0 {
            return 0
        }else{
            return chatMessages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let chatMessage = chatMessages[indexPath.row]
        cell.youtuber = chatMessage.reactions
        
        cell.delegate = self
        
        cell.profileImage.image = UIImage(named: chatMessage.photo)
        
        let photourl: URL = URL(string: chatMessage.photo)!
        
        cell.profileImage.setImageWith(photourl, placeholderImage: UIImage(named: "ici-avatar"))
        
        if chatMessage.isIncoming == false {
            cell.seenImage.image = UIImage(named: "delivered2")
            
            if chatMessage.text == "💰" {
                cell.messageLabel.text = "\n \n"
                cell.moneybagImage.isHidden = false
            }else{
                cell.moneybagImage.isHidden = true
            }
            
            if chatMessage.isReaction == true {
                if chatMessage.wow || chatMessage.sad == true {
                    cell.reactionImageTwo.image = UIImage(named: "wowsad")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.wow || chatMessage.angry == true {
                    cell.reactionImageTwo.image = UIImage(named: "wowangry")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.wow || chatMessage.haha == true {
                    cell.reactionImageTwo.image = UIImage(named: "wowhaha")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.wow || chatMessage.like == true {
                    cell.reactionImageTwo.image = UIImage(named: "wowlike")
                    cell.reactionImageTwo.alpha = 1
                }
                
                if chatMessage.sad || chatMessage.angry == true {
                    cell.reactionImageTwo.image = UIImage(named: "sadangry")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.sad || chatMessage.haha == true {
                    cell.reactionImageTwo.image = UIImage(named: "sadhaha")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.sad || chatMessage.like == true {
                    cell.reactionImageTwo.image = UIImage(named: "sadlike")
                    cell.reactionImageTwo.alpha = 1
                }
                
                if chatMessage.angry || chatMessage.haha == true {
                    cell.reactionImageTwo.image = UIImage(named: "angryhaha")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.angry || chatMessage.like == true {
                    cell.reactionImageTwo.image = UIImage(named: "angrylike")
                    cell.reactionImageTwo.alpha = 1
                }
                
                if chatMessage.haha || chatMessage.like == true {
                    cell.reactionImageTwo.image = UIImage(named: "hahalike")
                    cell.reactionImageTwo.alpha = 1
                }
                
                // ONE REACTION
                
                if chatMessage.heart == true {
                    cell.reactionImageTwo.image = UIImage(named: "loveHolder")
                    
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.haha == true {
                    cell.reactionImageTwo.image = UIImage(named: "hahaHolder")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.wow == true {
                    cell.reactionImageTwo.image = UIImage(named: "wowHolder")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.sad == true {
                    cell.reactionImageTwo.image = UIImage(named: "sadHolder")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.angry == true {
                    cell.reactionImageTwo.image = UIImage(named: "angryHolder")
                    cell.reactionImageTwo.alpha = 1
                }
                if chatMessage.like == true {
                    cell.reactionImageTwo.image = UIImage(named: "thumbsUpHolder")
                    cell.reactionImageTwo.alpha = 1
                }
            }
            if chatMessage.isReaction == false {
                cell.reactionImageTwo.image = UIImage(named: "reactionImage")
                cell.reactionImageTwo.alpha = 0.08
//                cell.reactionHolderTwo.alpha = 0
            }
            
        }
        
        if chatMessage.isIncoming == true {
            cell.seenImage.setImageWith(photourl, placeholderImage: UIImage(named: "ici-avatar"))
            cell.seenImage.backgroundColor = .clear
            
            
            if chatMessage.text == "💰" {
                cell.messageLabel.text = "\n \n"
                cell.moneybagImage.isHidden = false
            }else{
                cell.moneybagImage.isHidden = true
            }
            
            if chatMessage.isReaction == true {
                if chatMessage.wow || chatMessage.sad == true {
                    cell.reactionImage.image = UIImage(named: "wowsad")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.wow || chatMessage.angry == true {
                    cell.reactionImage.image = UIImage(named: "wowangry")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.wow || chatMessage.haha == true {
                    cell.reactionImage.image = UIImage(named: "wowhaha")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.wow || chatMessage.like == true {
                    cell.reactionImage.image = UIImage(named: "wowlike")
                    cell.reactionImage.alpha = 1
                }
                
                if chatMessage.sad || chatMessage.angry == true {
                    cell.reactionImage.image = UIImage(named: "sadangry")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.sad || chatMessage.haha == true {
                    cell.reactionImage.image = UIImage(named: "sadhaha")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.sad || chatMessage.like == true {
                    cell.reactionImage.image = UIImage(named: "sadlike")
                    cell.reactionImage.alpha = 1
                }
                
                if chatMessage.angry || chatMessage.haha == true {
                    cell.reactionImage.image = UIImage(named: "angryhaha")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.angry || chatMessage.like == true {
                    cell.reactionImage.image = UIImage(named: "angrylike")
                    cell.reactionImage.alpha = 1
                }
                
                if chatMessage.haha || chatMessage.like == true {
                    cell.reactionImage.image = UIImage(named: "hahalike")
                    cell.reactionImage.alpha = 1
                }
                
                
                // ONE REACTION
                
                if chatMessage.heart == true {
                    cell.widthOne = 100
                    cell.reactionHolder.widthAnchor.constraint(equalToConstant: 100).isActive = true
                    cell.reactionImage.image = UIImage(named: "loveHolder")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.haha == true {
                    cell.reactionImage.image = UIImage(named: "hahaHolder")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.wow == true {
                    cell.reactionImage.image = UIImage(named: "wowHolder")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.sad == true {
                    cell.reactionImage.image = UIImage(named: "sadHolder")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.angry == true {
                    cell.reactionImage.image = UIImage(named: "angryHolder")
                    cell.reactionImage.alpha = 1
                }
                if chatMessage.like == true {
                    cell.reactionImage.image = UIImage(named: "thumbsUpHolder")
                    cell.reactionImage.alpha = 1
                }
            }else{
                cell.reactionImage.image = UIImage(named: "reactionImage")
                cell.reactionImage.alpha = 0.08
            }
        }
        
        cell.selectionStyle = .none
        cell.chatMessage = chatMessage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let chatMessage = chatMessages[indexPath.row]
        print(chatMessage.id)
        selectedID = chatMessage.id
        selectedIndex = indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedID = ""
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == cellHolder {
            return 6
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cellHolder {
            if selectedReaction != "" {
                let constant: Int = heartReactionsArray.count + hahaReactionsArray.count + wowReactionsArray.count + sadReactionsArray.count + angryReactionsArray.count + likeReactionsArray.count
                if constant > 0 {
                    if section == 0 {
                        return heartReactionsArray.count
                    }else if section == 1 {
                        return hahaReactionsArray.count
                    }else if section == 2 {
                        return wowReactionsArray.count
                    }else if section == 3 {
                        return sadReactionsArray.count
                    }else if section == 4 {
                        return angryReactionsArray.count
                    }else{
                        return likeReactionsArray.count
                    }
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }else{
            if images.count < 0 {
                return 0
            }else{
                return images.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cellHolder {
            let section = indexPath.section
            if section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reactionCellId, for: indexPath) as! ReactionCell
                let iP = heartReactionsArray[indexPath.row]
                
                let name = iP["name"]?.description
                
                if let photo = iP["photo"]?.description {
                    let preURL = "https://members.lionsofforex.com/"
                    if let url = URL(string: "\(preURL)\(photo)") {
                        cell.profileImage.setImageWith(url, placeholderImage: UIImage(named: "ici-avatar"))
                    }
                }
                cell.nameLabel.text = name
                cell.reactionImage.image = UIImage(named: "heart_icon")
                
                return cell
            }else if section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reactionCellId, for: indexPath) as! ReactionCell
                let iP = hahaReactionsArray[indexPath.row]
                
                let name = iP["name"]?.description
                
                if let photo = iP["photo"]?.description {
                    if let url = URL(string: photo) {
                        cell.profileImage.setImageWith(url, placeholderImage: UIImage(named: "ici-avatar"))
                    }
                }
                cell.nameLabel.text = name
                cell.reactionImage.image = UIImage(named: "wow_icon")
                
                return cell
            }else if section == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reactionCellId, for: indexPath) as! ReactionCell
                let iP = wowReactionsArray[indexPath.row]
                
                let name = iP["name"]?.description
                
                if let photo = iP["photo"]?.description {
                    if let url = URL(string: photo) {
                        cell.profileImage.setImageWith(url, placeholderImage: UIImage(named: "ici-avatar"))
                    }
                }
                cell.nameLabel.text = name
                cell.reactionImage.image = UIImage(named: "sad_icon")
                
                return cell
            }else if section == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reactionCellId, for: indexPath) as! ReactionCell
                let iP = sadReactionsArray[indexPath.row]
                
                let name = iP["name"]?.description
                
                if let photo = iP["photo"]?.description {
                    if let url = URL(string: photo) {
                        cell.profileImage.setImageWith(url, placeholderImage: UIImage(named: "ici-avatar"))
                    }
                }
                cell.nameLabel.text = name
                cell.reactionImage.image = UIImage(named: "angry_icon")
                
                return cell
            }else if section == 4 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reactionCellId, for: indexPath) as! ReactionCell
                let iP = angryReactionsArray[indexPath.row]
                
                let name = iP["name"]?.description
                
                if let photo = iP["photo"]?.description {
                    if let url = URL(string: photo) {
                        cell.profileImage.setImageWith(url, placeholderImage: UIImage(named: "ici-avatar"))
                    }
                }
                cell.nameLabel.text = name
                cell.reactionImage.image = UIImage(named: "like_icon")
                
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reactionCellId, for: indexPath) as! ReactionCell
                let iP = likeReactionsArray[indexPath.row]
                
                let name = iP["name"]?.description
                
                if let photo = iP["photo"]?.description {
                    if let url = URL(string: photo) {
                        cell.profileImage.setImageWith(url, placeholderImage: UIImage(named: "ici-avatar"))
                    }
                }
                cell.nameLabel.text = name
                cell.reactionImage.image = UIImage(named: "dislike_icon")
                
                return cell
            }
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellId, for: indexPath) as! PhotoCell
            let asset = images[indexPath.row]
            let manager = PHImageManager.default()
            if cell.tag != 0 {
                manager.cancelImageRequest(PHImageRequestID(cell.tag))
            }
            cell.tag = Int(manager.requestImage(for: asset,
                                                targetSize: CGSize(width: 120.0, height: 120.0),
                                                contentMode: .aspectFill,
                                                options: nil) { (result, _) in
                                                    cell.imageView.image = result
            })
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cellHolder {
            var height = CGFloat()
            let section = indexPath.section
            if section == 0 {
                if heartReactionsArray.isEmpty {
                    height = 0
                    return .init(width: cellHolder.frame.width, height: 0)
                }else{
                    height = 42
                    return .init(width: cellHolder.frame.width, height: 42)
                }
            }else if section == 1 {
                if hahaReactionsArray.isEmpty {
                    height = 0
                    return .init(width: cellHolder.frame.width, height: 0)
                }else{
                    height = 42
                    return .init(width: cellHolder.frame.width, height: 42)
                }
                
            }else if section == 2 {
                if wowReactionsArray.isEmpty {
                    height = 0
                    return .init(width: cellHolder.frame.width, height: 0)
                }else{
                    height = 42
                    return .init(width: cellHolder.frame.width, height: 42)
                }
            }else if section == 3 {
                if sadReactionsArray.isEmpty {
                    height = 0
                    return .init(width: cellHolder.frame.width, height: 0)
                }else{
                    height = 42
                    return .init(width: cellHolder.frame.width, height: 42)
                }
            }else if section == 4 {
                if angryReactionsArray.isEmpty {
                    height = 0
                    return .init(width: cellHolder.frame.width, height: 0)
                }else{
                    height = 42
                    return .init(width: cellHolder.frame.width, height: 42)
                }
            }else{
                if likeReactionsArray.isEmpty {
                    height = 0
                    return .init(width: cellHolder.frame.width, height: 0)
                }else{
                    height = 42
                    return .init(width: cellHolder.frame.width, height: 42)
                }
            }
            
            
            
        }else{
            return .init(width: photosCollectionView.frame.height, height: photosCollectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cellHolder {
            return 10
        }else{
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == cellHolder {
            return .init(top: 0, left: 0, bottom: 55, right: 0)
        }else{
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cellHolder {
            print(indexPath)
        }else{
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(ChatViewController.keepAlive), userInfo: nil, repeats: true)
    }
    
    @objc func keepAlive() {
        //        print("keep alive")
        socket.write(string: "{\"mode\": \"keepalive\", \"session\": \"\(selectedSession)\", \"oldest\": \"\(firstId)\", \"newest\": \"\(lastId)\"}")
    }
    
    // MARK: Setup send buttons
    @objc func sendMessage() {
        if (textField.text?.isEmpty)! {
            print("nothing in field")
        }else{
            let text = textField.text
            
            socket.write(string: "{\"room\": \"\(selectedRoom)\",\"session\": \"\(selectedSession)\",\"text\": \"\(text ?? "")\"}")
            DispatchQueue.main.async {
                self.textField.text = ""
                do {
                    self.audioPlayerTwo = try AVAudioPlayer(contentsOf: self.sendSound)
                    self.audioPlayerTwo.play()
                } catch {
                    // couldn't load file :(
                }
            }
        }
        
    }
    
    @objc func sendMoneyBag() {
        let moneybag = "💰"
        
        socket.write(string: "{\"room\": \"\(selectedRoom)\",\"session\": \"\(selectedSession)\",\"text\": \"\(moneybag)\"}")
        
        DispatchQueue.main.async {
            self.textField.text = ""
            do {
                self.audioPlayerTwo = try AVAudioPlayer(contentsOf: self.sendSound)
                self.audioPlayerTwo.play()
            } catch {
                // couldn't load file :(
            }
        }
        
    }
    

}

extension ChatViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        
        socket.write(string: "{\"mode\": \"setup\",\"room\": \"\(selectedRoom)\"}")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        let utls = text.components(separatedBy: "<li class=\\")
        print("new message received! : \(text)")
        guard let myUserId = KeychainWrapper.standard.string(forKey: "selectedUserId") else { return }
//        let myUserId: String = "3282"
        let parsedText = JSON(text)
//        let string = text
        let string = parsedText.description
        let data = string.data(using: .utf8)!
        
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let jsonData = jsonData {
            let jsonDict = JSON(jsonData)
            //            print(jsonDict)
            
            if let innerJson = jsonDict["reactions"].array {
//                print(innerJson)
                for results in innerJson {
//                    print(results)
                    let currentId = results["message_id"].description
                    let reactionId = results["reactions"].description
                    
                    // convert reactions into json
                    if let iD = chatMessages.firstIndex(where: {$0.id == currentId}) {
                        if chatMessages[iD].id == currentId {
                            if let reactionData = reactionId.data(using: .utf8) {
                                
                                if let reactionjsonData = try? JSONSerialization.jsonObject(with: reactionData, options: .allowFragments) {
                                    
                                    if let reactionjsonDict = JSON(reactionjsonData).array {
                                        if let rue = JSON(reactionjsonDict).arrayObject {
                                            if rue.description == "[[], [], [], [], [], [], []]" {
//                                                print("no reactions here")
                                                chatMessages[iD].isReaction = false
                                                self.chatMessages[iD].heart = false
                                                self.chatMessages[iD].haha = false
                                                self.chatMessages[iD].wow = false
                                                self.chatMessages[iD].sad = false
                                                self.chatMessages[iD].angry = false
                                                self.chatMessages[iD].like = false
                                                self.chatMessages[iD].reactions = reactionId
                                            }else{
                                                if chatMessages[iD].reactions == reactionId {
                                                    
                                                }else{
                                                    var isHearted = Bool()
                                                    var isHaha = Bool()
                                                    var isWow = Bool()
                                                    var isSad = Bool()
                                                    var isAngry = Bool()
                                                    var isLiked = Bool()
                                                    
                                                    if let heart = JSON(rue[0]).arrayObject {
                                                        if let haha = JSON(rue[1]).arrayObject {
                                                            if let wow = JSON(rue[2]).arrayObject {
                                                                if let sad = JSON(rue[3]).arrayObject {
                                                                    if let angry = JSON(rue[4]).arrayObject {
                                                                        if let like = JSON(rue[5]).arrayObject {
                                                                            if heart.description == "[]" {
                                                                                //                                                                            chatMessages[iD].heart = true
                                                                                isHearted = false
                                                                            }else{
                                                                                isHearted = true
                                                                            }
                                                                            if haha.description == "[]" {
                                                                                isHaha = false
                                                                            }else{
                                                                                isHaha = true
                                                                            }
                                                                            if wow.description == "[]" {
                                                                                isWow = false
                                                                            }else{
                                                                                isWow = true
                                                                            }
                                                                            if sad.description == "[]" {
                                                                                isSad = false
                                                                            }else{
                                                                                isSad = true
                                                                            }
                                                                            if angry.description == "[]" {
                                                                                isAngry = false
                                                                            }else{
                                                                                isAngry = true
                                                                            }
                                                                            if like.description == "[]" {
                                                                                isLiked = false
                                                                            }else{
                                                                                isLiked = true
                                                                            }
                                                                            
                                                                            if chatMessages[iD].reactions == reactionId {
                                                                                print("same")
                                                                            }else{
                                                                                if self.chatMessages[iD].isReaction == true {
                                                                                    self.chatMessages[iD].isReaction = true
                                                                                    self.chatMessages[iD].heart = isHearted
                                                                                    self.chatMessages[iD].haha = isHaha
                                                                                    self.chatMessages[iD].wow = isWow
                                                                                    self.chatMessages[iD].sad = isSad
                                                                                    self.chatMessages[iD].angry = isAngry
                                                                                    self.chatMessages[iD].like = isLiked
                                                                                    self.chatMessages[iD].reactions = reactionId
                                                                                    
                                                                                    
                                                                                    
                                                                                    DispatchQueue.main.async {
                                                                                        let section = self.tableView.numberOfSections - 1
                                                                                        let item = iD
                                                                                        let indexPath = IndexPath(item: item, section: section)
                                                                                        
                                                                                        self.tableView.reloadRows(at: [indexPath], with: .none)
                                                                                    }
                                                                                }else{
                                                                                    self.chatMessages[iD].isReaction = true
                                                                                    self.chatMessages[iD].heart = isHearted
                                                                                    self.chatMessages[iD].haha = isHaha
                                                                                    self.chatMessages[iD].wow = isWow
                                                                                    self.chatMessages[iD].sad = isSad
                                                                                    self.chatMessages[iD].angry = isAngry
                                                                                    self.chatMessages[iD].like = isLiked
                                                                                    self.chatMessages[iD].reactions = reactionId
                                                                                    
                                                                                    DispatchQueue.main.async {
                                                                                        let section = self.tableView.numberOfSections - 1
                                                                                        let item = iD
                                                                                        let indexPath = IndexPath(item: item, section: section)
                                                                                        
                                                                                        self.tableView.reloadRows(at: [indexPath], with: .none)
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            
                        }
                    }
                }
            }
            
            if let innerJson = jsonDict["tmpl"].array {
                if let last = innerJson.last?.dictionary {
                    if let messageId = last["message_id"]?.description {
                        print("last message id is: \(messageId)")
                        
                        self.lastId = messageId
                    }
                }
                if let first = innerJson.first?.dictionary {
                    if let messageId = first["message_id"]?.description {
                        print("first message id is: \(messageId)")
                        self.firstId = messageId
                        self.oldestId = messageId
                    }
                }
                
//                print(innerJson)
                
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.keepAlive), userInfo: nil, repeats: true)
                
                for results in innerJson {
                    if let active = results.dictionary {
                        let type = active["type"]?.description
                        let sent = "sent"
                        let fingerprint = active["fingerprint"]
                        let message = active["message"]
                        let messageid = active["message_id"]
                        let name = active["name"]
                        let timestamp = active["timestamp"]
                        let time = active["time"]
                        let photo = active["photo"]
                        let reactions = active["reactions"]?.description
                        if let date = active["time"]?.description {
                            let first = date.components(separatedBy: ",")[0]
                            print(first)
                        }
                        
                        if type == sent {
                            if let messageStr:String = message?.description {
                                if let nameStr:String = name?.description {
                                    if let timeStr:String = time?.description {
                                        if let photoStr:String = photo?.description {
                                            
                                            let incoming = false
                                            let reaction = false
                                            _ = ChatMessage.init(id: "0", text: messageStr, sender: nameStr, senderId: myUserId, isIncoming: incoming, isReaction: reaction, heart: reaction, haha: reaction, wow: reaction, sad: reaction, angry: reaction, like: reaction, date: Date.dateFromCustomString(customString: timeStr), photo: photoStr, reactions: reactions ?? "")
                                            
                                            if self.chatMessages.count > 0 {
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let fingerprintStr:String = fingerprint?.description {
                            if let messageStr:String = message?.description {
                                if let messageidStr:String = messageid?.description {
                                    if let nameStr:String = name?.description {
                                        if let timestampStr:String = timestamp?.description {
                                            guard let innerDate = TimeInterval(timestampStr) else { return  }
                                            if let photoStr:String = photo?.description {
                                                if fingerprintStr == myUserId {
                                                    
                                                    if let reactionData = reactions?.data(using: .utf8) {
                                                        let reactionjsonData = try? JSONSerialization.jsonObject(with: reactionData, options: .allowFragments)
                                                        
                                                        if let reactjsonData = reactionjsonData {
                                                            let reactionjsonDict = JSON(reactjsonData)
                                                            
                                                            //                                                            print(reactionjsonDict.description)
                                                            var isHearted = Bool()
                                                            var isHaha = Bool()
                                                            var isWow = Bool()
                                                            var isSad = Bool()
                                                            var isAngry = Bool()
                                                            var islike = Bool()
                                                            var isReaction = Bool()
                                                            let incoming = false
                                                            
                                                            if let reactionsinnerJson = reactionjsonDict.array {
                                                                //                                                                print(reactionsinnerJson[2])
                                                                
                                                                if reactions?.description == "[\n\n]" {
                                                                    let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: false, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions ?? "")
                                                                    
                                                                    chatMessages.append(newMessage)
                                                                }else{
                                                                    if let heart = reactionsinnerJson[0].arrayObject {
                                                                        if heart.count > 0 {
                                                                            isHearted = true
                                                                        }
                                                                        if let haha = reactionsinnerJson[1].arrayObject {
                                                                            if haha.count > 0 {
                                                                                isHaha = true
                                                                            }
                                                                            if let wow = reactionsinnerJson[2].arrayObject {
                                                                                if wow.count > 0 {
                                                                                    isWow = true
                                                                                }
                                                                                if let sad = reactionsinnerJson[3].arrayObject {
                                                                                    if sad.count > 0 {
                                                                                        isSad = true
                                                                                    }
                                                                                    if let angry = reactionsinnerJson[4].arrayObject {
                                                                                        if angry.count > 0 {
                                                                                            isAngry = true
                                                                                        }
                                                                                        if let like = reactionsinnerJson[5].arrayObject {
                                                                                            if like.count > 0 {
                                                                                                islike = true
                                                                                            }
                                                                                            
                                                                                            if heart.count + haha.count + wow.count + sad.count + angry.count + like.count > 0 {
                                                                                                
                                                                                                isReaction = true
//                                                                                                print("you have reactions")
                                                                                                
                                                                                                // MARK Append message
                                                                                                let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: isReaction, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions ?? "")
                                                                                                
                                                                                                chatIds.append([messageidStr])
                                                                                                chatMessages.append(newMessage)
                                                                                                
                                                                                            }else{
                                                                                                
                                                                                                isReaction = false
//                                                                                                print("no reactions")
                                                                                                
                                                                                                // MARK Append message
                                                                                                let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: isReaction, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions ?? "")
                                                                                                
                                                                                                chatIds.append([messageidStr])
                                                                                                chatMessages.append(newMessage)
                                                                                            }
                                                                                            
//                                                                                            print("like: \(like)")
                                                                                        }
//                                                                                        print("angry: \(angry)")
                                                                                    }
//                                                                                    print("sad: \(sad)")
                                                                                }
//                                                                                print("wow: \(wow)")
                                                                            }
//                                                                            print("haha: \(haha)")
                                                                        }
//                                                                        print("heart: \(heart)")
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }else{
                                                    
                                                    if let reactionData = reactions?.data(using: .utf8) {
                                                        let reactionjsonData = try? JSONSerialization.jsonObject(with: reactionData, options: .allowFragments)
                                                        
                                                        if let reactjsonData = reactionjsonData {
                                                            let reactionjsonDict = JSON(reactjsonData)
                                                            
                                                            //                                                            print(reactionjsonDict.description)
                                                            var isHearted = Bool()
                                                            var isHaha = Bool()
                                                            var isWow = Bool()
                                                            var isSad = Bool()
                                                            var isAngry = Bool()
                                                            var islike = Bool()
                                                            var isReaction = Bool()
                                                            let incoming = true
                                                            
                                                            if let reactionsinnerJson = reactionjsonDict.array {
                                                                
                                                                if let heart = reactionsinnerJson[0].arrayObject {
                                                                    if heart.count > 0 {
                                                                        isHearted = true
                                                                    }
                                                                    if let haha = reactionsinnerJson[1].arrayObject {
                                                                        if haha.count > 0 {
                                                                            isHaha = true
                                                                        }
                                                                        if let wow = reactionsinnerJson[2].arrayObject {
                                                                            if wow.count > 0 {
                                                                                isWow = true
                                                                            }
                                                                            if let sad = reactionsinnerJson[3].arrayObject {
                                                                                if sad.count > 0 {
                                                                                    isSad = true
                                                                                }
                                                                                if let angry = reactionsinnerJson[4].arrayObject {
                                                                                    if angry.count > 0 {
                                                                                        isAngry = true
                                                                                    }
                                                                                    if let like = reactionsinnerJson[5].arrayObject {
                                                                                        if like.count > 0 {
                                                                                            islike = true
                                                                                        }
                                                                                        
                                                                                        if heart.count + haha.count + wow.count + sad.count + angry.count + like.count > 0 {
                                                                                            
                                                                                            isReaction = true
                                                                                            
                                                                                            // MARK Append message
                                                                                            let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: isReaction, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions ?? "")
                                                                                            
                                                                                            chatIds.append([messageidStr])
                                                                                            chatMessages.append(newMessage)
                                                                                            
                                                                                        }else{
                                                                                            
                                                                                            isReaction = false
                                                                                            print("no reactions")
                                                                                            
                                                                                            // MARK Append message
                                                                                            let newMessage = ChatMessage.init(id: messageidStr, text: messageStr, sender: nameStr, senderId: fingerprintStr, isIncoming: incoming, isReaction: isReaction, heart: isHearted, haha: isHaha, wow: isWow, sad: isSad, angry: isAngry, like: islike, date: Date.init(timeIntervalSince1970: innerDate), photo: photoStr, reactions: reactions ?? "")
                                                                                            
                                                                                            chatIds.append([messageidStr])
                                                                                            chatMessages.append(newMessage)
                                                                                        }
                                                                                        print("like: \(like)")
                                                                                    }
                                                                                    print("angry: \(angry)")
                                                                                }
                                                                                print("sad: \(sad)")
                                                                            }
                                                                            print("wow: \(wow)")
                                                                        }
                                                                        print("haha: \(haha)")
                                                                    }
                                                                    print("heart: \(heart)")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                if self.chatMessages.count > 0 {
                                                    self.tableView.reloadData()
                                                    
                                                    let section = tableView.numberOfSections - 1
                                                    let item = tableView.numberOfRows(inSection: section) - 1
                                                    let lastItemIndex = IndexPath(item: item, section: section)
                                                    self.tableView.scrollToRow(at: lastItemIndex, at: .top, animated: true)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else{
            print("oops something went wrong")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
}

class DateHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        textColor = .lightGray
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false // enables auto layout
        font = UIFont.systemFont(ofSize: 11, weight: .semibold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 20, height: height)
    }
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class ReactionCell: UICollectionViewCell {
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "")
        iv.backgroundColor = .black
        return iv
    }()
    
    let reactionImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        iv.layer.cornerRadius = 15
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(profileImage)
        stackViewOne.addArrangedSubview(nameLabel)
        stackViewOne.spacing = 13
        stackViewOne.axis = .horizontal
        stackViewOne.alignment = .center
        
        let stackViewTwo = UIStackView()
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        stackViewTwo.addArrangedSubview(stackViewOne)
        stackViewTwo.addArrangedSubview(reactionImage)
        stackViewTwo.spacing = 15
        stackViewTwo.axis = .horizontal
        stackViewTwo.alignment = .center
        
        addSubview(stackViewTwo)
        
        NSLayoutConstraint.activate([
            stackViewTwo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            stackViewTwo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackViewTwo.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "")
        iv.backgroundColor = .gray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}













