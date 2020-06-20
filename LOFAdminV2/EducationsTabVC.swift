//
//  EducationsTab.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/12/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit

class EducationsTabVC: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        return cv
    }()

    var TabOne = [String: String]()
    let EducationTabCellId = "educationTabCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        cellHolder.register(EducationTabCell.self, forCellWithReuseIdentifier: EducationTabCellId)
        cellHolder.isPagingEnabled = true
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationTabCellId, for: indexPath) as! EducationTabCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
