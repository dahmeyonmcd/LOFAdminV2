//
//  ChatMessageCell.swift
//  GroupedMessagesLBTA
//
//  Created by Brian Voong on 8/25/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {

    let messageLabel = UILabel()
    let senderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "Sender"
        return label
    }()
    
    let bubbleBackgroundView = UIView()
    
    let reactionHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.backgroundColor = .white
        view.layer.shadowRadius = 0.5
        view.layer.cornerRadius = 10
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    let reactionImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "reactionImage")
        iv.alpha = 0.08
        return iv
    }()
    
    let reactionHolderTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.backgroundColor = .white
        view.layer.shadowRadius = 0.5
        view.layer.cornerRadius = 10
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        view.
        return view
    }()
    
    let reactionImageTwo: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "reactionImage")
        iv.alpha = 0.08
        return iv
    }()
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iv.layer.cornerRadius = 15
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        return iv
    }()
    
    let moneybagImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "moneybag")
        iv.backgroundColor = .clear
        return iv
    }()
    
    let seenImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iv.layer.cornerRadius = 7.5
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
        iv.image = UIImage(named: "delivered2")
        return iv
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var leadingConstraintTwo: NSLayoutConstraint!
    var leadingConstraintThree: NSLayoutConstraint!
    
    var trailingConstraint: NSLayoutConstraint!
    var trailingConstraintTwo: NSLayoutConstraint!
    var trailingConstraintThree: NSLayoutConstraint!
    
    var viewController = ChatViewController()
    
    var widthOne: CGFloat = 35
    
    var messageHighlighted: Bool = false
    
    var youtuber : String?
    
    weak var delegate : YoutuberTableViewCellDelegate?
    
    var chatMessage: ChatMessage! {
        
        didSet {
            if UserDefaults.standard.string(forKey: "SelectedMessageColor") != nil {
                if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Red" {
                    bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08) : UIColor.init(red: 229/255, green: 3/255, blue: 3/255, alpha: 1)
                    messageLabel.textColor = chatMessage.isIncoming ? .black : .white
                    
                    if chatMessage.text == "💰" {
                        messageLabel.text = "\n \n"
                        bubbleBackgroundView.backgroundColor = .clear
                    }else{
                        messageLabel.text = chatMessage.text
                    }
                    
                    senderLabel.text = chatMessage.sender
                    
                    if chatMessage.isIncoming {
                        leadingConstraint.isActive = true
                        leadingConstraintTwo.isActive = true
                        leadingConstraintThree.isActive = true
                        trailingConstraintTwo.isActive = false
//                        trailingConstraintThree.isActive = false
                        trailingConstraint.isActive = false
                        profileImage.isHidden = false
                        senderLabel.isHidden = false
                        reactionHolder.isHidden = false
                        reactionHolderTwo.isHidden = true
                    } else {
                        leadingConstraint.isActive = false
                        leadingConstraintTwo.isActive = false
                        leadingConstraintThree.isActive = false
                        trailingConstraintTwo.isActive = true
//                        trailingConstraintThree.isActive = true
                        trailingConstraint.isActive = true
                        profileImage.isHidden = true
                        senderLabel.isHidden = true
                        reactionHolder.isHidden = true
                        reactionHolderTwo.isHidden = false
                    }
                }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Purple" {
                    bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08) : UIColor.init(red: 138/255, green: 3/255, blue: 229/255, alpha: 1)
                    messageLabel.textColor = chatMessage.isIncoming ? .black : .white
                    
                    if chatMessage.text == "💰" {
                        messageLabel.text = "\n \n"
                        bubbleBackgroundView.backgroundColor = .clear
                    }else{
                        messageLabel.text = chatMessage.text
                    }
                    
                    senderLabel.text = chatMessage.sender
                    
                    if chatMessage.isIncoming {
                        leadingConstraint.isActive = true
                        leadingConstraintTwo.isActive = true
                        leadingConstraintThree.isActive = true
                        trailingConstraintTwo.isActive = false
//                        trailingConstraintThree.isActive = false
                        trailingConstraint.isActive = false
                        profileImage.isHidden = false
                        senderLabel.isHidden = false
                        reactionHolder.isHidden = false
                        reactionHolderTwo.isHidden = true
                    } else {
                        leadingConstraint.isActive = false
                        leadingConstraintTwo.isActive = false
                        leadingConstraintThree.isActive = false
                        trailingConstraintTwo.isActive = true
//                        trailingConstraintThree.isActive = true
                        trailingConstraint.isActive = true
                        profileImage.isHidden = true
                        senderLabel.isHidden = true
                        reactionHolder.isHidden = true
                        reactionHolderTwo.isHidden = false
                    }
                }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Orange" {
                    bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08) : UIColor.init(red: 229/255, green: 137/255, blue: 3/255, alpha: 1)
                    messageLabel.textColor = chatMessage.isIncoming ? .black : .white
                    
                    if chatMessage.text == "💰" {
                        messageLabel.text = "\n \n"
                        bubbleBackgroundView.backgroundColor = .clear
                    }else{
                        messageLabel.text = chatMessage.text
                    }
                    
                    senderLabel.text = chatMessage.sender
                    
                    if chatMessage.isIncoming {
                        leadingConstraint.isActive = true
                        leadingConstraintTwo.isActive = true
                        leadingConstraintThree.isActive = true
                        trailingConstraintTwo.isActive = false
//                        trailingConstraintThree.isActive = false
                        trailingConstraint.isActive = false
                        profileImage.isHidden = false
                        senderLabel.isHidden = false
                        reactionHolder.isHidden = false
                        reactionHolderTwo.isHidden = true
                    } else {
                        leadingConstraint.isActive = false
                        leadingConstraintTwo.isActive = false
                        leadingConstraintThree.isActive = false
                        trailingConstraintTwo.isActive = true
//                        trailingConstraintThree.isActive = true
                        trailingConstraint.isActive = true
                        profileImage.isHidden = true
                        senderLabel.isHidden = true
                        reactionHolder.isHidden = true
                        reactionHolderTwo.isHidden = false
                    }
                }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Blue" {
                    bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08) : UIColor.init(red: 3/255, green: 229/255, blue: 175/255, alpha: 1)
                    messageLabel.textColor = chatMessage.isIncoming ? .black : .white
                    
                    if chatMessage.text == "💰" {
                        messageLabel.text = "\n \n"
                        bubbleBackgroundView.backgroundColor = .clear
                    }else{
                        messageLabel.text = chatMessage.text
                    }
                    
                    senderLabel.text = chatMessage.sender
                    
                    if chatMessage.isIncoming {
                        leadingConstraint.isActive = true
                        leadingConstraintTwo.isActive = true
                        leadingConstraintThree.isActive = true
                        trailingConstraintTwo.isActive = false
//                        trailingConstraintThree.isActive = false
                        trailingConstraint.isActive = false
                        profileImage.isHidden = false
                        senderLabel.isHidden = false
                        reactionHolder.isHidden = false
                        reactionHolderTwo.isHidden = true
                    } else {
                        leadingConstraint.isActive = false
                        leadingConstraintTwo.isActive = false
                        leadingConstraintThree.isActive = false
                        trailingConstraintTwo.isActive = true
//                        trailingConstraintThree.isActive = true
                        trailingConstraint.isActive = true
                        profileImage.isHidden = true
                        senderLabel.isHidden = true
                        reactionHolder.isHidden = true
                        reactionHolderTwo.isHidden = false
                    }
                }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Pink" {
                    bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08) : UIColor.init(red: 229/255, green: 3/255, blue: 172/255, alpha: 1)
                    messageLabel.textColor = chatMessage.isIncoming ? .black : .white
                    
                    if chatMessage.text == "💰" {
                        messageLabel.text = "\n \n"
                        bubbleBackgroundView.backgroundColor = .clear
                    }else{
                        messageLabel.text = chatMessage.text
                    }
                    
                    senderLabel.text = chatMessage.sender
                    
                    if chatMessage.isIncoming {
                        leadingConstraint.isActive = true
                        leadingConstraintTwo.isActive = true
                        leadingConstraintThree.isActive = true
                        trailingConstraintTwo.isActive = false
//                        trailingConstraintThree.isActive = false
                        trailingConstraint.isActive = false
                        profileImage.isHidden = false
                        senderLabel.isHidden = false
                        reactionHolder.isHidden = false
                        reactionHolderTwo.isHidden = true
                    } else {
                        leadingConstraint.isActive = false
                        leadingConstraintTwo.isActive = false
                        leadingConstraintThree.isActive = false
                        trailingConstraintTwo.isActive = true
//                        trailingConstraintThree.isActive = true
                        trailingConstraint.isActive = true
                        profileImage.isHidden = true
                        senderLabel.isHidden = true
                        reactionHolder.isHidden = true
                        reactionHolderTwo.isHidden = false
                    }
                }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Green" {
                    bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08) : UIColor.init(red: 75/255, green: 229/255, blue: 3/255, alpha: 1)
                    messageLabel.textColor = chatMessage.isIncoming ? .black : .white
                    
                    if chatMessage.text == "💰" {
                        messageLabel.text = "\n \n"
                        bubbleBackgroundView.backgroundColor = .clear
                    }else{
                        messageLabel.text = chatMessage.text
                    }
                    
                    senderLabel.text = chatMessage.sender
                    
                    if chatMessage.isIncoming {
                        leadingConstraint.isActive = true
                        leadingConstraintTwo.isActive = true
                        leadingConstraintThree.isActive = true
                        trailingConstraintTwo.isActive = false
//                        trailingConstraintThree.isActive = false
                        trailingConstraint.isActive = false
                        profileImage.isHidden = false
                        senderLabel.isHidden = false
                        reactionHolder.isHidden = false
                        reactionHolderTwo.isHidden = true
                    } else {
                        leadingConstraint.isActive = false
                        leadingConstraintTwo.isActive = false
                        leadingConstraintThree.isActive = false
                        trailingConstraintTwo.isActive = true
//                        trailingConstraintThree.isActive = true
                        trailingConstraint.isActive = true
                        profileImage.isHidden = true
                        senderLabel.isHidden = true
                        reactionHolder.isHidden = true
                        reactionHolderTwo.isHidden = false
                    }
                }
            }else{
                bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08) : UIColor.init(red: 3/255, green: 229/255, blue: 175/255, alpha: 1)
                messageLabel.textColor = chatMessage.isIncoming ? .black : .white
               
                if chatMessage.text == "💰" {
                    messageLabel.text = "\n \n"
                    bubbleBackgroundView.backgroundColor = .clear
                }else{
                    messageLabel.text = chatMessage.text
                }
                senderLabel.text = chatMessage.sender
                
                if chatMessage.isIncoming {
                    leadingConstraint.isActive = true
                    leadingConstraintTwo.isActive = true
                    leadingConstraintThree.isActive = true
                    trailingConstraintTwo.isActive = false
//                    trailingConstraintThree.isActive = false
                    trailingConstraint.isActive = false
                    profileImage.isHidden = false
                    senderLabel.isHidden = false
                    reactionHolder.isHidden = false
                    reactionHolderTwo.isHidden = true
                } else {
                    leadingConstraint.isActive = false
                    leadingConstraintTwo.isActive = false
                    leadingConstraintThree.isActive = false
                    trailingConstraintTwo.isActive = true
//                    trailingConstraintThree.isActive = true
                    trailingConstraint.isActive = true
                    profileImage.isHidden = true
                    senderLabel.isHidden = true
                    reactionHolder.isHidden = true
                    reactionHolderTwo.isHidden = false
                }
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .yellow
        bubbleBackgroundView.layer.cornerRadius = 20
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0

        addSubview(profileImage)
        addSubview(seenImage)
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(senderLabel)
        addSubview(reactionHolder)
        addSubview(moneybagImage)
        reactionHolder.addSubview(reactionImage)
        
        addSubview(reactionHolderTwo)
        reactionHolderTwo.addSubview(reactionImageTwo)
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -12),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 12),
            
