//
//  TabBar.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class TabBar: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIScrollViewDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: frame.size.width / 5, height: frame.height)
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = true
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        return cv
    }()
    
    var swipingController: SwipingController?
    
    let tabBarItems = ["Signals", "Education", "Affiliates", "Notifications"]
    let tabBarIcons = ["Deselected_Signals_Icon","Deselected_Education_Icon", "Deselected_Affiliates_Icon", "Resources", "newNotificationIconDeselected"]
    let tabBarIconsSelected = ["Selected_Signals_Icon","Selected_Education_Icon", "Selected_Affiliates_Icon", "Selected_Chat_Icon", "Selected_Notification_Icon"]
    
    let cellId = "cellId"
    let notificationCellId = "notificationCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false

        
        collectionView.register(TabBarCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(NotificationTabBarCell.self, forCellWithReuseIdentifier: notificationCellId)
        
        collectionView.backgroundColor = .clear
        let selectedItemIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedItemIndexPath, animated: false, scrollPosition: [])
//        backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 1)
        backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        setupHorizontalBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabBar.NotificationArrived(notification:)), name: NSNotification.Name("NewNotificationReceived"), object: nil)
        
    }
    
    @objc func NotificationArrived(notification: Notification) {
        // Do your updating of labels or array here
        print("new notification recieved on tabbar")
        // Add red bubble on app
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = .clear
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
            
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/5).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarIcons.count
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: [], animated: false)
        layoutIfNeeded()
        
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabBarCell
            cell.iconImage.image = UIImage(named: tabBarIcons[indexPath.item])?.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
            return cell
        }else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabBarCell
            cell.iconImage.image = UIImage(named: tabBarIcons[indexPath.item])?.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
            return cell
        }else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabBarCell
            cell.iconImage.image = UIImage(named: tabBarIcons[indexPath.item])?.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
            return cell
        }else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabBarCell
            cell.iconImage.image = UIImage(named: tabBarIcons[indexPath.item])?.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notificationCellId, for: indexPath) as! NotificationTabBarCell
            cell.iconImage.image = UIImage(named: tabBarIcons[indexPath.item])?.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
            return cell
        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabBarCell
//        cell.iconImage.image = UIImage(named: tabBarIcons[indexPath.item])?.withRenderingMode(.alwaysTemplate)
//        cell.tintColor = UIColor.white
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        swipingController?.scrollToMenuIndex(menuIndex: indexPath.item)

        // handle only notification cell
        if indexPath.row == 4 {
            NotificationCenter.default.post(name: Notification.Name("resetNotificationBanner"), object: nil)
        }
//        self.scrollToMenuIndex(menuIndex: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TabBarCell: UICollectionViewCell {
    
    let tabBarIconsSelected = ["Selected_Signals_Icon","Selected_Education_Icon", "Selected_Affiliates_Icon", "Selected_Chat_Icon", "Selected_Notification_Icon"]
    let tabBarIconsDeselected = ["Deselected_Signals_Icon","Deselected_Education_Icon", "Deselected_Affiliates_Icon", "Deselected_Chat_Icon", "Deselected_Notification_Icon"]
    
    
    var iconBackground:UIView = {
       let view = UIView()
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
//        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            iconImage.tintColor = isHighlighted ? UIColor.init(red: 87/255, green: 233/255, blue: 207/255, alpha: 1) : .white
            iconBackground.backgroundColor = isHighlighted ? .clear : .clear
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            iconImage.tintColor = isSelected ? UIColor.init(red: 87/255, green: 233/255, blue: 207/255, alpha: 1): .white
            iconBackground.backgroundColor = isSelected ? .clear : .clear
            
        }
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 1)
        backgroundColor = .clear
        addSubview(iconBackground)
        iconBackground.addSubview(iconImage)
        
        
        iconBackground.heightAnchor.constraint(equalToConstant: 42).isActive = true
        iconBackground.widthAnchor.constraint(equalToConstant: 42).isActive = true
        iconBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconBackground.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NotificationTabBarCell: UICollectionViewCell {

    
    var iconBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        //        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var indicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 21
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.clipsToBounds = true
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            iconImage.tintColor = isHighlighted ? UIColor.init(red: 87/255, green: 233/255, blue: 207/255, alpha: 1) : .white
            iconBackground.backgroundColor = isHighlighted ? .clear : .clear
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            iconImage.tintColor = isSelected ? UIColor.init(red: 87/255, green: 233/255, blue: 207/255, alpha: 1): .white
            iconBackground.backgroundColor = isSelected ? .clear : .clear
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        //        backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 1)
        backgroundColor = .clear
        addSubview(iconBackground)
        iconBackground.addSubview(iconImage)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationTabBarCell.NotificationArrived(notification:)), name: NSNotification.Name("NewNotificationReceived"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationTabBarCell.removeIndicator), name: NSNotification.Name("resetNotificationBanner"), object: nil)
        
        iconBackground.heightAnchor.constraint(equalToConstant: 42).isActive = true
        iconBackground.widthAnchor.constraint(equalToConstant: 42).isActive = true
        iconBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconBackground.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor).isActive = true
    }
    
    @objc func NotificationArrived(notification: Notification) {
        // Do your updating of labels or array here
        print("new notification recieved on tabbar")
        addIndicator()
        // Add red bubble on app
    }
    

    func addIndicator() {
        addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.bottomAnchor.constraint(equalTo: iconImage.topAnchor, constant: -5),
            indicator.leadingAnchor.constraint(equalTo: iconImage.leadingAnchor, constant: -5),
            ])
    }
    
    @objc func removeIndicator() {

        indicator.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
