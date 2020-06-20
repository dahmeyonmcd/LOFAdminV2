//
//  MessageInfoVC.swift
//  GroupedMessagesLBTA
//
//  Created by UnoEast on 6/18/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MessageInfoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        label.text = "Choose color"
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
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setImage(UIImage(named: "back_arrow"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(goBackTapped), for: .touchUpInside)
        return button
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        layout.headerReferenceSize = CGSize(width: cv.frame.width, height: 30)
        layout.scrollDirection = .vertical
        return cv
    }()
    
    let cellHolderOptions: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        layout.scrollDirection = .vertical
        return cv
    }()
    
    fileprivate let infoCellId = "infoCellId"
    fileprivate let infoCellOneId = "infoCellOneId"
    fileprivate let infoCellTwoId = "infoCellTwoId"
    fileprivate let infoCellThreeId = "infoCellThreeId"
    fileprivate let infoCellHeaderId = "infoCellHeaderId"
    
    fileprivate let messageColorCellId = "messageColorCellId"
    fileprivate let colorsArray = ["Red", "Orange", "Green", "Default", "Purple", "Pink"]
    fileprivate let colorsPicArray = ["Red_Color", "Orange_Color", "Green_Color", "Blue_Color", "Purple_Color", "Pink_Color"]
    
    var reactionsPopUpisOpened: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        
        cellHolderOptions.dataSource = self
        cellHolderOptions.delegate = self
        
        cellHolderOptions.register(MessageColorCell.self, forCellWithReuseIdentifier: messageColorCellId)
        
        cellHolder.register(MessageInfoCell.self, forCellWithReuseIdentifier: infoCellId)
        cellHolder.register(MessageOptionOneCell.self, forCellWithReuseIdentifier: infoCellOneId)
        cellHolder.register(MessageOptionTwoCell.self, forCellWithReuseIdentifier: infoCellTwoId)
        cellHolder.register(MessageOptionThreeCell.self, forCellWithReuseIdentifier: infoCellThreeId)
        cellHolder.register(MessageOptionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: infoCellHeaderId)
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openReactionsPopup), name: Notification.Name("ChangeMessageColorTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reportIt), name: Notification.Name("ReportMessagesProblemTapped"), object: nil)
        
        
    }
    
    
    
    private func setupViews() {
        view.addSubview(topView)
        view.addSubview(cellHolder)
        topView.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0)
            ])
    }
    
    @objc func goBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func reportIt() {
        let vc = MessagesReportVC()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
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
            reactionHolder.addSubview(cellHolderOptions)
            
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
                
                cellHolderOptions.topAnchor.constraint(equalTo: stackViewOne.bottomAnchor, constant: 18),
                cellHolderOptions.bottomAnchor.constraint(equalTo: reactionHolder.bottomAnchor, constant: 0),
                cellHolderOptions.leadingAnchor.constraint(equalTo: reactionHolder.leadingAnchor, constant: 0),
                cellHolderOptions.trailingAnchor.constraint(equalTo: reactionHolder.trailingAnchor, constant: 0),
                ])
            
            
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
    
    @objc func closeReactionsPopup() {
        if reactionsPopUpisOpened == true {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                self.reactionHolder.transform = CGAffineTransform(translationX: 0, y: 1000)
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundOverlay.alpha = 0
                }, completion: { (_) in
                    // MARK:
                    self.reactionsPopUpisOpened = false
                })
            }) { (_) in
                // MARK:
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == cellHolder {
            return 4
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cellHolder {
            if section == 0 {
                return 1
            }else if section == 1 {
                return 1
            }else if section == 2 {
                return 1
            }else{
                return 1
            }
        }else{
            return colorsArray.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if collectionView == cellHolder {
            if section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellId, for: indexPath) as! MessageInfoCell
                return cell
            }else if section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellOneId, for: indexPath) as! MessageOptionOneCell
                return cell
            }else if section == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellTwoId, for: indexPath) as! MessageOptionTwoCell
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellThreeId, for: indexPath) as! MessageOptionThreeCell
                return cell
            }
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageColorCellId, for: indexPath) as! MessageColorCell
            let iP = colorsArray[indexPath.row]
            let iC = colorsPicArray[indexPath.row]
            cell.titleLabel.text = iP
            cell.optionImage.image = UIImage(named: iC)
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if collectionView == cellHolder {
            if section == 0 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: infoCellHeaderId, for: indexPath)
                return headerView
            }else if section == 1 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: infoCellHeaderId, for: indexPath)
                return headerView
            }else if section == 2 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: infoCellHeaderId, for: indexPath) as! MessageOptionHeader
                headerView.titleLabel.text = "PREFERENCES"
                return headerView
            }else{
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: infoCellHeaderId, for: indexPath) as! MessageOptionHeader
                headerView.titleLabel.text = "PRIVACY & SUPPORT"
                return headerView
            }
        }else{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: infoCellHeaderId, for: indexPath)
            return headerView
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cellHolder {
            
        }else{
            // MARK: LA LA LA
            print(indexPath)
            
            let iP = colorsArray[indexPath.row]
            print(iP)
            
            if iP == "Red" {
                // MARK Set color to red)
                
                UserDefaults.standard.set("Red", forKey: "SelectedMessageColor")
                NotificationCenter.default.post(name: Notification.Name("SelectedNewMessageColor"), object: nil)
                
            }else if iP == "Orange" {
                // MARK Set color to orange
                
                UserDefaults.standard.set("Orange", forKey: "SelectedMessageColor")
                NotificationCenter.default.post(name: Notification.Name("SelectedNewMessageColor"), object: nil)
                
            }else if iP == "Green" {
                // MARK Set color to green
                
                UserDefaults.standard.set("Green", forKey: "SelectedMessageColor")
                NotificationCenter.default.post(name: Notification.Name("SelectedNewMessageColor"), object: nil)
                
            }else if iP == "Default" {
                // MARK Set color to blue
                
                UserDefaults.standard.set("Blue", forKey: "SelectedMessageColor")
                NotificationCenter.default.post(name: Notification.Name("SelectedNewMessageColor"), object: nil)
                
            }else if iP == "Purple" {
                // MARK Set color to purple
                
                UserDefaults.standard.set("Purple", forKey: "SelectedMessageColor")
                NotificationCenter.default.post(name: Notification.Name("SelectedNewMessageColor"), object: nil)
                
            }else{
                // MARK Set color to pink
                
                UserDefaults.standard.set("Pink", forKey: "SelectedMessageColor")
                NotificationCenter.default.post(name: Notification.Name("SelectedNewMessageColor"), object: nil)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == cellHolder {
            if section == 0 {
                return .init(width: cellHolder.frame.width, height: 0)
            }else if section == 1 {
                return .init(width: cellHolder.frame.width, height: 0)
            }else if section == 2 {
                return .init(width: cellHolder.frame.width, height: 30)
            }else{
                return .init(width: cellHolder.frame.width, height: 30)
            }
        }else{
            return .init(width: cellHolderOptions.frame.width, height: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        if collectionView == cellHolder {
            if section == 0 {
                return .init(width: cellHolder.frame.width, height: 220)
            }else if section == 1 {
                return .init(width: cellHolder.frame.width, height: 100)
            }else if section == 2 {
                return .init(width: cellHolder.frame.width, height: 100)
            }else{
                return .init(width: cellHolder.frame.width, height: 100)
            }
        }else{
            return .init(width: cellHolderOptions.frame.width, height: 42)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cellHolder {
            return 10
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == cellHolder {
            if section == 0 {
                return .init(top: 0, left: 0, bottom: 10, right: 0)
            }else if section == 1 {
                return .init(top: 0, left: 0, bottom: 20, right: 0)
            }else if section == 2 {
                return .init(top: 0, left: 0, bottom: 20, right: 0)
            }else{
                return .init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }else{
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}

class MessageInfoCell: UICollectionViewCell {
    
    let chatImage: UIImageView = {
        let iv = UIImageView()
        let constant:CGFloat = 90
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        iv.heightAnchor.constraint(equalToConstant: constant).isActive = true
        iv.widthAnchor.constraint(equalToConstant: constant).isActive = true
        iv.layer.cornerRadius = constant / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let buttonOne: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.setImage(UIImage(named: "message_audio"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .black
        button.layer.cornerRadius = 40 / 2
        return button
    }()
    
    let buttonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.setImage(UIImage(named: "message_video"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .black
        button.layer.cornerRadius = 40 / 2
        return button
    }()
    
    let buttonThree: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.setImage(UIImage(named: "message_mute"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .black
        button.layer.cornerRadius = 40 / 2
        return button
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Room"
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Active today"
        return label
    }()
    
    let buttonLabelOne: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Audio"
        return label
    }()
    
    let buttonLabelTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Video"
        return label
    }()
    
    let buttonLabelThree: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Mute"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let selectedImage: String? = KeychainWrapper.standard.string(forKey: "selectedMessageImage")
        chatImage.image = UIImage(named: selectedImage!)
        
        let selectedRoomName: String? = KeychainWrapper.standard.string(forKey: "selectedMessageRoom")
        mainLabel.text = selectedRoomName
        
        setupViews()
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(buttonOne)
        stackViewOne.addArrangedSubview(buttonLabelOne)
        stackViewOne.axis = .vertical
        stackViewOne.alignment = .center
        stackViewOne.spacing = 2
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewTwo = UIStackView()
        stackViewTwo.addArrangedSubview(buttonTwo)
        stackViewTwo.addArrangedSubview(buttonLabelTwo)
        stackViewTwo.axis = .vertical
        stackViewTwo.alignment = .center
        stackViewTwo.spacing = 2
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewThree = UIStackView()
        stackViewThree.addArrangedSubview(buttonThree)
        stackViewThree.addArrangedSubview(buttonLabelThree)
        stackViewThree.axis = .vertical
        stackViewThree.alignment = .center
        stackViewThree.spacing = 2
        stackViewThree.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStackView = UIStackView()
        buttonStackView.addArrangedSubview(stackViewOne)
        buttonStackView.addArrangedSubview(stackViewTwo)
        buttonStackView.addArrangedSubview(stackViewThree)
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 30
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStackView = UIStackView()
        labelStackView.addArrangedSubview(mainLabel)
        labelStackView.addArrangedSubview(subLabel)
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        labelStackView.spacing = 0
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let topStackView = UIStackView()
        topStackView.addArrangedSubview(chatImage)
        topStackView.addArrangedSubview(labelStackView)
        topStackView.axis = .vertical
        topStackView.alignment = .center
        topStackView.spacing = 5
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView()
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MessageOptionHeader: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .left
        label.text = "PREFERENCES"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MessageOptionOneCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let cellHolder: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.isScrollEnabled = false
        return tv
    }()
    
    fileprivate let cellId = "MessageOptionTableViewCellID"
    fileprivate let array = ["Color", "Nicknames"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(MessageOptionTableViewCell.self, forCellReuseIdentifier: cellId)
        
        cellHolder.separatorColor = .lightGray
        cellHolder.separatorStyle = .singleLine
        cellHolder.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectedColor), name: Notification.Name("SelectedNewMessageColor"), object: nil)
        
        setupViews()
    }
    
    @objc func selectedColor() {
        let indexPath = IndexPath(item: 0, section: 0)
        cellHolder.reloadRows(at: [indexPath], with: .none)
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageOptionTableViewCell
        let iP = array[indexPath.row]
        
        if indexPath.row == 0 {
            if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Red" {
                cell.optionImage.image = UIImage(named: "Red_Color")
            }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Orange" {
                cell.optionImage.image = UIImage(named: "Orange_Color")
            }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Blue" {
                cell.optionImage.image = UIImage(named: "Blue_Color")
            }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Green" {
                cell.optionImage.image = UIImage(named: "Green_Color")
            }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Pink" {
                cell.optionImage.image = UIImage(named: "Pink_Color")
            }else if UserDefaults.standard.string(forKey: "SelectedMessageColor") == "Purple" {
                cell.optionImage.image = UIImage(named: "Purple_Color")
            }else{
                cell.optionImage.image = UIImage(named: "Blue_Color")
            }
        }else{
            cell.optionImage.image = UIImage(named: "messagesarrow_icon")
        }
        
        cell.titleLabel.text = iP
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath.row == 0 {
            NotificationCenter.default.post(name: Notification.Name("ChangeMessageColorTapped"), object: nil)
            print("changing color")
        }else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MessageOptionTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Color"
        return label
    }()
    
    let optionImage: UIImageView = {
        let iv = UIImageView()
        let constant:CGFloat = 32
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.heightAnchor.constraint(equalToConstant: constant).isActive = true
        iv.widthAnchor.constraint(equalToConstant: constant).isActive = true
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "MessageOptionTableViewCellID")
        
        setupViews()
        
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.addArrangedSubview(optionImage)
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.alignment = .center
        stackViewOne.axis = .horizontal
        
        addSubview(stackViewOne)
        NSLayoutConstraint.activate([
            stackViewOne.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackViewOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackViewOne.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MessageOptionTwoCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    let cellHolder: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.isScrollEnabled = false
        return tv
    }()
    
    fileprivate let cellId = "MessageOptionTableViewCellID"
    fileprivate let array = ["See Group members", "Invite to Group with Link"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(MessageOptionTableViewCell.self, forCellReuseIdentifier: cellId)
        
        cellHolder.separatorColor = .lightGray
        cellHolder.separatorStyle = .singleLine
        cellHolder.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageOptionTableViewCell
        let iP = array[indexPath.row]
        
        if indexPath.row == 0 {
            cell.optionImage.image = UIImage(named: "messagesarrow_icon")
        }else{
            cell.optionImage.image = UIImage(named: "messageslink_icon")
        }
        
        cell.titleLabel.text = iP
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MessageOptionThreeCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let cellHolder: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.isScrollEnabled = false
        return tv
    }()
    
    fileprivate let cellId = "MessageOptionTableViewCellID"
    fileprivate let array = ["Receive Notifications", "Report a Problem"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(MessageOptionTableViewCell.self, forCellReuseIdentifier: cellId)
        
        cellHolder.separatorColor = .lightGray
        cellHolder.separatorStyle = .singleLine
        cellHolder.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        backgroundColor = .clear
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageOptionTableViewCell
        let iP = array[indexPath.row]
        
        if indexPath.row == 0 {
            cell.optionImage.image = UIImage(named: "messagesarrow_icon")
        }else{
            cell.optionImage.image = UIImage(named: "messagesarrow_icon")
        }
        
        cell.titleLabel.text = iP
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }else{
            NotificationCenter.default.post(name: Notification.Name("ReportMessagesProblemTapped"), object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MessageColorCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Color"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let optionImage: UIImageView = {
        let iv = UIImageView()
        let constant:CGFloat = 30
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.heightAnchor.constraint(equalToConstant: constant).isActive = true
        iv.widthAnchor.constraint(equalToConstant: constant).isActive = true
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.addArrangedSubview(optionImage)
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.alignment = .center
        stackViewOne.axis = .horizontal
        
        addSubview(stackViewOne)
        NSLayoutConstraint.activate([
            stackViewOne.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackViewOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackViewOne.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
