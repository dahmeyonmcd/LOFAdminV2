//
//  NavbarView.swift
//  LionsofForexAdminApp
//
//  Created by UnoEast on 5/6/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class NavBarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        layout.scrollDirection = .vertical
        
        return cv
    }()
    
    fileprivate let cellId = "navbarCellId"
    fileprivate let cellIdTwo = "navbarCellIdTwo"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(NavBarHeaderCell.self, forCellWithReuseIdentifier: cellId)
        cellHolder.register(NavBarMainCell.self, forCellWithReuseIdentifier: cellIdTwo)
        
        backgroundColor = .clear
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(cellHolder)
        
        NSLayoutConstraint.activate([
            cellHolder.topAnchor.constraint(equalTo: topAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdTwo, for: indexPath) as! NavBarMainCell
            return cell
        }else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NavBarHeaderCell
            return cell
        }else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NavBarHeaderCell
            return cell
        }else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NavBarHeaderCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NavBarHeaderCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("upload tapped")
        }else if indexPath.row == 1 {
            print("finacials tapped")
        }else if indexPath.row == 2 {
            print("members tapped")
        }else if indexPath.row == 3 {
            print("admins tapped")
        }else{
            print("logout tapped")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return .init(width: cellHolder.frame.width, height: 250)
        }else if indexPath.row == 1 {
            return .init(width: cellHolder.frame.width, height: 100)
        }else if indexPath.row == 2 {
            return .init(width: cellHolder.frame.width, height: 100)
        }else if indexPath.row == 3 {
            return .init(width: cellHolder.frame.width, height: 100)
        }else{
            return .init(width: cellHolder.frame.width, height: 100)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NavBarHeaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NavBarMainCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
