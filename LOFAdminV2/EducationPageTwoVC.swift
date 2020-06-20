//
//  EducationPageTwoVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class EducationPageTwoVC: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let totalPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        label.text = "---"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var MainController = ExpandedVideoVC()
    
    var SelectedId: String?
    var SelectedName: String?
    
    let topView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = UIColor.init(red: 217/255, green: 222/255, blue: 233/255, alpha: 1)
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
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("BACK", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let MainTab = SwipingController()
    private let EducationCourseCellId = "lessonCellId"
    var data1 = [[String: AnyObject]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
//        translatesAutoresizingMaskIntoConstraints = false
        cellHolder.dataSource = self
        cellHolder.delegate = self
        cellHolder.showsVerticalScrollIndicator = false
        cellHolder.register(LessonsCell.self, forCellWithReuseIdentifier: EducationCourseCellId)
        let selectedCourseName: String? = KeychainWrapper.standard.string(forKey: "selectedCourseName")
        totalPipLabel.text = selectedCourseName
        fetchEducationData()
        setupTopBar()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.cellHolder.reloadData()
        }
    }
    
//    override func didMoveToSuperview() {
//        fetchEducationData()
//        setupTopBar()
//    }
    
    override func didMoveToWindow() {

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
        
        let selectedId = (data1[indexPath.row] as NSDictionary).object(forKey: "video") as? String
        let selectedIdName = (data1[indexPath.row] as NSDictionary).object(forKey: "name") as? String
        let selectedIdAuthor = (data1[indexPath.row] as NSDictionary).object(forKey: "author") as? String
        let selectedKeychainId: String? = KeychainWrapper.standard.string(forKey: "LessonId")

        if selectedIdAuthor == nil {
            KeychainWrapper.standard.set("Berto Delvanicci", forKey: "LessonAuthor")
            
        }else if selectedIdAuthor == "" {
            KeychainWrapper.standard.set("Berto Delvanicci", forKey: "LessonAuthor")
            
        }else {
            KeychainWrapper.standard.set(selectedIdAuthor!, forKey: "LessonAuthor")
        }
        
        if selectedKeychainId != nil {
            KeychainWrapper.standard.removeObject(forKey: "LessonId")
            KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
            DispatchQueue.main.async {
                KeychainWrapper.standard.set(selectedId!, forKey: "LessonId")
                KeychainWrapper.standard.set(selectedIdName!, forKey: "selectedLessonName")
                DispatchQueue.main.async {
                    self.openNextPage()
                }
            }
            
        }else{
            KeychainWrapper.standard.removeObject(forKey: "LessonId")
            KeychainWrapper.standard.removeObject(forKey: "selectedLessonName")
            DispatchQueue.main.async {
                KeychainWrapper.standard.set(selectedId!, forKey: "LessonId")
                KeychainWrapper.standard.set(selectedIdName!, forKey: "selectedLessonName")
                DispatchQueue.main.async {
                    self.openNextPage()
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
    }
    
    func setupTopBar() {
        addSubview(topSpacer)
        addSubview(topView)
        addSubview(bottomSpacer)
        topView.addSubview(closeButton)
        topView.addSubview(totalPipLabel)
        addSubview(cellHolder)
        
        
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
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            closeButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            totalPipLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            totalPipLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            totalPipLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -20)
            
            ])
    }
    
    func fetchEducationData() {
        let myUrl = URL(string: "http://api.lionsofforex.com/education/list_lessons")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let selectedCourseId: String? = KeychainWrapper.standard.string(forKey: "selectedCourse")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        
        let postString = ["course": selectedCourseId, "email": accessText] as! [String: String]
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
    
    @objc func openNextPage() {
        print("open next page")
        
        // present view controller
        let mainController = ExpandedVideoVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
            
        }
        
        topVC?.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func closePage() {
        KeychainWrapper.standard.removeObject(forKey: "selectedCourseName")
        KeychainWrapper.standard.removeObject(forKey: "selectedCourse")
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = 0
            }) { (finish) in
                self.removeFromSuperview()
            }
        }
    }
    
}
