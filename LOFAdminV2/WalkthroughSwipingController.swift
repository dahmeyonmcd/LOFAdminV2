//
//  SwipingController.swift
//  ULT
//
//  Created by UNO EAST on 2/18/19.
//  Copyright © 2019 UNO EAST. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class WalkthroughSwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitle("DONE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToDashboard), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    let pages = ["", "", "", "", "", "", "", ""]
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrevious() {
        print("Previous button tapped")
        let nextIndex = max(pageControl.currentPage - 1,0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private let NextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.init(red: 87/2255, green: 213/255, blue: 233/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        print("Next button tapped")
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor.init(red: 87/2255, green: 213/255, blue: 233/255, alpha: 1)
        pc.pageIndicatorTintColor = .gray
        return pc
    }()
    
    fileprivate func setupBottomControls() {
        let bottomControlStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, NextButton])
        bottomControlStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlStackView)
        
        NSLayoutConstraint.activate([
            bottomControlStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    
    
    // enables swipe tracking
    
    
    let WalkthroughCellOneCellId = "walkthroughCellOneCellId"
    let WalkthroughCellTwoCellId = "walkthroughCellTwoCellId"
    let WalkthroughCellFourCellId = "walkthroughCellFourCellId"
    let WalkthroughCellThreeCellId = "walkthroughCellThreeCellId"
    let WalkthroughCellFiveCellId = "walkthroughCellFiveCellId"
    let WalkthroughCellSixCellId = "walkthroughCellSixCellId"
    let WalkthroughCellSevenCellId = "walkthroughCellSevenCellId"
    let WalkthroughCellEightCellId = "walkthroughCellEightCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottomControls()
        collectionView?.backgroundColor = .white
        
        // creates cell with reuse identifier
        collectionView.register(WalkthroughPageOneCell.self, forCellWithReuseIdentifier: WalkthroughCellOneCellId)
        collectionView.register(WalkthroughPageTwoCell.self, forCellWithReuseIdentifier: WalkthroughCellTwoCellId)
        collectionView.register(WalkthroughPageThreeCell.self, forCellWithReuseIdentifier: WalkthroughCellThreeCellId)
        collectionView.register(WalkthroughPageFourCell.self, forCellWithReuseIdentifier: WalkthroughCellFourCellId)
        collectionView.register(WalkthroughPageFiveCell.self, forCellWithReuseIdentifier: WalkthroughCellFiveCellId)
        collectionView.register(WalkthroughPageSixCell.self, forCellWithReuseIdentifier: WalkthroughCellSixCellId)
        collectionView.register(WalkthroughPageSevenCell.self, forCellWithReuseIdentifier: WalkthroughCellSevenCellId)
        collectionView.register(WalkthroughPageEightCell.self, forCellWithReuseIdentifier: WalkthroughCellEightCellId)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        
        setupTopView()
        
    }
    
    func setupTopView() {
        
        view.addSubview(closeButton)
        
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkthroughCellOneCellId, for: indexPath) as! WalkthroughPageOneCell
            return cell
            
        }else if indexPath.row == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkthroughCellTwoCellId, for: indexPath) as! WalkthroughPageTwoCell
            return cell
            
        }else if indexPath.row == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkthroughCellThreeCellId, for: indexPath) as! WalkthroughPageThreeCell
            return cell
            
        }else if indexPath.row == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkthroughCellFourCellId, for: indexPath) as! WalkthroughPageFourCell
            return cell
            
        }else if indexPath.row == 4 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkthroughCellFiveCellId, for: indexPath) as! WalkthroughPageFiveCell
            return cell
            
        }else if indexPath.row == 5 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkthroughCellSixCellId, for: indexPath) as! WalkthroughPageSixCell
            return cell
            
        }else if indexPath.row == 6 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkthroughCellSevenCellId, for: indexPath) as! WalkthroughPageSevenCell
            return cell
            
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkthroughCellEightCellId, for: indexPath) as! WalkthroughPageEightCell
            return cell
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
//            previousButton.alpha = 0
//            previousButton.isUserInteractionEnabled = false
//
//            NextButton.alpha = 1
//            NextButton.isUserInteractionEnabled = true
            
        }else if indexPath.row == 1 {
            
//            previousButton.alpha = 1
//            previousButton.isUserInteractionEnabled = true
//
//            NextButton.alpha = 1
//            NextButton.isUserInteractionEnabled = true
            
        }else if indexPath.row == 2 {
            
//            previousButton.alpha = 1
//            previousButton.isUserInteractionEnabled = true
//
//            NextButton.alpha = 1
//            NextButton.isUserInteractionEnabled = true
            
        }else if indexPath.row == 3 {
            
            //            previousButton.alpha = 1
            //            previousButton.isUserInteractionEnabled = true
            //
            //            NextButton.alpha = 1
            //            NextButton.isUserInteractionEnabled = true
            
        }else if indexPath.row == 4 {
            
            //            previousButton.alpha = 1
            //            previousButton.isUserInteractionEnabled = true
            //
            //            NextButton.alpha = 1
            //            NextButton.isUserInteractionEnabled = true
            
        }else if indexPath.row == 5 {
            
            //            previousButton.alpha = 1
            //            previousButton.isUserInteractionEnabled = true
            //
            //            NextButton.alpha = 1
            //            NextButton.isUserInteractionEnabled = true
            
        }else if indexPath.row == 6 {
            
            //            previousButton.alpha = 1
            //            previousButton.isUserInteractionEnabled = true
            //
            //            NextButton.alpha = 1
            //            NextButton.isUserInteractionEnabled = true
            
        }else {
            
//            previousButton.alpha = 1
//            previousButton.isUserInteractionEnabled = true
//
//            NextButton.alpha = 0
//            NextButton.isUserInteractionEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func goToDashboard() {
        let signedinToken: Bool? = KeychainWrapper.standard.bool(forKey: "SignedInOnce")
        
        if signedinToken == nil {
            print("Go To Dashboard")
            // go straight to dashboard
            let dashboardVC = NewDashboardVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = dashboardVC
        }else if signedinToken == false {
            print("Go To Dashboard")
            // go straight to dashboard
            let dashboardVC = NewDashboardVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = dashboardVC
        }else{
            print("Go To Dashboard")
            // go straight to dashboard
            let dashboardVC = NewDashboardVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = dashboardVC
        }
        
//
//        print("Go To Dashboard")
//        // go straight to dashboard
//        let dashboardVC = DashboardVC()
//        let appDelegate = UIApplication.shared.delegate
//        appDelegate?.window??.rootViewController = dashboardVC
    }
    
    
}
