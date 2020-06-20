//
//  EducationView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/6/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class ResourcesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let backgroundVCV: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundVC :UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    let topView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = .clear
        return tView
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar: UISearchBar = {
        let label = UISearchBar()
        label.barTintColor = .white
        label.enablesReturnKeyAutomatically = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setImage(UIImage(named: "SearchBarSearch_Icon"), for: .search, state: .normal)
        label.placeholder = "Search courses"
        label.backgroundColor = .white
        label.layer.cornerRadius = 25
        label.layer.masksToBounds = true
        return label
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
        label.text = "Access all LOF member documents, from Forex to Fast-Start Guides, sortable by category! "
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
    
    let cellImages = ["EducationGradient1", "EducationGradient2", "EducationGradient3", "EducationGradient4"]
    
    let MainTab = SwipingController()
    private let ResourcesCellId = "resourcesCellId"
    private let BlankResourcesCellId = "blankResourcesCellId"
    var data1 = [[String: AnyObject]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        MainTab.menuBarLabel.text = "Education"
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        cellHolder.showsVerticalScrollIndicator = false
        cellHolder.allowsMultipleSelection = false
        cellHolder.allowsSelection = true
        cellHolder.register(ResourcesCell.self, forCellWithReuseIdentifier: ResourcesCellId)
        cellHolder.register(BlankResourcesCell.self, forCellWithReuseIdentifier: BlankResourcesCellId)
        setupTopBar()
        setupSignalCellHolder()
//        fetchEducationData()
        //        setupInnerView()
        handleWalkthrough()
    }
    
    func setupInnerView() {
        addSubview(backgroundVC)
        addSubview(topSpacer)
        
        //        let window = UIApplication.shared.keyWindow!
        let vc = EducationInsideView(frame: backgroundVC.bounds)
        backgroundVC.addSubview(vc)
        
        //setup view
        backgroundVC.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundVC.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundVC.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundVC.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topSpacer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        topSpacer.leadingAnchor.constraint(equalTo: backgroundVC.leadingAnchor).isActive = true
        topSpacer.trailingAnchor.constraint(equalTo: backgroundVC.trailingAnchor).isActive = true
        topSpacer.topAnchor.constraint(equalTo: backgroundVC.safeAreaLayoutGuide.topAnchor).isActive = true
        bottomSpacer.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bottomSpacer.leadingAnchor.constraint(equalTo: backgroundVC.leadingAnchor).isActive = true
        bottomSpacer.trailingAnchor.constraint(equalTo: backgroundVC.trailingAnchor).isActive = true
        bottomSpacer.bottomAnchor.constraint(equalTo: backgroundVC.safeAreaLayoutGuide.bottomAnchor).isActive = true
        vc.topAnchor.constraint(equalTo: topSpacer.bottomAnchor).isActive = true
        vc.trailingAnchor.constraint(equalTo: backgroundVC.trailingAnchor).isActive = true
        vc.leadingAnchor.constraint(equalTo: backgroundVC.leadingAnchor).isActive = true
        vc.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
    }
    
    // MARK: Handles walkthrough
    func handleWalkthrough() {
        let key: Bool? = KeychainWrapper.standard.bool(forKey: "SawResourcesWalkthrough")
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
        
        KeychainWrapper.standard.set(true, forKey: "SawResourcesWalkthrough")
        
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
    
    
    func setupSignalCellHolder() {
        addSubview(cellHolder)
        
        cellHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor).isActive = true
        cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
    }
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    func setupTopBar() {
        addSubview(topSpacer)

        addSubview(bottomSpacer)

        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
//            topView.heightAnchor.constraint(equalToConstant: 70),
//            topView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
//            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            topView.widthAnchor.constraint(equalTo: widthAnchor),
//            searchBar.heightAnchor.constraint(equalToConstant: 50),
//            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            searchBar.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
//            searchBar.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            ])
    }
    
    func multiplierArray(array: [String], time: Int) -> [String] {
        var result = [String]()
        for _ in 0..<time {
            result += array
        }
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data1.count == 0 {
            return 3
        }else{
            return data1.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if data1.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlankResourcesCellId, for: indexPath) as! BlankResourcesCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResourcesCellId, for: indexPath) as! ResourcesCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if data1.count == 0 {
            print("blank resources selected")
        }else{
            print("resource selected")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 300
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 9, left: 0, bottom: 50, right: 0)
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
                    //                    print(jsondata)
                    if let da = jsondata["success"].arrayObject {
                        self.data1 = da as! [[String : AnyObject]]
                        
                    }
                    if self.data1.count > 0 {
                        self.cellHolder.reloadData()
                    }
                }
                
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
