//
//  TeamMemberVC.swift
//  LionsofForexAdminApp
//
//  Created by UnoEast on 4/29/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import Lottie
import FirebaseFirestore

class TeamMembersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        layout.scrollDirection = .horizontal
        cv.translatesAutoresizingMaskIntoConstraints = false
//        layout.headerReferenceSize = CGSize(width: cv.frame.width, height: 30)
//        layout.sectionHeadersPinToVisibleBounds = true
        cv.isPagingEnabled = true
        cv.isScrollEnabled = true
        return cv
    }()
    
    let tabHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.init(red: 175/255, green: 182/255, blue: 198/255, alpha: 1)
        layout.scrollDirection = .horizontal
        cv.translatesAutoresizingMaskIntoConstraints = false
//        layout.headerReferenceSize = CGSize(width: cv.frame.width, height: 30)
//        layout.sectionHeadersPinToVisibleBounds = true
        cv.isScrollEnabled = true
        return cv
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "DashboardBackgroundImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    
    
    let topSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let pageOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        return view
        
    }()
    
    
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let menuBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    let menuBar: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = .black
        return tView
    }()
    
    let totalPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Admin"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Team Members"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.contentMode = .bottomLeft
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.setImage(UIImage(named: "mb"), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(goBackTapped), for: .touchUpInside)
        return button
    }()
    
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.setImage(UIImage(named: "addIcon"), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(addMember), for: .touchUpInside)
        return button
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
    
    
    fileprivate let tabCellId = "teamMemberTabCellId"
    fileprivate let ActivePageCellId = "ActivePageCellId"
    fileprivate let InctivePageCellId = "InctivePageCellId"
    fileprivate let UnregisteredPageCellId = "UnregisteredPageCellId"
    
    fileprivate let myArray = ["", "", "", "", "", "", "", "", "", ""]
    fileprivate let categoriesArray = ["Active", "Inactive", "Unregistered"]
    
    var data1 = [[String: AnyObject]]()
    var data2 = [[String: AnyObject]]()
    var data3 = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
//        cellHolder.addSubview(refresherControl)
        cellHolder.backgroundColor = .white
        cellHolder.register(ActivePageView.self, forCellWithReuseIdentifier: ActivePageCellId)
        cellHolder.register(InactivePageView.self, forCellWithReuseIdentifier: InctivePageCellId)
        cellHolder.register(UnregisteredPageView.self, forCellWithReuseIdentifier: UnregisteredPageCellId)
        
        cellHolder.isScrollEnabled = false
        
        tabHolder.delegate = self
        tabHolder.dataSource = self
        
        tabHolder.register(TeamMemberTabCell.self, forCellWithReuseIdentifier: tabCellId)
        
        view.backgroundColor = UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackTapped))
//        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openPopover), name: Notification.Name("OpenTeamMemberPopup"), object: nil)
        
        setupView()
        
        initCollection()
    }
    
    @objc func addMember() {
        let vc = NewMemberViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func initCollection() {
        let indexPath = IndexPath(row: 1, section: 0)
        cellHolder.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func openPopover() {
        let vc = ProfileOpenVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cellHolder {
            return 3
        }else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cellHolder {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivePageCellId, for: indexPath) as! ActivePageView
                cell.delegate = self
                return cell
            }else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InctivePageCellId, for: indexPath) as! InactivePageView
                cell.delegate = self
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnregisteredPageCellId, for: indexPath) as! UnregisteredPageView
                cell.delegate = self
                return cell
            }
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabCellId, for: indexPath) as! TeamMemberTabCell
            cell.titleLabel.text = categoriesArray[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cellHolder {
            return CGSize(width: cellHolder.frame.width, height: cellHolder.frame.height)
        }else{
            return CGSize(width: tabHolder.frame.width / 3, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cellHolder {
            print(indexPath)
        }else{
            cellHolder.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cellHolder {
            return 0
        }else{
            return 0
        }
    }
    
    private func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(menuBar)
        view.addSubview(topSpacer)
        view.addSubview(cellHolder)
        view.addSubview(tabHolder)
        topSpacer.addSubview(totalPipLabel)
        topSpacer.addSubview(secondPipLabel)
        topSpacer.addSubview(backButton)
        topSpacer.addSubview(addButton)
        view.addSubview(bottomSpacer)
        
        //
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topSpacer.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 50),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            totalPipLabel.leadingAnchor.constraint(equalTo: topSpacer.leadingAnchor, constant: 20),
            totalPipLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            secondPipLabel.leadingAnchor.constraint(equalTo: totalPipLabel.trailingAnchor, constant: 5),
            secondPipLabel.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: tabHolder.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            tabHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            tabHolder.heightAnchor.constraint(equalToConstant: 60),
            tabHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: topSpacer.trailingAnchor, constant: -20),
            
            addButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: backButton.leadingAnchor, constant: -10),
            
            ])
    }
    
    @objc func goBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

