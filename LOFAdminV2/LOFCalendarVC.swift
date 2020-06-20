//
//  EventsView.swift
//  Lions of Forex App
//
//  Created by UNO EAST on 3/23/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class LOFCalendarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    let launchScreen: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let launchScreenIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "lofCalendar")
//        iv.image = UIImage(named: "Gradient")
        iv.heightAnchor.constraint(equalToConstant: 200).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return iv
    }()
    
    let backgroundOverlay: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "Gradient")
        return iv
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "miamiheader")
        return iv
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sliderHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lockView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isUserInteractionEnabled = false
        return view
    }()
    
    let calendarHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Miami"
        label.contentMode = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "Search"), for: .normal)
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.tintColor = .white
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setImage(UIImage(named:"Back_Icon"), for: .normal)
        button.layer.cornerRadius = 25
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 7)
        button.tintColor = .black
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()
    
    let joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Join Event", for: .normal)
        button.layer.cornerRadius = 25
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        button.layer.cornerRadius = 30
        button.isUserInteractionEnabled = false
//        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()
    
    let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Calendar"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        button.tintColor = .white
        button.backgroundColor = UIColor.init(red: 51/255, green: 54/255, blue: 64/255, alpha: 1)
        return button
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(width: cv.frame.size.width, height: 30)
        cv.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let calendarCellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.init(red: 51/255, green: 54/255, blue: 64/255, alpha: 1)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let categoriesHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let overButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "BUTTON"), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var events: [Event] = []
    
    let MainCellId = "mainCellId"
    let BlankHeaderCellId = "blankHeaderCellId"
    let CalendarCellId = "calendarCellId"
    let HeaderCellId = "headerCellId"
    let CategoriesCellId = "categoriesCellId"
    let calendarDates = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let calendarDays = ["20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let TopCategories = ["WHAT'S HOT" ,"ALL", "EVENTS", "1ON1", "POP UPS", "TOURS", "ETC"]
    let MiamiImages = ["miami11", "miami21", "miami31", "miami41", "miami51"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.translatesAutoresizingMaskIntoConstraints = false
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        calendarCellHolder.delegate = self
        calendarCellHolder.dataSource = self
        categoriesHolder.dataSource = self
        categoriesHolder.delegate = self
        
        cellHolder.isUserInteractionEnabled = false
        calendarCellHolder.isUserInteractionEnabled = false
        categoriesHolder.isUserInteractionEnabled = false
        
        cellHolder.register(MainCell.self, forCellWithReuseIdentifier: MainCellId)
        cellHolder.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCellId)
        
        calendarCellHolder.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCellId)
        calendarCellHolder.register(BlankHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BlankHeaderCellId)
        
        categoriesHolder.register(TopBarCategoriesCell.self, forCellWithReuseIdentifier: CategoriesCellId)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPage))
        headerHolder.addGestureRecognizer(tapGesture)
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startLaunch()
    }
    
    func startLaunchAnimation() {
        
        self.launchScreenIcon.alpha = 1
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
            self.launchScreenIcon.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.launchScreenIcon.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (_) in
            self.dismissAnimations()
        }
    }
    
    func dismissAnimations() {
        self.launchScreen.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseIn, animations: {
            self.launchScreen.alpha = 0
        }) { (finishes) in
            self.launchScreen.removeFromSuperview()
//            self.setupView()
        }
    }
    
    @objc func dismissPage() {
        print("new view")
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startLaunch() {
//        view.backgroundColor = .black
        view.addSubview(launchScreen)
        launchScreen.addSubview(launchScreenIcon)
        
        NSLayoutConstraint.activate([
            launchScreen.topAnchor.constraint(equalTo: view.topAnchor),
            launchScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            launchScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            launchScreenIcon.centerXAnchor.constraint(equalTo: launchScreen.centerXAnchor),
            launchScreenIcon.centerYAnchor.constraint(equalTo: launchScreen.centerYAnchor)
            ])
        
        self.launchScreenIcon.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.launchScreenIcon.transform = CGAffineTransform(translationX: 0, y: 50)
        
        DispatchQueue.main.async {
            self.startLaunchAnimation()
        }
    }
    
    func setupView() {
        view.addSubview(topView)
        view.addSubview(backgroundImage)
        view.addSubview(backgroundOverlay)
        view.addSubview(menuBar)
        view.addSubview(bottomSpacer)
        
        menuBar.addSubview(searchButton)
        menuBar.addSubview(joinButton)
        menuBar.addSubview(headerHolder)
        
        headerHolder.addSubview(titleLabel)
        
        view.addSubview(sliderHolder)
        view.addSubview(calendarHolder)
        
        sliderHolder.addSubview(categoriesHolder)
        
        calendarHolder.addSubview(calendarCellHolder)
        calendarHolder.addSubview(calendarButton)
        
        view.addSubview(cellHolder)
        view.addSubview(lockView)
        
        lockView.addSubview(backButton)
//        view.addSubview(overButton)
        
        NSLayoutConstraint.activate([
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: 85),
            
            sliderHolder.heightAnchor.constraint(equalToConstant: 40),
            sliderHolder.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            sliderHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sliderHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            calendarHolder.heightAnchor.constraint(equalToConstant: 62),
            calendarHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarHolder.topAnchor.constraint(equalTo: sliderHolder.bottomAnchor),
            calendarHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            calendarCellHolder.topAnchor.constraint(equalTo: calendarHolder.topAnchor),
            calendarCellHolder.bottomAnchor.constraint(equalTo: calendarHolder.bottomAnchor),
            calendarCellHolder.leadingAnchor.constraint(equalTo: calendarHolder.leadingAnchor),
            calendarCellHolder.trailingAnchor.constraint(equalTo: calendarButton.leadingAnchor),
            
            calendarButton.trailingAnchor.constraint(equalTo: calendarHolder.trailingAnchor),
            calendarButton.topAnchor.constraint(equalTo: calendarHolder.topAnchor),
            calendarButton.bottomAnchor.constraint(equalTo: calendarHolder.bottomAnchor),
            calendarButton.widthAnchor.constraint(equalToConstant: 60),
            
//            searchButton.heightAnchor.constraint(equalToConstant: 80),
//            searchButton.widthAnchor.constraint(equalToConstant: 80),
            searchButton.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 10),
            searchButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            
//            joinButton.heightAnchor.constraint(equalToConstant: 80),
//            joinButton.widthAnchor.constraint(equalToConstant: 80),
            joinButton.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -10),
            joinButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            
            headerHolder.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            headerHolder.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 20),
            headerHolder.trailingAnchor.constraint(equalTo: joinButton.leadingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: headerHolder.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerHolder.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerHolder.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerHolder.trailingAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: calendarHolder.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            categoriesHolder.topAnchor.constraint(equalTo: sliderHolder.topAnchor),
            categoriesHolder.bottomAnchor.constraint(equalTo: sliderHolder.bottomAnchor),
            categoriesHolder.leadingAnchor.constraint(equalTo: sliderHolder.leadingAnchor),
            categoriesHolder.trailingAnchor.constraint(equalTo: sliderHolder.trailingAnchor),
            
            lockView.topAnchor.constraint(equalTo: view.topAnchor),
            lockView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lockView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lockView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: lockView.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: lockView.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            
//            bottomSpacer.heightAnchor.constraint(equalToConstant: 0),
//            bottomSpacer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            bottomSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
//            overButton.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor, constant: -20),
//            overButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            //            overButton.bottomAnchor.constraint(equalTo: cellHolder.bottomAnchor, constant: -20),
            //            overButton.trailingAnchor.constraint(equalTo: cellHolder.trailingAnchor, constant: 20),
            
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cellHolder {
            return 5
        }else if collectionView == calendarCellHolder {
            return calendarDates.count
        }else{
            return TopCategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cellHolder {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCellId, for: indexPath) as! MainCell
            cell.backgroundImage.image = UIImage(named: MiamiImages[indexPath.row])
            return cell
        }else if collectionView == calendarCellHolder {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCellId, for: indexPath) as! CalendarCell
            cell.dateLabel.text = calendarDays[indexPath.row]
            cell.titleLabel.text = calendarDates[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCellId, for: indexPath) as! TopBarCategoriesCell
            cell.titleLabel.text = TopCategories[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == cellHolder {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCellId, for: indexPath) as! HeaderView
            headerView.frame.size.height = 30
            return headerView
        }else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BlankHeaderCellId, for: indexPath) as! BlankHeader
            headerView.frame.size.height = 30
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cellHolder {
            openNextPage()
        }else if collectionView == calendarCellHolder {
            
        }else{
            
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    //
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cellHolder {
            return CGSize(width: cellHolder.frame.width, height: 250)
        }else if collectionView == calendarCellHolder {
            return CGSize(width: 50, height: calendarCellHolder.frame.height)
        }else{
            if indexPath.row == 0 {
                return CGSize(width: 110, height: categoriesHolder.frame.height)
            }else{
                return CGSize(width: 80, height: categoriesHolder.frame.height)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cellHolder {
            return 0
        }else if collectionView == calendarCellHolder {
            return 0
        }else{
            return 0.5
        }
    }
    
    @objc func openNextPage() {
        // present view controller
//        let mainController = PageOneVC() as UIViewController
//        let navigationController = UINavigationController(rootViewController: mainController)
//        navigationController.navigationBar.isHidden = true
//        var topVC = UIApplication.shared.keyWindow?.rootViewController
//        while((topVC?.presentedViewController) != nil) {
//            topVC = topVC!.presentedViewController
//        }
//
//        topVC?.present(navigationController, animated: true, completion: nil)
        
    }

    
}

class MainCell: UICollectionViewCell {
    
    let componentHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let backgroundOverlay: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "RegionOverlay")
        return iv
    }()
    
    let locationImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.alpha = 0.4
        iv.image = UIImage(named: "Location")
        return iv
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
        iv.image = UIImage(named: "")
        return iv
    }()
    
    let indicatorImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "CD")
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.text = "LOF GLOBAL TOUR - 2019"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        label.text = "$49"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.text = "LOF PENTHOUSE   "
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let subLabelTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .gray
        label.text = "Miami"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        return label
    }()
    
    let locationHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        return view
    }()
    
    let labelHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 153/255, green: 173/255, blue: 208/255, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 90).isActive = true
        return view
    }()
    
    let iconHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    let innerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.text = "EVENT"
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        return label
    }()
    
    // Setup Label holder
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        backgroundColor = .yellow
        setupView()
    }
    
    func setupView() {
        let stackViewOne = UIStackView()
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.addArrangedSubview(subLabel)
        stackViewOne.addArrangedSubview(locationHolder)
        stackViewOne.addArrangedSubview(subLabelTwo)
        stackViewOne.axis = .horizontal
        stackViewOne.alignment = .leading
        stackViewOne.distribution = .equalSpacing
        
        
        addSubview(backgroundImage)
        addSubview(backgroundOverlay)
        addSubview(componentHolder)
        componentHolder.addSubview(subLabelTwo)
        componentHolder.addSubview(subLabel)
        componentHolder.addSubview(locationHolder)
        
        locationHolder.addSubview(locationImage)
        
        componentHolder.addSubview(titleLabel)
        componentHolder.addSubview(labelHolder)
        
        labelHolder.addSubview(iconHolder)
        iconHolder.addSubview(indicatorImage)
        labelHolder.addSubview(innerLabel)
        
        componentHolder.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backgroundOverlay.topAnchor.constraint(equalTo: topAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            componentHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            componentHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            componentHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            componentHolder.heightAnchor.constraint(equalToConstant: 90),
            
            subLabel.topAnchor.constraint(equalTo: componentHolder.topAnchor, constant: 10),
            subLabel.leadingAnchor.constraint(equalTo: componentHolder.leadingAnchor, constant: 10),
            
            locationHolder.topAnchor.constraint(equalTo: componentHolder.topAnchor, constant: 12),
            locationHolder.leadingAnchor.constraint(equalTo: subLabel.trailingAnchor, constant: 5),
            
            subLabelTwo.topAnchor.constraint(equalTo: componentHolder.topAnchor, constant: 10),
            subLabelTwo.leadingAnchor.constraint(equalTo: locationHolder.trailingAnchor, constant: 10),
            
            titleLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: componentHolder.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: componentHolder.trailingAnchor, constant: -10),
            
            labelHolder.bottomAnchor.constraint(equalTo: componentHolder.bottomAnchor, constant: -10),
            labelHolder.leadingAnchor.constraint(equalTo: componentHolder.leadingAnchor, constant: 10),
            
            priceLabel.trailingAnchor.constraint(equalTo: componentHolder.trailingAnchor, constant: -10),
            priceLabel.bottomAnchor.constraint(equalTo: componentHolder.bottomAnchor, constant: -10),
            
            locationImage.topAnchor.constraint(equalTo: locationHolder.topAnchor),
            locationImage.bottomAnchor.constraint(equalTo: locationHolder.bottomAnchor),
            locationImage.leadingAnchor.constraint(equalTo: locationHolder.leadingAnchor),
            locationImage.trailingAnchor.constraint(equalTo: locationHolder.trailingAnchor),
            
            iconHolder.leadingAnchor.constraint(equalTo: labelHolder.leadingAnchor, constant: 2),
            iconHolder.topAnchor.constraint(equalTo: labelHolder.topAnchor),
            iconHolder.bottomAnchor.constraint(equalTo: labelHolder.bottomAnchor),
            
            innerLabel.topAnchor.constraint(equalTo: labelHolder.topAnchor, constant: 0),
            innerLabel.bottomAnchor.constraint(equalTo: labelHolder.bottomAnchor, constant: 0),
            innerLabel.leadingAnchor.constraint(equalTo: iconHolder.trailingAnchor, constant: 5),
            innerLabel.trailingAnchor.constraint(equalTo: labelHolder.trailingAnchor, constant: 0),
            
            indicatorImage.topAnchor.constraint(equalTo: iconHolder.topAnchor, constant: 0),
            indicatorImage.bottomAnchor.constraint(equalTo: iconHolder.bottomAnchor, constant: 0),
            indicatorImage.leadingAnchor.constraint(equalTo: iconHolder.leadingAnchor, constant: 0),
            indicatorImage.trailingAnchor.constraint(equalTo: iconHolder.trailingAnchor, constant: 0),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

class CalendarCell: UICollectionViewCell {
    
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = "DAY"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "20"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HeaderView: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "TODAY, MARCH 23, 2019"
        label.textAlignment = .left
        label.textColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.init(red: 217/255, green: 222/255, blue: 233/255, alpha: 1)
        
        addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BlankHeader: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class TopBarCategoriesCell: UICollectionViewCell {
    
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.textColor = .lightGray
        return label
    }()
    
    let underView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 4).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(underView)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        underView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        underView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            //            iconImage.tintColor = isHighlighted ? UIColor.init(red: 200/255, green: 31/255, blue: 44/255, alpha: 1) : .lightGray
            titleLabel.textColor = isHighlighted ? .white : .gray
            underView.backgroundColor = isHighlighted ? .orange : .clear
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            //            iconImage.tintColor = isSelected ? UIColor.init(red: 200/255, green: 31/255, blue: 44/255, alpha: 1): .lightGray
            titleLabel.textColor = isSelected ? .white : .gray
            underView.backgroundColor = isSelected ? .orange : .clear
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
