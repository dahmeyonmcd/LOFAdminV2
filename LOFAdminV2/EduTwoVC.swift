//
//  EduTwoVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/21/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import Lottie

class EduTwoVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    let menuBar: UIView = {
        let menu = UIView()
        menu.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
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
        button.tintColor = .white
//        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let backgroundViewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = UIColor.init(red: 217/255, green: 222/255, blue: 233/255, alpha: 1)
        return tView
    }()
    
    let graphButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "CopyIcon"), for: .normal)
        button.tintColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let totalAffiliatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "4"
        label.contentMode = .left
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 23
        view.clipsToBounds = true
        return view
    }()
    
    let textField: TextFieldVC = {
        let view = TextFieldVC()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = .black
        view.textAlignment = .left
        view.isEnabled = true
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    let totalPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        label.text = "---"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondAffiliatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "total affiliates"
        label.contentMode = .left
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let EducationCourseCellId = "lessonCellId"
    var data1 = [[String: AnyObject]]()
    let EarnedThisMonth = "earnedThisMonth"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuBar()
        setupLayout()
        
        startAnimations()
//        profileImageFetch()
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        
        let selectedCourseName: String? = KeychainWrapper.standard.string(forKey: "selectedCourseName")
        totalPipLabel.text = selectedCourseName
        
        cellHolder.backgroundColor = .clear
        cellHolder.register(IndividualEducationCell.self, forCellWithReuseIdentifier: EducationCourseCellId)
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
            
            // execute
            self.fetchEducationData()
            
            
            //
        }
    }
    
    func loadAffiliateLink() {
        let mainAffiliateLink: String? = KeychainWrapper.standard.string(forKey: "affiliatesLink")
        self.textField.text = mainAffiliateLink
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addSubview(menuTop)
//        menuBar.addSubview(profileImage)
//        menuBar.addSubview(backHomeButton)
        menuBar.addSubview(headerImage)
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
//            profileImage.heightAnchor.constraint(equalToConstant: 40),
//            profileImage.widthAnchor.constraint(equalToConstant: 40),
//            profileImage.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 20),
//            profileImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            
//            backHomeButton.heightAnchor.constraint(equalToConstant: 40),
//            backHomeButton.widthAnchor.constraint(equalToConstant: 40),
//            backHomeButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
//            backHomeButton.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -20),
            
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
    
    func profileImageFetch() {
        let imageUrl: String? = KeychainWrapper.standard.string(forKey: "profileImageUrl")
        
        if imageUrl == nil {
            self.profileImage.image = UIImage(named: "userblankprofile-1")
        }else{
            let profileString = ("https://members.lionsofforex.com\(imageUrl ?? "")") as String
            print(profileString)
            
            self.profileImage.setImageFromURl(stringImageUrl: profileString)
        }
        
        
    }
    
    func setupLayout() {
        view.addSubview(backgroundViewColor)
//        backgroundViewColor.addSubview(menuBar)
//        view.addSubview(menuTop)
        view.addSubview(topSpacer)
        view.addSubview(bottomSpacer)
        view.addSubview(topView)
        topView.addSubview(totalPipLabel)

        backgroundViewColor.addSubview(cellHolder)
        topView.addSubview(closeButton)
//        menuTop.addSubview(headerImage)
        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            backgroundViewColor.topAnchor.constraint(equalTo: topView.bottomAnchor),
            backgroundViewColor.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            backgroundViewColor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundViewColor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            menuBar.heightAnchor.constraint(equalToConstant: 60),
//            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
//            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
//            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSpacer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 0),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 0),
            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            topView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            closeButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),

            
            totalPipLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            totalPipLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            totalPipLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -20),
            
//            graphButton.widthAnchor.constraint(equalToConstant: 36),
//            graphButton.heightAnchor.constraint(equalToConstant: 36),
//            graphButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
//            graphButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
//            textHolder.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 10),
//            textHolder.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
//            textHolder.trailingAnchor.constraint(equalTo: graphButton.leadingAnchor, constant: -10),
//            textHolder.heightAnchor.constraint(equalToConstant: 45),
//            textField.leadingAnchor.constraint(equalTo: textHolder.leadingAnchor),
//            textField.trailingAnchor.constraint(equalTo: textHolder.trailingAnchor),
//            textField.topAnchor.constraint(equalTo: textHolder.topAnchor),
//            textField.bottomAnchor.constraint(equalTo: textHolder.bottomAnchor),
            cellHolder.topAnchor.constraint(equalTo: backgroundViewColor.topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: backgroundViewColor.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: backgroundViewColor.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: backgroundViewColor.trailingAnchor),
//            closeButton.widthAnchor.constraint(equalToConstant: 36),
//            closeButton.heightAnchor.constraint(equalToConstant: 36),
//            closeButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
//            closeButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
//            headerImage.heightAnchor.constraint(equalToConstant: 50),
//            headerImage.widthAnchor.constraint(equalToConstant: 80),
//            headerImage.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
//            headerImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor)
            ])
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationCourseCellId, for: indexPath) as! IndividualEducationCell
        let iP = data1[indexPath.row]
        
        cell.titleLabel.text = iP["name"] as? String
        cell.subheadingLabel.text = iP["description"] as? String
//        cell.iconImage.image = UIImage(named: "EducationCellIcon")
//        cell.tabHolderImage.image = UIImage(named: "LessonCellBackground")
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
        return CGSize(width: cellHolder.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 9, right: 0)
    }
    
    func setupTopBar() {
        view.addSubview(topSpacer)
        view.addSubview(topView)
        view.addSubview(bottomSpacer)
        topView.addSubview(closeButton)
        topView.addSubview(totalPipLabel)
        view.addSubview(cellHolder)
        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 60),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            topView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            closeButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
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
                        self.animationView.stop()
                        self.pageOverlay.removeFromSuperview()
                    }
                }
                
        }
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
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
