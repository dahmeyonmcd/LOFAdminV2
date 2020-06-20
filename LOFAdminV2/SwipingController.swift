//
//  SwipingController.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON
import Lottie

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        
        return mb
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
    
    lazy var tabBar: TabBar = {
        let tB = TabBar()
        tB.swipingController = self
        tB.translatesAutoresizingMaskIntoConstraints = false
        return tB
    }()
    
    let barHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let cellId = "cellId"
    let signalCellId = "signalCellId"
    let educationCellId = "educationCellId"
    let affiliateCellId = "affiliateCellId"
    let notificationCellId = "notificationCellId"
    let chatCellId = "chatPageCellId"
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        profileImageFetch()
        collectionView.isPagingEnabled = true
        collectionView.isSpringLoaded = false
        collectionView.isScrollEnabled = false
        
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SignalPageCell.self, forCellWithReuseIdentifier: signalCellId)
        collectionView.register(EducationPageCell.self, forCellWithReuseIdentifier: educationCellId)
        collectionView.register(AffiliatePageCell.self, forCellWithReuseIdentifier: affiliateCellId)
        collectionView.register(NotificationPageCell.self, forCellWithReuseIdentifier: notificationCellId)
        collectionView.register(ChatPageCell.self, forCellWithReuseIdentifier: chatCellId)
        collectionView.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        
        
        setupMenuBar()
        setupTabBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(expandSignal), name: Notification.Name("OpenExpandedSignalView"), object: nil)
//        startAnimations()
        
        
    }
    
    @objc func expandSignal() {
        
        let vc = SignalOpenVC()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func startAnimations() {
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
        
        // MARK: Launch loading function.
        DispatchQueue.main.async {
//            self.performProfileImageStore()
            // execute

        }
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addSubview(menuTop)
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
            headerImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor)
            
            ])
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: [], animated: false)
        
    }
    
    func setupTabBar() {
        view.addSubview(barHolder)
        barHolder.addSubview(tabBar)
        view.addSubview(menuBottom)
        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            barHolder.heightAnchor.constraint(equalToConstant: 70),
            barHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barHolder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            barHolder.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabBar.heightAnchor.constraint(equalTo: barHolder.heightAnchor),
            tabBar.trailingAnchor.constraint(equalTo: barHolder.trailingAnchor),
            tabBar.leadingAnchor.constraint(equalTo: barHolder.leadingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: barHolder.bottomAnchor),
            tabBar.widthAnchor.constraint(equalTo: barHolder.widthAnchor),
            menuBottom.topAnchor.constraint(equalTo: barHolder.bottomAnchor),
            menuBottom.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBottom.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            ])
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: signalCellId, for: indexPath) as! SignalPageCell
            return cell
            
        }else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: educationCellId, for: indexPath) as! EducationPageCell
            return cell
            
        }else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: affiliateCellId, for: indexPath) as! AffiliatePageCell
            return cell
            
        }else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatPageCell
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notificationCellId, for: indexPath) as! NotificationPageCell
            return cell
            
        }
    }
    

    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        tabBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tabBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    @objc func dashboardTapped() {
        print("Closing Explore")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openAffiliateView() {
        print("open affiliate view")
    }
    
}