class TeamMemberCell: UICollectionViewCell {
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        view.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        return view
    }()
    
    let imageHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
        
    }()
    
    let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.alpha = 1
        view.layer.cornerRadius = 7.5
        view.heightAnchor.constraint(equalToConstant: 15).isActive = true
        view.widthAnchor.constraint(equalToConstant: 15).isActive = true
        view.isHidden = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.text = "Member"
        label.textColor = .black
        return label
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "---"
        label.textColor = .black
        return label
    }()
    
    let membershipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        label.text = "LOF Member"
        label.textColor = .gray
        return label
    }()

    let activeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .right
        label.text = "---"
        label.textColor = .gray
        return label
    }()
    
    let mobileStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    let mobileHolder: UIView = {
        let view = UIView()
        let con: CGFloat = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: con).isActive = true
//        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.layer.cornerRadius = con / 2
        view.backgroundColor = .red
        return view
    }()
    
    let mobileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        let stackViewOne = UIStackView()
        stackViewOne.addArrangedSubview(nameLabel)
        stackViewOne.addArrangedSubview(membershipLabel)
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.axis = .vertical
        stackViewOne.spacing = 1
        stackViewOne.alignment = .leading
        
        let stackViewTwo = UIStackView()
        stackViewTwo.addArrangedSubview(stackViewOne)
        stackViewTwo.addArrangedSubview(activeLabel)
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        stackViewTwo.axis = .horizontal
//        stackViewTwo.spacing = 1
//        stackViewTwo.alignment = .leading
        
        let stackViewThree = UIStackView()
        stackViewThree.addArrangedSubview(stackViewTwo)
        stackViewThree.addArrangedSubview(cityLabel)
        stackViewThree.translatesAutoresizingMaskIntoConstraints = false
        stackViewThree.axis = .vertical
        stackViewThree.spacing = 8
