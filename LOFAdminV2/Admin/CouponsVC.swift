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

class CouponsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        view.addTarget(self, action: #selector(requestData), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    let backgroundTint: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
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
        label.text = "Coupons"
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
        button.setImage(UIImage(named: "mb"), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(goBackTapped), for: .touchUpInside)
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "addB"), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(createNewCoupon), for: .touchUpInside)
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
    
    fileprivate let cellId = "couponMainCellId"
    fileprivate let headerCellId = "couponHeaderCellId"
    fileprivate let myArray = ["", "", "", "", "", "", "", "", "", ""]
    fileprivate let categoriesArray = ["Active", "Inactive", "Needs Attentions"]
    
    var data1 = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.addSubview(refresherControl)
        
        cellHolder.register(CouponCell.self, forCellWithReuseIdentifier: cellId)
        cellHolder.register(CouponHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        
        view.backgroundColor = UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackTapped))
        //        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openPopover), name: Notification.Name("OpenTeamMemberPopup"), object: nil)
        
        setupView()
        startAnimations()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc func createNewCoupon() {
        print("creating new coupon")
        let vc = CreateNewCouponVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func startAnimations() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.play()
        animationView.loopMode = .loop
        
        view.addSubview(pageOverlay)
        pageOverlay.addSubview(lotContainer)
        lotContainer.addSubview(animationView)
        //        pageOverlay.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            pageOverlay.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            pageOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            self.fetchCoupons()
            
            
            //
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @objc func requestData() {
        self.cellHolder.reloadData()
        fetchCoupons()
        
        print("requesting new coupons")
//
    }
    
    func fetchCoupons() {
        print("Fetching your member list")
        
        let myUrl = URL(string: "http://api.lionsofforex.com/adminv2/list_coupons")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": "delvanicci@gmail.com"]
        // send http request to perform sign in
        
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)

                    
                    if let innerJson = jsondata["success"].array {
                        //                        print(innerJson)
                        for results in innerJson {
                            //                            print(results)
                            if let active = results.dictionary {
//                                let isActive = active["active"]
                                self.data1.append(active as [String : AnyObject])
                                
                            }
                        }
                    }
                    
                    
                    if let er = jsondata["error"].string {
                        self.cellHolder.reloadData()
                        self.animationView.stop()
                        self.pageOverlay.removeFromSuperview()
                        print(er)
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
    
    @objc func openPopover() {
        view.addSubview(backgroundTint)
        view.addSubview(popupView)
        
        NSLayoutConstraint.activate([
            backgroundTint.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundTint.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundTint.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTint.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        self.popupView.transform = CGAffineTransform(translationX: 0, y: 0)
        
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(closePopover))
        popupView.addGestureRecognizer(closeGesture)
    }
    
    @objc func closePopover() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            self.backgroundTint.alpha = 1
            self.popupView.transform = CGAffineTransform(translationX: 0, y: 800)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                self.popupView.alpha = 0
                self.backgroundTint.alpha = 0
                self.popupView.removeFromSuperview()
                self.backgroundTint.removeFromSuperview()
            }, completion: { (_) in
                
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if data1.count > 0 {
                return data1.count
            }else{
                return 0
            }
        }else if section == 1 {
            if data1.count > 0 {
                return data1.count
            }else{
                return 0
            }
        }else{
            if data1.count > 0 {
                return data1.count
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iP = data1[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CouponCell
        let name = iP["name"]?.description
        let status = iP["status"]?.description
        let description = iP["description"]?.description
        let code = iP["code"]?.description
        let type = iP["type"]?.description
        let amount = iP["amount"]?.description
        
        cell.activeLabel.text = "\(type ?? "") \(amount ?? "")"
        
        if status == "0" {
            cell.indicator.backgroundColor = .red
        }else if status == "1" {
            cell.indicator.backgroundColor = .green
        }else{
            cell.indicator.backgroundColor = .yellow
        }

        cell.membershipLabel.text = "Code: \(code ?? "")"
        
        cell.cityLabel.text = description
        
        cell.nameLabel.text = name

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: \(indexPath)")
//        NotificationCenter.default.post(name: Notification.Name("OpenTeamMemberPopup"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: cellHolder.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId, for: indexPath) as! CouponHeaderCell
        headerView.titleLabel.text = "All Coupons"
        return headerView
    }
    
    private func setupView() {
        view.addSubview(menuBar)
        view.addSubview(topSpacer)
        view.addSubview(cellHolder)
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
            
            cellHolder.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: topSpacer.trailingAnchor, constant: -20),
            
            addButton.centerYAnchor.constraint(equalTo: topSpacer.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: backButton.leadingAnchor, constant: -10)
            ])
    }
    
    @objc func goBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

class CouponCell: UICollectionViewCell {
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        view.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        return view
    }()
    
//    let imageHolder: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .lightGray
//        view.alpha = 1
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 30
//        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        return view
//    }()
//
//    let profileImage: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.contentMode = .scaleAspectFit
//        return iv
//
//    }()
    
    let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.alpha = 1
        view.layer.cornerRadius = 7.5
        view.heightAnchor.constraint(equalToConstant: 15).isActive = true
        view.widthAnchor.constraint(equalToConstant: 15).isActive = true
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
        label.text = "Miami, FL"
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
        addSubview(indicator)
        
        NSLayoutConstraint.activate([
            bottomSpacer.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackViewThree.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackViewThree.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            stackViewThree.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            indicator.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            indicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CouponHeaderCell: UICollectionViewCell {
    
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
