//
//  TabCell.swift
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


class TabCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let IndividualCellId = "individualCellId"
    var data1 = [[String: AnyObject]]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        cellHolder.register(IndividualEducationCell.self, forCellWithReuseIdentifier: IndividualCellId)
        cellHolder.dataSource = self
        cellHolder.delegate = self
        cellHolder.showsVerticalScrollIndicator = false
        setupView()
        
        startAnimations()
        
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
            
            
            //
        }
    }
    
    func setupView() {
        addSubview(cellHolder)
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndividualCellId, for: indexPath) as! IndividualEducationCell
        let iP = data1[indexPath.row]
        
        
        cell.titleLabel.text = iP["name"] as? String
        cell.subheadingLabel.text = iP["description"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedId = (data1[indexPath.row] as NSDictionary).object(forKey: "id") as? String
        let selectedIdName = (data1[indexPath.row] as NSDictionary).object(forKey: "name") as? String
        print(selectedId!)
        
        KeychainWrapper.standard.set(selectedId!, forKey: "selectedCourse")
        KeychainWrapper.standard.set(selectedIdName!, forKey: "selectedCourseName")
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.openNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 9, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openNextPage() {
        print("open next page")
        
        // present view controller
        let mainController = EduTwoVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
            
        }
        
        topVC?.present(navigationController, animated: true, completion: nil)
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
                    if let da = jsondata["success"].dictionary {
//                        self.data1 = da as! [[String : Stri]]
//                        print(da)
                        let new = da["id"]!["72"].description
                        print("here is is \(new)")
   
                    }
                    if let daTwo = jsondata["success"].arrayObject {
                        self.data1 = daTwo as! [[String : AnyObject]]
                        
                    }
                    if self.data1.count > 0 {
                        self.cellHolder.reloadData()
                        self.animationView.stop()
                        self.pageOverlay.removeFromSuperview()
                    }
                }

        }
    }
    
    
}
