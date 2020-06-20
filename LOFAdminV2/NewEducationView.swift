//
//  NewEducationView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import Lottie

class NewEducationView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.isScrollEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var collectionViewOne: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        cv.isScrollEnabled = false
        return cv
    }()
    
    lazy var menuBar: TabCellMenu = {
        let mb = TabCellMenu()
        mb.swipingController = self
        return mb
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // SetupLoading
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
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    // MARK: Set up walkthrough
    
    let walkthroughHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return view
    }()
    
    let walkthroughBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "WalkthroughBackground")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let walkthroughTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        let attString = NSAttributedString(string: "MORE", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        label.text = "Take your Inner Circle mentorship on the go! Watch all Forex & Millionaire Mentorship courses, along with webinars!"
        label.numberOfLines = 2
        return label
    }()
    
    let walkthroughButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Close_Icon"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeWalkthrough), for: .touchUpInside)
        return button
    }()
    
    // MARK: End of walkthrough Elements
    
    let TabCellId = "tabCellId"
    let idArray = ["", "", "", "", "", "", "", ""]
    var data1 = [[String: AnyObject]]()
    
    let NewCellId = "newCellId"
    let MainCellId = "mainCellId"
    let headings = ["FOREX", "LIVE WEBINARS", "MILLIONAIRE \nMENTORSHIP"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        collectionViewOne.backgroundColor = .white
        let selectedItemIndexPath = IndexPath(item: 0, section: 0)
        collectionViewOne.selectItem(at: selectedItemIndexPath, animated: false, scrollPosition: [])
        collectionViewOne.isScrollEnabled = false
        collectionViewOne.register(TabMenuCell.self, forCellWithReuseIdentifier: NewCellId)
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        cellHolder.isPagingEnabled = true
        
//        removeEverything()
        cellHolder.register(TabCell.self, forCellWithReuseIdentifier: TabCellId)
        setupView()
        
        startAnimations()
        
        setupHorizontalBar()
    }
    
    func startAnimations() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.play()
        animationView.loopMode = .loop
        
        addSubview(pageOverlay)
        pageOverlay.addSubview(lotContainer)
        lotContainer.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            pageOverlay.topAnchor.constraint(equalTo: topAnchor),
            pageOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lotContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            lotContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: lotContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: lotContainer.centerYAnchor),
            ])
        
        // MARK: Launch loading function.
        DispatchQueue.main.async {
            
            // execute
            self.fetchEducationData()
            self.handleWalkthrough()
            
            
            //
        }
    }
    
    private func setupView() {
        addSubview(collectionViewOne)
        addSubview(cellHolder)
        addSubview(bottomSpacer)
        addSubview(topSpacer)
        
        
        NSLayoutConstraint.activate([
            collectionViewOne.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            collectionViewOne.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionViewOne.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionViewOne.heightAnchor.constraint(equalToConstant: 60),
            
            cellHolder.topAnchor.constraint(equalTo: collectionViewOne.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            topSpacer.heightAnchor.constraint(equalToConstant: 0),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            ])
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        cellHolder.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
    }
    
    // MARK: Handles walkthrough
    func handleWalkthrough() {
        let key: Bool? = KeychainWrapper.standard.bool(forKey: "SawEducationWalkthrough")
        if key == nil {
            openWalkthrough()
        }else if key == false {
            openWalkthrough()
        }else{
            print("already watched walkthrough")
        }
    }
    
    func setupWalkthrough() {
        let stackOne = UIStackView()
        stackOne.translatesAutoresizingMaskIntoConstraints = false
        stackOne.addArrangedSubview(walkthroughTitleLabel)
        stackOne.axis = .vertical
        stackOne.distribution = .equalSpacing
        stackOne.alignment = .leading
        
        // finish setting up walkthrough
        let v2 = walkthroughHolder
        v2.translatesAutoresizingMaskIntoConstraints = false
        let v3 = walkthroughButton
        let v4 = walkthroughBackgroundImage
        let v5 = stackOne
        v3.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(v2)
        v2.addSubview(v4)
        v2.addSubview(v5)
        v2.addSubview(v3)
        
        v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
        
        v3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        v3.widthAnchor.constraint(equalToConstant: 40).isActive = true
        v3.trailingAnchor.constraint(equalTo: v2.trailingAnchor, constant: -15).isActive = true
        v3.centerYAnchor.constraint(equalTo: v2.centerYAnchor).isActive = true
        
        v4.topAnchor.constraint(equalTo: v2.topAnchor).isActive = true
        v4.bottomAnchor.constraint(equalTo: v2.bottomAnchor).isActive = true
        v4.trailingAnchor.constraint(equalTo: v2.trailingAnchor).isActive = true
        v4.leadingAnchor.constraint(equalTo: v2.leadingAnchor).isActive = true
        
        v5.topAnchor.constraint(equalTo: v2.topAnchor, constant: 10).isActive = true
        v5.bottomAnchor.constraint(equalTo: v2.bottomAnchor, constant: -10).isActive = true
        v5.trailingAnchor.constraint(equalTo: v3.leadingAnchor, constant: -10).isActive = true
        v5.leadingAnchor.constraint(equalTo: v2.leadingAnchor, constant: 15).isActive = true
        
    }
    
    @objc func closeWalkthrough() {
        walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseOut, animations: {
            self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 300)
        }) { (_) in
            // here
            self.walkthroughHolder.removeFromSuperview()
        }
        KeychainWrapper.standard.set(true, forKey: "SawEducationWalkthrough")
        
    }
    
    @objc func openWalkthrough() {
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.setupWalkthrough()
            self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 300)
            
            UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseIn, animations: {
                self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (_) in
                // here
                
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == collectionViewOne {
            
        }else{
            let index = targetContentOffset.pointee.x / frame.width
            let indexPath = IndexPath(item: Int(index), section: 0)
            collectionViewOne.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
        }
        
        
        
    }
    
    func removeEverything() {
        KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
        KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
        KeychainWrapper.standard.removeObject(forKey: "selectedVideoLink")
        KeychainWrapper.standard.removeObject(forKey: "selectedVideoID")
        KeychainWrapper.standard.removeObject(forKey: "LessonId")
        KeychainWrapper.standard.removeObject(forKey: "SelectedLessonVideoURL")
    }
    
    var horoizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.init(red: 87/255, green: 213/255, blue: 233/255, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewOne.addSubview(horizontalBarView)
        
        horoizontalBarLeftAnchorConstraint = horizontalBarView.leadingAnchor.constraint(equalTo: collectionViewOne.leadingAnchor)
        
        horoizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: collectionViewOne.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: collectionViewOne.widthAnchor, multiplier: 0.33333333).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionViewOne {
            horoizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
        }else{
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewOne {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewCellId, for: indexPath) as! TabMenuCell
            cell.titleLabel.text = headings[indexPath.item]
            return cell
        }else{
            if indexPath.row == 0 {
                
            }else if indexPath.row == 1 {
                
            }else{
                
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCellId, for: indexPath) as! TabCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewOne {
            let x = CGFloat(indexPath.item) * frame.width / 3
            horoizontalBarLeftAnchorConstraint?.constant = x
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.collectionViewOne.layoutIfNeeded()
            }, completion: nil)
            self.scrollToMenuIndex(menuIndex: indexPath.item)
        }else{
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewOne {
            return CGSize(width: frame.width / 3, height: 60)
        }else{
            return CGSize(width: cellHolder.frame.width, height: cellHolder.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func fetchEducationData() {
        let myUrl = URL(string: "http://api.lionsofforex.com/education/list_courses")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
        // send http request to perform sign in
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    print(jsondata)
                    if let da = jsondata["success"].arrayObject {
                        self.data1 = da as! [[String : AnyObject]]
                        
                    }
                    if self.data1.count > 0 {
                        self.collectionViewOne.reloadData()
                        self.animationView.stop()
                        self.pageOverlay.removeFromSuperview()
                    }
                }
                
        }
    }
    
    
    
    
}