////            moneybagImage.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 0),
            moneybagImage.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 0),
            moneybagImage.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -24),
            moneybagImage.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 0),
            ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        leadingConstraintTwo = messageLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 24)
        leadingConstraintThree = moneybagImage.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12) // 12
        leadingConstraint.isActive = false
        leadingConstraintTwo.isActive = false
        leadingConstraintThree.isActive = false
        
        trailingConstraintTwo = profileImage.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: -12)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: seenImage.leadingAnchor, constant: -24)
//        trailingConstraintThree = moneybagImage.trailingAnchor.constraint(equalTo: seenImage.leadingAnchor, constant: -12) // -12
        
        trailingConstraint.isActive = true
        trailingConstraintTwo.isActive = true
//        trailingConstraintThree.isActive = true
        
        bottomConstraint = messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        bottomConstraint.isActive = true
        
        
        
        NSLayoutConstraint.activate([
            profileImage.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: 0),
            
            
            
            seenImage.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: 0),
            seenImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            senderLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: -3),
            senderLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 12),
            
            reactionHolder.widthAnchor.constraint(equalToConstant: widthOne),
            reactionHolder.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -12),
            reactionHolder.topAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -6),
            
            reactionImage.topAnchor.constraint(equalTo: reactionHolder.topAnchor, constant: 1),
            reactionImage.leadingAnchor.constraint(equalTo: reactionHolder.leadingAnchor, constant: 1),
            reactionImage.bottomAnchor.constraint(equalTo: reactionHolder.bottomAnchor, constant: -1),
            reactionImage.trailingAnchor.constraint(equalTo: reactionHolder.trailingAnchor, constant: -1),
            
            reactionHolderTwo.widthAnchor.constraint(equalToConstant: widthOne),
            reactionHolderTwo.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 12),
            reactionHolderTwo.topAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -6),
            
            reactionImageTwo.topAnchor.constraint(equalTo: reactionHolderTwo.topAnchor, constant: 1),
            reactionImageTwo.leadingAnchor.constraint(equalTo: reactionHolderTwo.leadingAnchor, constant: 1),
            reactionImageTwo.bottomAnchor.constraint(equalTo: reactionHolderTwo.bottomAnchor, constant: -1),
            reactionImageTwo.trailingAnchor.constraint(equalTo: reactionHolderTwo.trailingAnchor, constant: -1),
            
            ])
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
//        bubbleBackgroundView.addGestureRecognizer(tapGesture)
        
        let reactionGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOne))
        let reactionGestureTwo = UITapGestureRecognizer(target: self, action: #selector(handleTapOne))
        reactionHolder.addGestureRecognizer(reactionGesture)
        reactionHolderTwo.addGestureRecognizer(reactionGestureTwo)

        
    }
    
    
    @objc func handleTapOne() {
        if let youtuber = youtuber,
            let delegate = delegate {
            self.delegate?.youtuberTableViewCell(self, subscribeButtonTappedFor: youtuber)
            NotificationCenter.default.post(name: Notification.Name("OpenReactionsPopup"), object: nil)
        }
        
    }
    
    @objc func handleTapGesture() {
        if messageHighlighted == false {
            if chatMessage.isIncoming == true {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                    self.bubbleBackgroundView.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.19)
                }) { (_) in
                    //handle done
                    self.messageHighlighted = true
                }
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                    self.bubbleBackgroundView.backgroundColor = UIColor.init(red: 3/255, green: 208/255, blue: 159/255, alpha: 1)
                }) { (_) in
                    //handle done
                    self.messageHighlighted = true
                }
            }
            
            
        }else if messageHighlighted == true{
            if chatMessage.isIncoming == true {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                    self.bubbleBackgroundView.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08)
                }) { (_) in
                    //handle done
                    self.messageHighlighted = false
                }
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                    self.bubbleBackgroundView.backgroundColor = UIColor.init(red: 3/255, green: 229/255, blue: 175/255, alpha: 1)
                }) { (_) in
                    //handle done
                    self.messageHighlighted = false
                }
            }
        }
    }
    
//    func handleGestureEnd(gesture: UITapGestureRecognizer) {
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol YoutuberTableViewCellDelegate: AnyObject {
    
    func youtuberTableViewCell(_ youtuberTableViewCell: ChatMessageCell, subscribeButtonTappedFor youtuber: String)
    func youtuberTableViewCell(_ youtuberTableViewCell: ChatMessageCellNoSpacing, subscribeButtonTappedFor youtuber: String)
}

extension ChatViewController : YoutuberTableViewCellDelegate {
    
    func youtuberTableViewCell(_ youtuberTableViewCell: ChatMessageCell, subscribeButtonTappedFor youtuber: String) {
        // directly use the youtuber saved in the cell
        // show alert
        selectedReaction = youtuber
        }
    func youtuberTableViewCell(_ youtuberTableViewCell: ChatMessageCellNoSpacing, subscribeButtonTappedFor youtuber: String) {
        // directly use the youtuber saved in the cell
        // show alert
        selectedReaction = youtuber
    }
}