//        stackViewThree.alignment = .leading
        
        addSubview(bottomSpacer)
        addSubview(stackViewThree)
        addSubview(imageHolder)
        addSubview(mobileHolder)
        addSubview(mobileStatusLabel)
        mobileHolder.addSubview(mobileLabel)
        imageHolder.addSubview(profileImage)
        imageHolder.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            bottomSpacer.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackViewThree.leadingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: 10),
            stackViewThree.topAnchor.constraint(equalTo: imageHolder.topAnchor, constant: 0),
            stackViewThree.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            mobileStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            mobileStatusLabel.bottomAnchor.constraint(equalTo: mobileHolder.topAnchor, constant: -5),
            
            imageHolder.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            imageHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            indicator.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor, constant: -5),
            indicator.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor, constant: -2),
            
            profileImage.bottomAnchor.constraint(equalTo: imageHolder.bottomAnchor),
            profileImage.leadingAnchor.constraint(equalTo: imageHolder.leadingAnchor),
            profileImage.trailingAnchor.constraint(equalTo: imageHolder.trailingAnchor),
            profileImage.topAnchor.constraint(equalTo: imageHolder.topAnchor),
            
            mobileHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            mobileHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mobileHolder.leadingAnchor.constraint(equalTo: mobileLabel.leadingAnchor, constant: -5),
            
            mobileLabel.centerYAnchor.constraint(equalTo: mobileHolder.centerYAnchor, constant: 0),
            mobileLabel.trailingAnchor.constraint(equalTo: mobileHolder.trailingAnchor, constant: -5),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TeamMemberHeaderCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.text = "Active"
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TeamMemberTabCell: UICollectionViewCell {
    
    let holderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.widthAnchor.constraint(equalToConstant: 0.45).isActive = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(holderView)
        addSubview(spacerView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            holderView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            holderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            holderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            holderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            titleLabel.centerXAnchor.constraint(equalTo: holderView.centerXAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: holderView.centerYAnchor, constant: 0),
            
            spacerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            spacerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            spacerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TeamMembersVC: MembersDelegate {
    func memberSelected(_ member: LOFMember) {
        print(member)
        self.openMemberOptions(nil, "What would you like to do?", member)
    }
    
    func openMemberOptions(_ title: String?, _ message: String?, _ member: LOFMember) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let infoAction = UIAlertAction(title: "Account Info", style: .default) { (UIAlertAction) in
            print("ACCOUNT INFO")
            let vc = AccountInfoViewController()
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true, completion: nil)
            if let data = try? PropertyListEncoder().encode(member) {
                UserDefaults.standard.set(data, forKey: "selectedMember")
            }
        }
        alertController.addAction(infoAction)
        
        if member.active {
            let deactivateOption = UIAlertAction(title: "De-Activate", style: .default) { (UIAlertAction) in
                print("DEACTIVING")
                guard let url = URL(string: "http://api.lionsofforex.com/myaccount/change_status") else { return }
                let postString = ["email": member.email, "active": "0"]
                Alamofire.request(url, method: .post, parameters: postString, encoding: JSONEncoding.default).response { (response) in
                    if let result = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: result, options: .allowFragments) {
                            if let dict = json as? NSDictionary {
                                if dict["success"] != nil {
                                    let firebasePostString = ["active": "0"]
                                    Firestore.firestore().collection("members").document(member.id).getDocument { (snapshot, error) in
                                        if let snapshot = snapshot {
                                            if snapshot.exists {
                                                Firestore.firestore().collection("members").document(member.id).setData(firebasePostString, merge: true)
                                                self.showAlert("Alert", "Successfully deactivated user.")
                                                NotificationCenter.default.post(name: Notification.Name("ReloadMembers"), object: nil)
                                            } else {
                                                self.showAlert("Alert", "Successfully deactivated user.")
                                                NotificationCenter.default.post(name: Notification.Name("ReloadMembers"), object: nil)
                                            }
                                        }
                                    }
                                    
                                } else {
                                    self.showAlert("Alert", "Failed to deactivate user.")
                                }
                            }
                        }
                    }
                }
            }
            alertController.addAction(deactivateOption)
        } else {
            let activateOption = UIAlertAction(title: "Activate", style: .default) { (UIAlertAction) in
                print("ACTIVING")
                guard let url = URL(string: "http://api.lionsofforex.com/myaccount/change_status") else { return }
                let postString = ["email": member.email, "active": "1"]
                Alamofire.request(url, method: .post, parameters: postString, encoding: JSONEncoding.default).response { (response) in
                    if let result = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: result, options: .allowFragments) {
                            if let dict = json as? NSDictionary {
                                if dict["success"] != nil {
                                    let firebasePostString = ["active": "1"]
                                    Firestore.firestore().collection("members").document(member.id).getDocument { (snapshot, error) in
                                        if let snapshot = snapshot {
                                            if snapshot.exists {
                                                Firestore.firestore().collection("members").document(member.id).setData(firebasePostString, merge: true)
                                                self.showAlert("Alert", "Successfully activated user.")
                                                NotificationCenter.default.post(name: Notification.Name("ReloadMembers"), object: nil)
                                            } else {
                                                self.showAlert("Alert", "Successfully activated user.")
                                                NotificationCenter.default.post(name: Notification.Name("ReloadMembers"), object: nil)
                                            }
                                        } else {
                                            self.showAlert("Alert", "Successfully activated user.")
                                            NotificationCenter.default.post(name: Notification.Name("ReloadMembers"), object: nil)
                                        }
                                    }
                                } else {
                                    self.showAlert("Alert", "Failed to activate user.")
                                }
                            }
                        }
                    }
                }
            }
            alertController.addAction(activateOption)
        }
        
        if !member.firebase {
            let addOption = UIAlertAction(title: "Add to firebase", style: .default) { (UIAlertAction) in
                print("ADDING TO FB")
                
                var active: String {
                    if member.active {
                        return "0"
                    } else {
                        return "1"
                    }
                }
                
                let postString = ["id": member.id, "name": member.name, "mobileRegister": "0", "package": member.package.rawValue, "photo": member.photo, "country": member.country, "active": active, "experience": member.experience, "mobile": member.mobile, "auth_form": "0", "password": ""]
                
                Firestore.firestore().collection("members").document(member.id).setData(postString, merge: true) { (error) in
                    if error == nil {
                        // SUCCESS
                        self.showAlert("Alert", "Successfully created user in firebase database.")
                        NotificationCenter.default.post(name: Notification.Name("ReloadMembers"), object: nil)
                    }
                }
            }
            alertController.addAction(addOption)
        } else {
            let forceUnlock = UIAlertAction(title: "Force Unlock", style: .default) { (UIAlertAction) in
                
                var active: String {
                    if member.active {
                        return "0"
                    } else {
                        return "1"
                    }
                }
                
                let postString = ["active": "1", "mobileRegister": "0"]
                
                Firestore.firestore().collection("members").document(member.id).setData(postString, merge: true) { (error) in
                    if error == nil {
                        // SUCCESS
                        self.showAlert("Alert", "Successfully granted mobile user access.")
                        NotificationCenter.default.post(name: Notification.Name("ReloadMembers"), object: nil)
                    }
                }
            }
            alertController.addAction(forceUnlock)
        }
        
        let cancelActions = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelActions)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(_ title: String?, _ message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
