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

protocol MembersDelegate: NSObjectProtocol {
    func memberSelected(_ member: LOFMember)
}

class ActivePageView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
    fileprivate let categoriesArray = ["Active", "Inactive", "Needs Attentions"]
    
    var data1 = [[String: AnyObject]]()
    var data2 = [[String: AnyObject]]()
    var data3 = [[String: AnyObject]]()
    
    var delegate: MembersDelegate?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.addSubview(refresherControl)
        
        cellHolder.register(TeamMemberCell.self, forCellWithReuseIdentifier: cellId)
        cellHolder.register(TeamMemberHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        
        setupView()
        startAnimations()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchMembers), name: Notification.Name("ReloadMembers"), object: nil)
        
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
                                
                                var active: Bool {
                                    if user_active == "0" {
                                        return false
                                    } else if user_active == "1" {
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
                                
                                var firebase = Bool()
                                
                                var mobileRegister = Bool()
                                
                                if active == true {
                                    Firestore.firestore().collection("members").document(id).getDocument { (snapshot, error) in
                                        if let snapshot = snapshot {
                                            if snapshot.exists {
                                                firebase = true
                                                if let data = snapshot.data() {
                                                    let mobile_register = data["mobileRegister"] as? String ?? "0"
                                                    
                                                    if mobile_register == "1"{
                                                        mobileRegister = true
                                                    } else {
                                                        mobileRegister = false
                                                    }
                                                    
                                                    let newMember = LOFMember(id: id, name: name, package: package, added: added, email: email, mobile: mobile, photo: photo, country: country, experience: experience, active: active, firebase: firebase, mobile_register: mobileRegister)
                                                    
                                                    allMembers.append(newMember)
                                                    
                                                    if allMembers.count > 0 {
                                                        let sorted = allMembers.filter({$0.active == true})
                                                        let alphabeticalSorted = sorted.sorted(by: {$0.name < $1.name})
                                                        self.lofMembers = alphabeticalSorted
                                                    }
                                                    
                                                }
                                            } else {
                                                firebase = false
                                                mobileRegister = false
                                                
                                                let newMember = LOFMember(id: id, name: name, package: package, added: added, email: email, mobile: mobile, photo: photo, country: country, experience: experience, active: active, firebase: firebase, mobile_register: mobileRegister)
                                                
                                                allMembers.append(newMember)
                                                
                                                if allMembers.count > 0 {
                                                    let sorted = allMembers.filter({$0.active == true})
                                                    let alphabeticalSorted = sorted.sorted(by: {$0.name < $1.name})
                                                    self.lofMembers = alphabeticalSorted
                                                }
                                            }
                                        } else {
                                            if let error = error {
                                                print(error.localizedDescription)
                                            }
                                            firebase = false
                                            
                                            let newMember = LOFMember(id: id, name: name, package: package, added: added, email: email, mobile: mobile, photo: photo, country: country, experience: experience, active: active, firebase: firebase, mobile_register: false)
                                            
                                            allMembers.append(newMember)
                                            
                                            if allMembers.count > 0 {
                                                let sorted = allMembers.filter({$0.active == true})
                                                let alphabeticalSorted = sorted.sorted(by: {$0.name < $1.name})
                                                self.lofMembers = alphabeticalSorted
                                            }
                                        }
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
        if section == 0 {
            if let lofMembers = lofMembers {
                if lofMembers.count > 0 {
                    return lofMembers.count
                }else{
                    return 0
                }
            } else {
                return 0
            }
        }else if section == 1 {
            if data2.count > 0 {
                return data2.count
            }else{
                return 0
            }
        }else{
            if data3.count > 0 {
                return data3.count
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TeamMemberCell
            if let lofMembers = lofMembers {
                let iP = lofMembers[indexPath.row]
                let name = iP.name
                let status = iP.active
                
                if iP.firebase {
                    cell.mobileStatusLabel.text = "Found in firebase"
                    cell.mobileStatusLabel.textColor = .green
                } else {
                    cell.mobileStatusLabel.text = "Not in firebase"
                    cell.mobileStatusLabel.textColor = .red
                }
                
                if iP.mobile_register {
                    cell.mobileLabel.text = "Mobile Register"
                    cell.mobileHolder.backgroundColor = .green
                } else {
                    cell.mobileLabel.text = "Platform Register"
                    cell.mobileHolder.backgroundColor = .red
                }
                
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
        }else if section == 1 {
            let iP = data2[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TeamMemberCell
            let name = iP["name"]?.description
            let status = iP["active"]?.description
            if let datestring = iP["added"]?.description {
                if let unixTimestamp = Double(datestring) {
                    let date = Date(timeIntervalSince1970: unixTimestamp)
                    //                let date = Date(timeIntervalSince1970: unixtimeInterval)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                    let strDate = dateFormatter.string(from: date)
                    cell.cityLabel.text = strDate
                }else{
                    cell.cityLabel.text = datestring
                }
            }
            let package = iP["package"]?.description
            let photo = iP["photo"]?.description
            
            if status == "0" {
                cell.activeLabel.text = "Inactive"
                cell.indicator.backgroundColor = .red
            }else if status == "1"{
                cell.activeLabel.text = "Active"
                cell.indicator.backgroundColor = .green
            }else{
                cell.activeLabel.text = "--"
                cell.indicator.backgroundColor = .yellow
            }
            
            if package == "14" {
                cell.membershipLabel.text = "Essentials Member"
            }else if package == "13"{
                cell.membershipLabel.text = "Signals Member"
            }else if package == "15"{
                cell.membershipLabel.text = "Advanced Member"
            }else if package == "31"{
                cell.membershipLabel.text = "Elite Member"
            }else{
                cell.membershipLabel.text = "Godfathered Member"
            }
            
            cell.nameLabel.text = name
            
            cell.profileImage.setImageWith(URL(string: "https://members.lionsofforex.com/\(photo ?? "")")!)
            
            return cell
        }else{
            let iP = data3[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TeamMemberCell
            let name = iP["name"]?.description
            let status = iP["active"]?.description
            if let datestring = iP["added"]?.description {
                if let unixTimestamp = Double(datestring) {
                    let date = Date(timeIntervalSince1970: unixTimestamp)
                    //                let date = Date(timeIntervalSince1970: unixtimeInterval)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                    let strDate = dateFormatter.string(from: date)
                    cell.cityLabel.text = strDate
                }else{
                    cell.cityLabel.text = datestring
                }
            }
            let package = iP["package"]?.description
            let photo = iP["photo"]?.description
            
            if status == "0" {
                cell.activeLabel.text = "Inactive"
                cell.indicator.backgroundColor = .red
            }else if status == "1"{
                cell.activeLabel.text = "Active"
                cell.indicator.backgroundColor = .green
            }else{
                cell.activeLabel.text = "--"
                cell.indicator.backgroundColor = .yellow
            }
            
            if package == "12" {
                cell.membershipLabel.text = "Essentials Member"
            }else if package == "13"{
                cell.membershipLabel.text = "Signals Member"
            }else if package == "14"{
                cell.membershipLabel.text = "Advanced Member"
            }else if package == "15"{
                cell.membershipLabel.text = "Elite Member"
            }else{
                cell.membershipLabel.text = "Godfathered Member"
            }
            
            cell.nameLabel.text = name
            
            cell.profileImage.setImageWith(URL(string: "https://members.lionsofforex.com/\(photo ?? "")")!)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId, for: indexPath) as! TeamMemberHeaderCell
            headerView.titleLabel.text = "Active"
            return headerView
        }else if section == 1 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId, for: indexPath) as! TeamMemberHeaderCell
            headerView.titleLabel.text = "Inactive"
            return headerView
        }else{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId, for: indexPath) as! TeamMemberHeaderCell
            headerView.titleLabel.text = "Unregistered"
            return headerView
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            if let lofMembers = lofMembers {
                let iP = lofMembers[indexPath.row]
                delegate?.memberSelected(iP)
            }
        }else if section == 1 {
            let iP = data2[indexPath.row]
            let id = iP["id"]?.description
            let package = iP["package"]?.description
            let email = iP["email"]?.description
            let name = iP["name"]?.description
            let photo = iP["photo"]?.description
            let mobile = iP["mobile"]?.description
            let country = iP["country"]?.description
            let experience = iP["forexExperience"]?.description
            let months = iP["months"]?.description
            let trial = iP["trial"]?.description
            let password = iP["password"]?.description
            let joined = iP["added"]?.description
            let status = iP["active"]?.description
            
            KeychainWrapper.standard.set(status ?? "", forKey: "SelectedMemberStatus")
            KeychainWrapper.standard.set(email ?? "", forKey: "SelectedMemberEmail")
            KeychainWrapper.standard.set(name ?? "", forKey: "SelectedMemberName")
            KeychainWrapper.standard.set(photo ?? "", forKey: "SelectedMemberPhoto")
            KeychainWrapper.standard.set(mobile ?? "", forKey: "SelectedMemberMobile")
            KeychainWrapper.standard.set(country ?? "", forKey: "SelectedMemberCountry")
            KeychainWrapper.standard.set(experience ?? "", forKey: "SelectedMemberExperience")
            KeychainWrapper.standard.set(months ?? "", forKey: "SelectedMemberMonths")
            KeychainWrapper.standard.set(trial ?? "", forKey: "SelectedMemberTrial")
            KeychainWrapper.standard.set(password ?? "", forKey: "SelectedMemberPassword")
            KeychainWrapper.standard.set(id ?? "", forKey: "SelectedMemberId")
            KeychainWrapper.standard.set(package ?? "", forKey: "SelectedMemberPackage")
            KeychainWrapper.standard.set(joined ?? "", forKey: "SelectedMemberJoined")
            
            DispatchQueue.main.async {
                print("selected: \(indexPath)")
                NotificationCenter.default.post(name: Notification.Name("OpenTeamMemberPopup"), object: nil)
            }
        }else{
            let iP = data3[indexPath.row]
            let id = iP["id"]?.description
            let package = iP["package"]?.description
            let email = iP["email"]?.description
            let name = iP["name"]?.description
            let photo = iP["photo"]?.description
            let mobile = iP["mobile"]?.description
            let country = iP["country"]?.description
            let experience = iP["forexExperience"]?.description
            let months = iP["months"]?.description
            let trial = iP["trial"]?.description
            let password = iP["password"]?.description
            let joined = iP["added"]?.description
            let status = iP["active"]?.description
            
            KeychainWrapper.standard.set(status ?? "", forKey: "SelectedMemberStatus")
            KeychainWrapper.standard.set(email ?? "", forKey: "SelectedMemberEmail")
            KeychainWrapper.standard.set(name ?? "", forKey: "SelectedMemberName")
            KeychainWrapper.standard.set(photo ?? "", forKey: "SelectedMemberPhoto")
            KeychainWrapper.standard.set(mobile ?? "", forKey: "SelectedMemberMobile")
            KeychainWrapper.standard.set(country ?? "", forKey: "SelectedMemberCountry")
            KeychainWrapper.standard.set(experience ?? "", forKey: "SelectedMemberExperience")
            KeychainWrapper.standard.set(months ?? "", forKey: "SelectedMemberMonths")
            KeychainWrapper.standard.set(trial ?? "", forKey: "SelectedMemberTrial")
            KeychainWrapper.standard.set(password ?? "", forKey: "SelectedMemberPassword")
            KeychainWrapper.standard.set(id ?? "", forKey: "SelectedMemberId")
            KeychainWrapper.standard.set(package ?? "", forKey: "SelectedMemberPackage")
            KeychainWrapper.standard.set(joined ?? "", forKey: "SelectedMemberJoined")
            
            DispatchQueue.main.async {
                print("selected: \(indexPath)")
                NotificationCenter.default.post(name: Notification.Name("OpenTeamMemberPopup"), object: nil)
            }
        }
    }
    
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
