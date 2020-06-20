//
//  SignalOpenVC.swift
//  Lions of Forex
//
//  Created by UnoEast on 5/29/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignalOpenVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        
        return mb
    }()
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        layout.scrollDirection = .vertical
        return cv
    }()
    
    // MARK: Loading
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
    // MARK: END LOADING
    
    let menuBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        //        imageView.isHidden = true
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
        button.setImage(UIImage(named: "backbuttonArrow"), for: .normal)
        //        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let menuBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    
    private let cellId = "ExpandedTopCellId"
    private let bottomCellId = "ExpandedBottomCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellHolder.delegate = self
        cellHolder.dataSource = self
        
        cellHolder.register(SignalOpenTopCell.self, forCellWithReuseIdentifier: cellId)
        cellHolder.register(SignalOpenBottomCell.self, forCellWithReuseIdentifier: bottomCellId)
        
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(dashboardTapped), name: Notification.Name("CloseThisThangJawn"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openEditVC), name: Notification.Name("OpenSignalEdit"), object: nil)
        
        setupMenuBar()
        
    }
    
    @objc func openEditVC() {
        let vc = EditSignalVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addSubview(menuTop)
        view.addSubview(cellHolder)
        menuBar.addSubview(menuBarLabel)
        menuBar.addSubview(backHomeButton)
        menuBar.addSubview(headerImage)
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: 50),
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            menuBarLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            menuBarLabel.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            menuBarLabel.widthAnchor.constraint(equalTo: menuBar.widthAnchor, multiplier: 0.4),
            
            backHomeButton.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            backHomeButton.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 10),
            
            menuTop.topAnchor.constraint(equalTo: view.topAnchor),
            menuTop.bottomAnchor.constraint(equalTo: menuBar.topAnchor),
            menuTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerImage.heightAnchor.constraint(equalToConstant: 40),
            headerImage.widthAnchor.constraint(equalToConstant: 70),
            headerImage.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            headerImage.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            
            cellHolder.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            cellHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cellHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            ])
        
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 1000
        
        let size = CGSize(width: cellHolder.frame.width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
    }
    
    @objc func closePage() {
        KeychainWrapper.standard.removeObject(forKey: "selectedSymbol")
        KeychainWrapper.standard.removeObject(forKey: "selectedType")
        KeychainWrapper.standard.removeObject(forKey: "selectedSignalDate")
        KeychainWrapper.standard.removeObject(forKey: "selectedPips")
        KeychainWrapper.standard.removeObject(forKey: "selectedSL")
        KeychainWrapper.standard.removeObject(forKey: "selectedTP")
        KeychainWrapper.standard.removeObject(forKey: "selectedEntry")
        KeychainWrapper.standard.removeObject(forKey: "selectedUpdate")
        KeychainWrapper.standard.removeObject(forKey: "selectedStyle")
        KeychainWrapper.standard.removeObject(forKey: "selectedTP2")
        KeychainWrapper.standard.removeObject(forKey: "selectedID")
        KeychainWrapper.standard.removeObject(forKey: "selectedRiskReward")
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SignalOpenTopCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bottomCellId, for: indexPath) as! SignalOpenBottomCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            if let commentStr = KeychainWrapper.standard.string(forKey: "selectedUpdate") {
                var height: CGFloat = 400
                
                //we are just measuring height so we add a padding constant to give the label some room to breathe!
                let padding: CGFloat = 30
                
                //estimate each cell's height
                height = estimateFrameForText(text: commentStr).height + padding
                
                return CGSize(width: cellHolder.frame.width, height: 550 + height)
            }else{
                 return .init(width: cellHolder.frame.width, height: 800)
            }
