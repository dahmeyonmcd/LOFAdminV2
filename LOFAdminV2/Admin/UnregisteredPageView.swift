//
//  ActivePageView.swift
//  LionsofForexAdminApp
//
//  Created by UnoEast on 5/30/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import Lottie
import SwiftyJSON
import FirebaseFirestore

class UnregisteredPageView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        layout.scrollDirection = .vertical
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.headerReferenceSize = CGSize(width: cv.frame.width, height: 30)
        layout.sectionHeadersPinToVisibleBounds = true
        cv.isScrollEnabled = true
        
        return cv
    }()
    
    let refresherControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return view
    }()
    
    let pageOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        return view
    }()
    
    let backgroundTint: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    let popupView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        view.widthAnchor.constraint(equalToConstant: 350).isActive = true
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
    
    fileprivate let cellId = "teamMemberCellId"
    
    fileprivate let headerCellId = "teamMemberHeaderCellId"
    fileprivate let categoriesArray = ["Active", "Inactive", "Unregistered"]
    
    var data1 = [[String: AnyObject]]()
    
    var lofMembers: [LOFMember]? {
        didSet {
            if let lofMembers = lofMembers {
                if lofMembers.count > 0 {
                    self.cellHolder.reloadData()
                    self.refresherControl.endRefreshing()
                    self.animationView.stop()
                    self.pageOverlay.removeFromSuperview()
                }
            }
        }
    }
    
    var delegate: MembersDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.addSubview(refresherControl)
        
        cellHolder.register(TeamMemberCell.self, forCellWithReuseIdentifier: cellId)
        cellHolder.register(TeamMemberHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchMembers), name: Notification.Name("ReloadMembers"), object: nil)
        
        setupView()
        startAnimations()
        
    }
    
    private func setupView() {
        addSubview(cellHolder)
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func startAnimations() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.play()
        animationView.loopMode = .loop
        
        addSubview(pageOverlay)
        pageOverlay.addSubview(lotContainer)
        lotContainer.addSubview(animationView)
        //        pageOverlay.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            pageOverlay.topAnchor.constraint(equalTo: topAnchor),
            pageOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lotContainer.centerXAnchor.constraint(equalTo: pageOverlay.centerXAnchor),
            lotContainer.centerYAnchor.constraint(equalTo: pageOverlay.centerYAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: lotContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: lotContainer.centerYAnchor),
            
            //            backButton.centerYAnchor.constraint(equalTo: pageOverlay.safeAreaLayoutGuide.topAnchor, constant: 20),
            //            backButton.trailingAnchor.constraint(equalTo: pageOverlay.trailingAnchor, constant: -20)
            ])
        
        // MARK: Launch loading function.
        DispatchQueue.main.async {
            
            // execute
            self.fetchMembers()
            
            
            //
        }
    }
    
    @objc func requestData() {
        self.cellHolder.reloadData()
        fetchMembers()
        
        print("requesting new members")
    }
    
    @objc func fetchMembers() {
        print("Fetching your member list")
        
        let myUrl = URL(string: "http://api.lionsofforex.com/adminv2/all_members")
        let postString = ["email": "delvanicci@gmail.com"]
        // send http request to perform sign in
        
        var allMembers: [LOFMember] = []
        var activeMembers: Int = 0
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    
                    if let innerJson = jsondata["success"].array {
                        for results in innerJson {
                            if let dict = results.dictionaryObject {
                                
                                let id = dict["id"] as? String ?? ""
                                let name = dict["name"] as? String ?? ""
                                let email = dict["email"] as? String ?? ""
                                let user_active = dict["active"] as? String ?? "0"
                                let user_package = dict["package"] as? String ?? "0"
                                let experience = dict["experience"] as? String ?? ""
                                let mobile = dict["mobile"] as? String ?? ""
                                let country = dict["country"] as? String ?? "USA"
                                let added = dict["added"] as? String ?? "0"
                                let photo = dict["photo"] as? String ?? ""
                                let verificated = dict["verificated"] as? String ?? "0"
                                
                                var active: Bool {
                                    if user_active == "0" {
                                        return false
                                    } else if user_active == "1" {
                                        return true
                                    } else {
                                        return false
                                    }
                                }
                                
                                var registered: Bool {
                                    if verificated == "0" {
                                        return false
                                    } else if verificated == "1" {
                                        activeMembers = activeMembers + 1
                                        return true
                                    } else {
                                        return false
                                    }
                                }
                                
                                var package: LOFMember.LOFPackage {
                                    if user_package == "13" {
                                        return .Signals
                                    } else if user_package == "14" {
                                        return .Essentials
                                    } else if user_package == "15" {
                                        return .Advanced
                                    } else if user_package == "31" {
                                        return .Elite
                                    } else {
                                        return .Unknown
                                    }
                                }
                                
                                if registered == false {
                                    
                                    let newMember = LOFMember(id: id, name: name, package: package, added: added, email: email, mobile: mobile, photo: photo, country: country, experience: experience, active: active, firebase: false, mobile_register: false)
                                    
                                    allMembers.append(newMember)
                                    
                                    if allMembers.count > 0 {
                                        let alphabeticalSorted = allMembers.sorted(by: {$0.name < $1.name})
                                        self.lofMembers = alphabeticalSorted
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    if jsondata["error"].string != nil {
                        self.cellHolder.reloadData()
                        self.animationView.stop()
                        self.pageOverlay.removeFromSuperview()
                    }
                    
                    if self.data1.count > 0 {
                        self.cellHolder.reloadData()
                        self.refresherControl.endRefreshing()
                        self.animationView.stop()
                        self.pageOverlay.removeFromSuperview()
                    }
                }
                
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let lofMembers = lofMembers {
            if lofMembers.count > 0 {
                return lofMembers.count
            }else{
                return 0
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TeamMemberCell
        if let lofMembers = lofMembers {
            let iP = lofMembers[indexPath.row]
            let name = iP.name
            let status = iP.active
            
            cell.mobileHolder.isHidden = true
            cell.mobileStatusLabel.text = ""
            
            if let unixTimestamp = Double(iP.added) {
                let date = Date(timeIntervalSince1970: unixTimestamp)
                //                let date = Date(timeIntervalSince1970: unixtimeInterval)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "MMMM dd, yyyy" //Specify your format that you want
                let strDate = dateFormatter.string(from: date)
                cell.cityLabel.text = strDate
            }else{
                cell.cityLabel.text = iP.added
            }
            
            let package = iP.package
            let photo = iP.photo
            
            if status == false {
                cell.activeLabel.text = "Inactive"
                cell.indicator.backgroundColor = .red
            }else {
                cell.activeLabel.text = "Active"
                cell.indicator.backgroundColor = .green
            }
            
            if package == .Essentials {
                cell.membershipLabel.text = "Essentials Member"
            }else if package == .Signals {
                cell.membershipLabel.text = "Signals Member"
            }else if package == .Advanced {
                cell.membershipLabel.text = "Advanced Member"
            }else if package == .Elite {
                cell.membershipLabel.text = "Elite Member"
            }else{
                cell.membershipLabel.text = "Godfathered Member"
            }
            
            cell.nameLabel.text = name
            
            if let url = URL(string: "https://members.lionsofforex.com/\(photo)") {
                cell.profileImage.kf.setImage(with: url)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId, for: indexPath) as! TeamMemberHeaderCell
        headerView.titleLabel.text = "Inactive"
        return headerView
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let lofMembers = lofMembers {
            let iP = lofMembers[indexPath.row]
            delegate?.memberSelected(iP)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
