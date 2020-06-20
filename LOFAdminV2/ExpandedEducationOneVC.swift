//
//  ExpandedEducationOneVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class ExpandedEducationOneVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let GoBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("BACK", for: .normal)
        button.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userblankprofile")
        imageView.backgroundColor = .clear
        let newColor = UIColor.white.cgColor
        imageView.layer.borderColor = newColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
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
    
    let comingSoonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ComingSoon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let MainTab = SwipingController()
    private let EducationCourseCellId = "lessonCellId"
    var data1 = [[String: AnyObject]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEducationData()
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        cellHolder.showsVerticalScrollIndicator = false
        cellHolder.register(LessonsCell.self, forCellWithReuseIdentifier: EducationCourseCellId)
        setupView()
    }
    
    func fetchEducationData() {
        let myUrl = URL(string: "http://api.lionsofforex.com/education/lesson")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let selectedCourseId: String? = KeychainWrapper.standard.string(forKey: "selectedCourse")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        
        let postString = ["lesson": selectedCourseId, "email": accessText] as! [String: String]
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
                        self.cellHolder.reloadData()
                    }
                }
                
        }
    }
    
    func setupView() {
        view.addSubview(topSpacer)
        view.addSubview(menuBar)
        view.addSubview(menuTop)
        view.addSubview(cellHolder)
        menuBar.addSubview(profileImage)
        menuBar.addSubview(menuBarLabel)
        menuBar.addSubview(backHomeButton)
        menuBar.addSubview(headerImage)
        
        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 0),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
 
            cellHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 40),
            profileImage.widthAnchor.constraint(equalToConstant: 40),
            profileImage.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 20),
            profileImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            menuBarLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            menuBarLabel.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            menuBarLabel.widthAnchor.constraint(equalTo: menuBar.widthAnchor, multiplier: 0.4),
            backHomeButton.heightAnchor.constraint(equalToConstant: 40),
            backHomeButton.widthAnchor.constraint(equalToConstant: 40),
            backHomeButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            backHomeButton.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -20),
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 50),
            headerImage.widthAnchor.constraint(equalToConstant: 80),
            headerImage.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            headerImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationCourseCellId, for: indexPath) as! LessonsCell
        let iP = data1[indexPath.row]
        
        cell.tabTitle.text = iP["name"] as? String
        cell.tabDescription.text = iP["description"] as? String
        cell.iconImage.image = UIImage(named: "EducationCellIcon")
        cell.tabHolderImage.image = UIImage(named: "LessonCellBackground")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell selected")
        
        let selectedId = (data1[indexPath.row] as NSDictionary).object(forKey: "id") as? String
        let selectedIdName = (data1[indexPath.row] as NSDictionary).object(forKey: "name") as? String
        
        let saveSelectedCourse: Bool = KeychainWrapper.standard.set(selectedId!, forKey: "selectedCourse")
        let saveSelectedCourseName: Bool = KeychainWrapper.standard.set(selectedIdName!, forKey: "selectedCourseName")
        print (saveSelectedCourse)
        print(saveSelectedCourseName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 9, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        KeychainWrapper.standard.removeObject(forKey: "selectedCourseName")
        KeychainWrapper.standard.removeObject(forKey: "selectedCourse")
    }
    
    @objc func dismissPage() {
        KeychainWrapper.standard.removeObject(forKey: "selectedCourseName")
        KeychainWrapper.standard.removeObject(forKey: "selectedCourse")
        dismiss(animated: true, completion: nil)
    }
    
}
