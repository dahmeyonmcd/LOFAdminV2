//
//  EducationPageCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class EducationPageCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
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
    
    let cellImages = ["EducationGradient1", "EducationGradient2", "EducationGradient3", "EducationGradient4"]
    
    let MainTab = SwipingController()
    private let EducationCourseCellId = "educationCourseCell"
    var data1 = [[String: AnyObject]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        removePrevious()
//        backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
//
//
//        cellHolder.dataSource = self
//        cellHolder.delegate = self
//        cellHolder.showsVerticalScrollIndicator = false
//        cellHolder.allowsMultipleSelection = false
//        cellHolder.allowsSelection = true
//        cellHolder.register(EducationCell.self, forCellWithReuseIdentifier: EducationCourseCellId)
//        setupTopBar()
//        setupSignalCellHolder()
//        fetchEducationData()
//        setupInnerView()
        
        setupOverView()
    }
    
    func setupOverView() {
        
        let window = UIApplication.shared.keyWindow
        let v2 = NewEducationView(frame: (window?.bounds)!)
        v2.translatesAutoresizingMaskIntoConstraints = false
//        let v3 = TabCellMenu()
//        v3.translatesAutoresizingMaskIntoConstraints = false
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(topSpacer)
//        addSubview(bottomSpacer)
        addSubview(v2)
//        addSubview(v3)
        
        topSpacer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
//        bottomSpacer.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        v3.topAnchor.constraint(equalTo: topSpacer.bottomAnchor).isActive = true
//        v3.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        v3.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        v3.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        v2.topAnchor.constraint(equalTo: topSpacer.bottomAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        v2.alpha = 1
        
        
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
    
    
    
    func removePrevious() {
        KeychainWrapper.standard.removeObject(forKey: "selectedCourse")
        KeychainWrapper.standard.removeObject(forKey: "selectedCourseName")
        KeychainWrapper.standard.removeObject(forKey: "selectedLesson")
        KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
        KeychainWrapper.standard.removeObject(forKey: "selectedLessonDescription")
    }
    
    func setupSignalCellHolder() {
        addSubview(cellHolder)
        
        cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
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
        addSubview(topView)
        addSubview(bottomSpacer)
        topView.addSubview(searchBar)
        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            topView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.widthAnchor.constraint(equalTo: widthAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchBar.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            searchBar.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
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
        return data1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationCourseCellId, for: indexPath) as! EducationCell
        let iP = data1[indexPath.row]
        
        cell.tabTitle.text = iP["name"] as? String
        cell.tabDescription.text = iP["description"] as? String
        let mulArray = multiplierArray(array: cellImages, time: 100000)
        cell.tabHolderImage.image = UIImage(named: mulArray[indexPath.item])
        cell.iconImage.image = UIImage(named: "EducationCellIcon")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationCourseCellId, for: indexPath) as! EducationCell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 180
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 9, right: 0)
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
