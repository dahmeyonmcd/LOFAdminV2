//
//  ExpandedSignalView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ExpandedSignalView: UIView {
    
    let clearBackGround: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let cardBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = .gray
        button.setImage(UIImage(named: "Close_Icon"), for: .normal)
        let InsetView = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.imageEdgeInsets = InsetView
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    let SymbolTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "Symbol"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let UpdateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "Update"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let TypeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "Type"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let DateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let PipTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "Pips"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "S/L"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "T/P"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let EntryTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = "Entry"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let symbolAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "symbol value"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "Symbol"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pipAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tpAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let entryAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let updateAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.text = "---"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(openPageTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurThis = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurThis)
        
        blurView.frame = bounds
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
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
        let mainEntry: String? = KeychainWrapper.standard.string(forKey: "selectedEntry")
        let mainUpdate: String? = KeychainWrapper.standard.string(forKey: "selectedUpdate")
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
        entryAmountLabel.text = mainEntry
        updateAmountLabel.text = mainUpdate
    }
    
    private func setupLayout() {
        addSubview(clearBackGround)
        clearBackGround.addSubview(cardBackground)
        cardBackground.addSubview(closeButton)
        cardBackground.addSubview(SymbolTitleLabel)
        cardBackground.addSubview(symbolAmountLabel)
        cardBackground.addSubview(DateTitleLabel)
        cardBackground.addSubview(dateAmountLabel)
        cardBackground.addSubview(TypeTitleLabel)
        cardBackground.addSubview(typeAmountLabel)
        cardBackground.addSubview(EntryTitleLabel)
        cardBackground.addSubview(entryAmountLabel)
        cardBackground.addSubview(slTitleLabel)
        cardBackground.addSubview(slAmountLabel)
        cardBackground.addSubview(tpTitleLabel)
        cardBackground.addSubview(tpAmountLabel)
        cardBackground.addSubview(UpdateTitleLabel)
        cardBackground.addSubview(updateButton)
        
        //        cardBackground.addSubview(animationView)

        
        // setup constraints for views
        NSLayoutConstraint.activate([
            clearBackGround.topAnchor.constraint(equalTo: topAnchor),
            clearBackGround.bottomAnchor.constraint(equalTo: bottomAnchor),
            clearBackGround.trailingAnchor.constraint(equalTo: trailingAnchor),
            clearBackGround.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackground.widthAnchor.constraint(equalToConstant: 300),
            cardBackground.heightAnchor.constraint(equalToConstant: 500),
            cardBackground.centerXAnchor.constraint(equalTo: clearBackGround.centerXAnchor),
            cardBackground.centerYAnchor.constraint(equalTo: clearBackGround.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 15),
            SymbolTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            SymbolTitleLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            SymbolTitleLabel.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 40),
            symbolAmountLabel.heightAnchor.constraint(equalToConstant: 20),
            symbolAmountLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            symbolAmountLabel.topAnchor.constraint(equalTo: SymbolTitleLabel.bottomAnchor, constant: 10),
            DateTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            DateTitleLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            DateTitleLabel.topAnchor.constraint(equalTo: symbolAmountLabel.bottomAnchor, constant: 20),
            dateAmountLabel.heightAnchor.constraint(equalToConstant: 20),
            dateAmountLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            dateAmountLabel.topAnchor.constraint(equalTo: DateTitleLabel.bottomAnchor, constant: 10),
            TypeTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            TypeTitleLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            TypeTitleLabel.topAnchor.constraint(equalTo: dateAmountLabel.bottomAnchor, constant: 20),
            typeAmountLabel.heightAnchor.constraint(equalToConstant: 20),
            typeAmountLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            typeAmountLabel.topAnchor.constraint(equalTo: TypeTitleLabel.bottomAnchor, constant: 10),
            EntryTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            EntryTitleLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            EntryTitleLabel.topAnchor.constraint(equalTo: typeAmountLabel.bottomAnchor, constant: 20),
            entryAmountLabel.heightAnchor.constraint(equalToConstant: 20),
            entryAmountLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            entryAmountLabel.topAnchor.constraint(equalTo: EntryTitleLabel.bottomAnchor, constant: 10),
            slTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            slTitleLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            slTitleLabel.topAnchor.constraint(equalTo: entryAmountLabel.bottomAnchor, constant: 20),
            slAmountLabel.heightAnchor.constraint(equalToConstant: 20),
            slAmountLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            slAmountLabel.topAnchor.constraint(equalTo: slTitleLabel.bottomAnchor, constant: 10),
            tpTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            tpTitleLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            tpTitleLabel.topAnchor.constraint(equalTo: slAmountLabel.bottomAnchor, constant: 20),
            tpAmountLabel.heightAnchor.constraint(equalToConstant: 20),
            tpAmountLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            tpAmountLabel.topAnchor.constraint(equalTo: tpTitleLabel.bottomAnchor, constant: 10),
            UpdateTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            UpdateTitleLabel.widthAnchor.constraint(equalTo: cardBackground.widthAnchor),
            UpdateTitleLabel.topAnchor.constraint(equalTo: tpAmountLabel.bottomAnchor, constant: 20),
            
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
            updateButton.topAnchor.constraint(equalTo: UpdateTitleLabel.bottomAnchor, constant: 10),
            ])
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
        KeychainWrapper.standard.removeObject(forKey: "selectedID")
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }

        
    }
    
    @objc func openPageTapped() {
        // opens swiping controller
        let mainController = EditSignalVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        //        navigationController.modalTransitionStyle = .crossDissolve
        topVC?.present(navigationController, animated: true, completion: nil)
//        NotificationCenter.default.post(name: Notification.Name("UpdateSignalTapped"), object: nil)
        print("opening page with signalID: \(KeychainWrapper.standard.string(forKey: "selectedID") ?? "")")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
