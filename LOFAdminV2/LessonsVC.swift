//
//  LessonsVC.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/20/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class LessonsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    let menuTop: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bertoprofile")
        imageView.backgroundColor = .clear
        let newColor = UIColor.white.cgColor
        imageView.layer.borderColor = newColor
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let backHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = UIColor.init(red: 41/255, green: 47/255, blue: 59/255, alpha: 1)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let menuBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Signals"
        label.font = UIFont(name: "Monsterrat", size: 13)
        label.textAlignment = .center
        return label
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let cellImages = ["EducationGradient1", "EducationGradient2", "EducationGradient3", "EducationGradient4"]
    
    let MainTab = SwipingController()
    private let EducationLessonsCellId = "educationLessonsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainTab.menuBarLabel.text = "Education"
        
        cellHolder.dataSource = self
        cellHolder.delegate = self
        cellHolder.showsVerticalScrollIndicator = false
        cellHolder.register(LessonsCell.self, forCellWithReuseIdentifier: EducationLessonsCellId)
        setupTopBar()
        setupSignalCellHolder()
        setupMenuBar()
    }
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupSignalCellHolder() {
        view.addSubview(cellHolder)
        
        cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
//        view.addSubview(menuBottom)
        view.addSubview(menuTop)
        menuBar.addSubview(profileImage)
        menuBar.addSubview(menuBarLabel)
        menuBar.addSubview(backHomeButton)
        
        // set constraints for elements
        NSLayoutConstraint.activate([
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
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
            ])
        
    }
    
    func setupTopBar() {
        view.addSubview(topSpacer)
        view.addSubview(topView)
        view.addSubview(bottomSpacer)
        topView.addSubview(searchBar)
        
        
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
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            searchBar.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationLessonsCellId, for: indexPath) as! LessonsCell
        let mulArray = multiplierArray(array: cellImages, time: 100)
        cell.tabHolderImage.image = UIImage(named: mulArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationLessonsCellId, for: indexPath) as! LessonsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 9, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closePage() {
        dismiss(animated: true, completion: nil)
    }
    
}
