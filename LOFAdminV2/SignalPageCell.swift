//
//  SignalPageCell.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/19/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class SignalPageCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
//    let signalCollectionView: UICollectionView = {
//        let layout = UICollectionViewDelegateFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        return cv
//    }()
    
    let topView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        return tView
    }()
    
    let graphButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("GRAPH", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(showGraphButton), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.layer.zPosition = 1
        button.layer.masksToBounds = true
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    let totalPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "---"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let topSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondPipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "total pips"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.contentMode = .bottomLeft
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let MainTab = SwipingController()
    let SignalsCellId = "signalsCell"
    
    
    let cellHolder: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var signalsData = ["", "", "", ""]
    
    let SignalId = "singleSignalCellId"
    let BlankCellId = "blankCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        fetchSignals()
//        setupTopBar()
//        setupSignalCellHolder()
//        backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
//        isSelected = true
//        MainTab.menuBarLabel.text = "Signals"
//        cellHolder.dataSource = self
//        cellHolder.delegate = self
//        cellHolder.showsVerticalScrollIndicator = false
//        cellHolder.register(SignalsCell.self, forCellWithReuseIdentifier: SignalId)
//        cellHolder.register(BlankSignalCell.self, forCellWithReuseIdentifier: BlankCellId)
//        cellHolder.refreshControl = refresher
//        pipCount()
        
        setupOverView()
    }
    
    func setupOverView() {
        
        let window = UIApplication.shared.keyWindow
        let v2 = SignalView(frame: (window?.bounds)!)
        
        addSubview(v2)
        
        
        v2.topAnchor.constraint(equalTo: topAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        v2.alpha = 1
        
    }
    
    func setupSignalCellHolder() {
        addSubview(cellHolder)
        
        cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
    }
    
    func setupTopBar() {
        addSubview(topSpacer)
        addSubview(bottomSpacer)
        addSubview(topView)
        topView.addSubview(totalPipLabel)
        topView.addSubview(graphButton)
        topView.addSubview(secondPipLabel)
        
        
        // set constraints for elements
        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 50),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalToConstant: 70),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            topView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.widthAnchor.constraint(equalTo: widthAnchor),
            graphButton.widthAnchor.constraint(equalToConstant: 100),
            graphButton.heightAnchor.constraint(equalToConstant: 36),
            graphButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            graphButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            totalPipLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            totalPipLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            secondPipLabel.leadingAnchor.constraint(equalTo: totalPipLabel.trailingAnchor, constant: 5),
            secondPipLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
            
            ])
    }
    
    func pipCount(){
        
        let myUrl = URL(string: "http://api.lionsofforex.com/signals/list")
        var request = URLRequest(url: myUrl!)
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
        // send http request to perform sign in
        
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    //run this i wanna see what the output is
                    print()
                    
                    var myArray = ["0"]
                    var arrayTwo = [""]
                    if let innerJson = jsondata.dictionary?["success"]?.arrayValue {
                                    for result in innerJson {
                                        if let data  = result.dictionary {
                                            
                                            let pip = data["pips"]
                                            let date = data["pips"]
                                            
                                            if  let pipString:String = pip?.description,
                                                let dateString:String = date?.description {
                                                if pipString != "null" {
                                                    
                                                    let pipCount = pipString.components(separatedBy: " ").first
                                                    
                                                    myArray.append(pipCount!)
                                                    arrayTwo.append(dateString)
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                    DispatchQueue.main.async {
                        let intArray = myArray.map({Int($0) ?? 0})
                        let totalSum = intArray.reduce(0, +)
                        let stringTotal = String(totalSum)
                        print(intArray)
                        print(totalSum)
                        self.totalPipLabel.text = "\(stringTotal)"
                    }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data1.count == 0 {
            return 3
        }else{
            return data1.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if data1.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlankCellId, for: indexPath) as! BlankSignalCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignalId, for: indexPath) as! SignalsCell
            var iP = data1[indexPath.row]
            let signalsGenerated = iP["pips"] as? String
            let signalSymbol = iP["symbol"] as! String
            let dateGenerated = iP["date"] as? String
            let dateShortened = dateGenerated?.components(separatedBy: ",").first
            if signalSymbol == "EURUSD" {
                cell.signalsImageView.image = UIImage(named: "EURUSD")
            }else if signalSymbol == "USDJPY" {
                cell.signalsImageView.image = UIImage(named: "USDJPY")
            }else if signalSymbol == "GBPUSD" {
                cell.signalsImageView.image = UIImage(named: "GBPUSD")
            }else if signalSymbol == "USDCHF" {
                cell.signalsImageView.image = UIImage(named: "USDCHF")
            }else if signalSymbol == "AUDUSD" {
                cell.signalsImageView.image = UIImage(named: "AUDUSD")
            }else if signalSymbol == "USDCAD" {
                cell.signalsImageView.image = UIImage(named: "USDCAD")
            }else if signalSymbol == "NZDUSD" {
                cell.signalsImageView.image = UIImage(named: "NZDUSD")
            }else if signalSymbol == "GBPJPY" {
                cell.signalsImageView.image = UIImage(named: "GBPJPY")
            }else if signalSymbol == "GBPAUD" {
                cell.signalsImageView.image = UIImage(named: "GBPAUD")
            } else {
                cell.signalsImageView.image = UIImage(named: "UNKNOWNPAIR")
            }
            
            cell.dateLabel.text = dateShortened
            cell.tradeStyleAmountLabel.text = iP["order_instant"] as? String
            //        cell.signalType.text = iP["type"] as? String
            
            cell.tradeTypeAmountLabel.text = ("closed \(signalsGenerated ?? "") pips")
            cell.slAmountLabel.text = iP["stop_loss"] as? String
            cell.tpAmountOneLabel.text = iP["take_profit"] as? String
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if data1.count == 0 {
            print("placeholder selected")
        }else{
            let selectedType = (data1[indexPath.row] as NSDictionary).object(forKey: "type") as? String
            let selectedDate = (data1[indexPath.row] as NSDictionary).object(forKey: "date") as? String
            let selectedSL = (data1[indexPath.row] as NSDictionary).object(forKey: "stop_loss") as? String
            let selectedTP = (data1[indexPath.row] as NSDictionary).object(forKey: "take_profit") as? String
            let selectedEntry = (data1[indexPath.row] as NSDictionary).object(forKey: "order_instant") as? String
            let selectedPips = (data1[indexPath.row] as NSDictionary).object(forKey: "pips") as? String
            let selectedSymbol = (data1[indexPath.row] as NSDictionary).object(forKey: "symbol") as? String
            let selectedUpdate = (data1[indexPath.row] as NSDictionary).object(forKey: "update") as? String
            
            if selectedTP == nil {
                let saveSelectedTP: Bool = KeychainWrapper.standard.set("-", forKey: "selectedTP")
                print(saveSelectedTP)
            } else {
                let saveSelectedTP: Bool = KeychainWrapper.standard.set(selectedTP!, forKey: "selectedTP")
                print(saveSelectedTP)
            }
            
            if selectedSL == nil {
                let saveSelectedSL: Bool = KeychainWrapper.standard.set("-", forKey: "selectedSL")
                print(saveSelectedSL)
            }; if selectedSL == "" {
                let saveSelectedSL: Bool = KeychainWrapper.standard.set("-", forKey: "selectedSL")
                print(saveSelectedSL)
            } else {
                let saveSelectedSL: Bool = KeychainWrapper.standard.set(selectedSL!, forKey: "selectedSL")
                print(saveSelectedSL)
            }
            
            if selectedPips == nil {
                let saveSelectedPips: Bool = KeychainWrapper.standard.set("-", forKey: "selectedPips")
                print(saveSelectedPips)
            } else {
                let saveSelectedPips: Bool = KeychainWrapper.standard.set(selectedPips!, forKey: "selectedPips")
                print(saveSelectedPips)
            }
            
            if selectedEntry == nil {
                let saveSelectedPips: Bool = KeychainWrapper.standard.set("-", forKey: "selectedEntry")
                print(saveSelectedPips)
            }; if selectedEntry == "" {
                let saveSelectedPips: Bool = KeychainWrapper.standard.set("-", forKey: "selectedEntry")
                print(saveSelectedPips)
            } else {
                let saveSelectedEntry: Bool = KeychainWrapper.standard.set(selectedEntry!, forKey: "selectedEntry")
                print(saveSelectedEntry)
            }
            
            if selectedType == nil {
                let saveSelectedType: Bool = KeychainWrapper.standard.set("-", forKey: "selectedType")
                print(saveSelectedType)
            }; if selectedType == "" {
                let saveSelectedType: Bool = KeychainWrapper.standard.set("-", forKey: "selectedType")
                print(saveSelectedType)
            } else {
                let saveSelectedType: Bool = KeychainWrapper.standard.set(selectedType!, forKey: "selectedType")
                print(saveSelectedType)
            }
            
            if selectedDate == nil {
                let saveSelectedDate: Bool = KeychainWrapper.standard.set("-", forKey: "selectedSignalDate")
                print(saveSelectedDate)
            }; if selectedDate == "" {
                let saveSelectedDate: Bool = KeychainWrapper.standard.set("-", forKey: "selectedSignalDate")
                print(saveSelectedDate)
            } else {
                let saveSelectedDate: Bool = KeychainWrapper.standard.set(selectedDate!, forKey: "selectedSignalDate")
                print(saveSelectedDate)
            }
            
            if selectedSymbol == nil {
                let saveSelectedSymbol: Bool = KeychainWrapper.standard.set("-", forKey: "selectedSymbol")
                print(saveSelectedSymbol)
            }; if selectedSymbol == "" {
                let saveSelectedSymbol: Bool = KeychainWrapper.standard.set("-", forKey: "selectedSymbol")
                print(saveSelectedSymbol)
            } else {
                let saveSelectedSymbol: Bool = KeychainWrapper.standard.set(selectedSymbol!, forKey: "selectedSymbol")
                print(saveSelectedSymbol)
            }
            
            if selectedUpdate == nil {
                let saveSelectedUpdate: Bool = KeychainWrapper.standard.set("-", forKey: "selectedUpdate")
                print(saveSelectedUpdate)
            }; if selectedUpdate == "" {
                let saveSelectedUpdate: Bool = KeychainWrapper.standard.set("-", forKey: "selectedUpdate")
                print(saveSelectedUpdate)
            } else {
                let saveSelectedUpdate: Bool = KeychainWrapper.standard.set(selectedSymbol!, forKey: "selectedUpdate")
                print(saveSelectedUpdate)
            }
            
            let window = UIApplication.shared.keyWindow
            let v2 = ExpandedSignalView(frame: (window?.bounds)!)
            
            addSubview(v2)
            
            
            v2.topAnchor.constraint(equalTo: topAnchor).isActive = true
            v2.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            v2.alpha = 1
        }
        
        
//        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
//            self.alpha = 1
//        }) { (finish) in
////            self.removeFromSuperview()
//            print("finished loading signal")
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 240
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 9, left: 0, bottom: 0, right: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func requestData() {
        self.cellHolder.reloadData()
        fetchSignals()
        
        print("requesting new signals")
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    
    var data1 = [[String: AnyObject]]()
    
    func fetchSignals() {
        print("Fetching your signal list")
        
        let myUrl = URL(string: "http://api.lionsofforex.com/signals/list")
        var request = URLRequest(url: myUrl!)
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let accessText = accessToken
        print("access token is: \(accessText!)")
        let postString = ["email": accessText] as! [String: String]
        // send http request to perform sign in
        
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        Alamofire.request(myUrl!, method: .post, parameters: postString, encoding: JSONEncoding.default)
            .responseJSON { response in
                if ((response.result.value) != nil) {
                    let jsondata = JSON(response.result.value!)
                    
                    if let da = jsondata["success"].arrayObject {
                        self.data1 = da as! [[String : AnyObject]]
                        
                    }
                    
                    if self.data1.count > 0 {
                        self.cellHolder.reloadData()
                    }
                }
                
        }
    }
    
    @objc func showGraphButton() {
        print("show graph tapped")
    }
    
}