//            return .init(width: cellHolder.frame.width, height: 800)
        }else{
            return .init(width: cellHolder.frame.width, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func dashboardTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class SignalOpenTopCell: UICollectionViewCell {
    
    let cardBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 0
        return view
    }()
    
    
    
    let SymbolTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Symbol"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let UpdateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Update"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let TypeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Trade Type"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let DateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let PipTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Pips"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "S/L"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "TP 1"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpTwoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "TP 2"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let TradeStyleTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Trade Style"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let EntryTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Entry"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let riskRewardTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Risk/reward"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let symbolAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "symbol value"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "Symbol"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let riskRewardAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "Risk/reward"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pipAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let entryAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpTwoAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let styleAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let updateAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
//    let closeViewButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Close", for: .normal)
//        button.backgroundColor = .green
//        button.layer.cornerRadius = 8
//        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
        
        loadSignalData()
        
        setupLayout()
    }
    
    func loadSignalData() {
        let mainSymbol: String? = KeychainWrapper.standard.string(forKey: "selectedSymbol")
        let mainType: String? = KeychainWrapper.standard.string(forKey: "selectedType")
        let mainDate: String? = KeychainWrapper.standard.string(forKey: "selectedSignalDate")
        let mainPips: String? = KeychainWrapper.standard.string(forKey: "selectedPips")
        let mainSL: String? = KeychainWrapper.standard.string(forKey: "selectedSL")
        let mainTP: String? = KeychainWrapper.standard.string(forKey: "selectedTP")
        let mainTP2: String? = KeychainWrapper.standard.string(forKey: "selectedTP2")
        let mainEntry: String? = KeychainWrapper.standard.string(forKey: "selectedEntry")
        let mainStyle: String? = KeychainWrapper.standard.string(forKey: "selectedStyle")
        let mainUpdate: String? = KeychainWrapper.standard.string(forKey: "selectedUpdate")
        let mainRiskReward: String? = KeychainWrapper.standard.string(forKey: "selectedRiskReward")
        //        let thPips:Int? = Int(mainPips!)
        
        if mainPips! == "-" {
            pipAmountLabel.text = ("\(mainPips ?? "") pips")
            pipAmountLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else {
            pipAmountLabel.text = ("\(mainPips ?? "") pips")
            pipAmountLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        
        symbolAmountLabel.text = mainSymbol
        typeAmountLabel.text = mainType
        dateAmountLabel.text = mainDate
        slAmountLabel.text = mainSL
        tpAmountLabel.text = mainTP
        tpTwoAmountLabel.text = mainTP2
        styleAmountLabel.text = mainStyle
        entryAmountLabel.text = mainEntry
        updateAmountLabel.text = mainUpdate
        riskRewardAmountLabel.text = mainRiskReward
    }
    
    private func setupLayout() {
        let symbolStackView = UIStackView()
        symbolStackView.addArrangedSubview(SymbolTitleLabel)
        symbolStackView.addArrangedSubview(symbolAmountLabel)
        symbolStackView.spacing = 2
        symbolStackView.axis = .vertical
        symbolStackView.alignment = .leading
        symbolStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateStackView = UIStackView()
        dateStackView.addArrangedSubview(DateTitleLabel)
        dateStackView.addArrangedSubview(dateAmountLabel)
        dateStackView.spacing = 2
        dateStackView.axis = .vertical
        dateStackView.alignment = .leading
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let typeStackView = UIStackView()
        typeStackView.addArrangedSubview(TypeTitleLabel)
        typeStackView.addArrangedSubview(typeAmountLabel)
        typeStackView.spacing = 2
        typeStackView.axis = .vertical
        typeStackView.alignment = .leading
        typeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let styleStackView = UIStackView()
        styleStackView.addArrangedSubview(TradeStyleTitleLabel)
        styleStackView.addArrangedSubview(styleAmountLabel)
        styleStackView.spacing = 2
        styleStackView.axis = .vertical
        styleStackView.alignment = .leading
        styleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let entryStackView = UIStackView()
        entryStackView.addArrangedSubview(EntryTitleLabel)
        entryStackView.addArrangedSubview(entryAmountLabel)
        entryStackView.spacing = 2
        entryStackView.axis = .vertical
        entryStackView.alignment = .leading
        entryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let slStackView = UIStackView()
        slStackView.addArrangedSubview(slTitleLabel)
        slStackView.addArrangedSubview(slAmountLabel)
        slStackView.spacing = 2
        slStackView.axis = .vertical
        slStackView.alignment = .leading
        slStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tpStackView = UIStackView()
        tpStackView.addArrangedSubview(tpTitleLabel)
        tpStackView.addArrangedSubview(tpAmountLabel)
        tpStackView.spacing = 2
        tpStackView.axis = .vertical
        tpStackView.alignment = .leading
        tpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let pipStackView = UIStackView()
        pipStackView.addArrangedSubview(PipTitleLabel)
        pipStackView.addArrangedSubview(pipAmountLabel)
        pipStackView.spacing = 2
        pipStackView.axis = .vertical
        pipStackView.alignment = .leading
        pipStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tpTwoStackView = UIStackView()
        tpTwoStackView.addArrangedSubview(tpTwoTitleLabel)
        tpTwoStackView.addArrangedSubview(tpTwoAmountLabel)
        tpTwoStackView.spacing = 2
        tpTwoStackView.axis = .vertical
        tpTwoStackView.alignment = .leading
        tpTwoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let updateStackView = UIStackView()
        updateStackView.addArrangedSubview(UpdateTitleLabel)
        updateStackView.addArrangedSubview(updateAmountLabel)
        updateStackView.spacing = 2
        updateStackView.axis = .vertical
        updateStackView.alignment = .leading
        updateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let riskStackView = UIStackView()
        riskStackView.addArrangedSubview(riskRewardTitleLabel)
        riskStackView.addArrangedSubview(riskRewardAmountLabel)
        riskStackView.spacing = 2
        riskStackView.axis = .vertical
        riskStackView.alignment = .leading
        riskStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackViewOne = UIStackView()
        mainStackViewOne.addArrangedSubview(symbolStackView)
        mainStackViewOne.addArrangedSubview(dateStackView)
        mainStackViewOne.addArrangedSubview(typeStackView)
        mainStackViewOne.addArrangedSubview(styleStackView)
        mainStackViewOne.addArrangedSubview(entryStackView)
        mainStackViewOne.addArrangedSubview(tpStackView)
        mainStackViewOne.addArrangedSubview(tpTwoStackView)
        mainStackViewOne.addArrangedSubview(slStackView)
        mainStackViewOne.addArrangedSubview(riskStackView)
        mainStackViewOne.addArrangedSubview(pipStackView)
        mainStackViewOne.addArrangedSubview(updateStackView)
        mainStackViewOne.spacing = 7
        mainStackViewOne.axis = .vertical
        mainStackViewOne.alignment = .leading
        mainStackViewOne.distribution = .fill
        mainStackViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        //        addSubview(clearBackGround)
        addSubview(cardBackground)
        
        cardBackground.addSubview(mainStackViewOne)
        
        //        cardBackground.addSubview(animationView)
        
        
        // setup constraints for views
        NSLayoutConstraint.activate([
            cardBackground.topAnchor.constraint(equalTo: topAnchor),
            cardBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            
            
            mainStackViewOne.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 30),
            mainStackViewOne.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 40),
            mainStackViewOne.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -40),
            //            mainStackViewOne.bottomAnchor.constraint(equalTo: cardBackground.bottomAnchor, constant: -40),
            ])
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SignalOpenBottomCell: UICollectionViewCell {
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .darkGray
        button.tintColor = .gray
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        //        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //        button.imageEdgeInsets = InsetView
        button.addTarget(self, action: #selector(dashboardTapped), for: .touchUpInside)
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .darkGray
        button.tintColor = .gray
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        //        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //        button.imageEdgeInsets = InsetView
//        button.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
        
        let editGesture = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        editButton.addGestureRecognizer(editGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(editButton)
        
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            ])
    }
    
    @objc func dashboardTapped() {
        NotificationCenter.default.post(name: Notification.Name("CloseThisThangJawn"), object: nil)
    }
    
    @objc func editTapped() {
        NotificationCenter.default.post(name: Notification.Name("OpenSignalEdit"), object: nil)
    }
    
}
