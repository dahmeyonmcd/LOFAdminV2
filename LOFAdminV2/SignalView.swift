//
//  SignalView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 3/6/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import Lottie

class SignalView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let topView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
//        tView.backgroundColor = UIColor.init(red: 245/255, green: 212/255, blue: 35/255, alpha: 1)
        tView.backgroundColor = UIColor.init(red: 217/255, green: 222/255, blue: 233/255, alpha: 1)
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
        button.isEnabled = false
        button.isHidden = true
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("EDIT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.layer.zPosition = 1
        button.layer.masksToBounds = true
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addSignal: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(red: 70/255, green: 114/255, blue: 173/255, alpha: 1)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "AddSignal"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(addNewSignal), for: .touchUpInside)
        button.layer.cornerRadius = 18
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.zPosition = 1
        button.tintColor = .white
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
        label.textColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        label.text = "---"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
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
        label.textColor = UIColor.init(red: 41/255, green: 47/255, blue: 58/255, alpha: 1)
        label.text = "total pips"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
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
        collectionView.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: Set up walkthrough
    
    let walkthroughHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return view
    }()
    
    let walkthroughBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "WalkthroughBackground")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let walkthroughTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        let attString = NSAttributedString(string: "MORE", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
//        label.text = "All signals and updates will be viewed here. \nAlways stay updated on the latest news."
        label.text = "Get real-time signals, updated with push-notifications! Click any signal for more details!"
        label.numberOfLines = 2
        return label
    }()
    
    let walkthroughButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Close_Icon"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeWalkthrough), for: .touchUpInside)
        return button
    }()
    
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
    
    // MARK: End of walkthrough Elements
    
    var signalsData = ["", "", "", ""]
    
    var animationView: AnimationView = AnimationView(name: "lofloading")
    
    let SignalId = "singleSignalCellId"
    let BlankCellId = "blankCellId"
    let UpdateCellId = "updateCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        fetchSignals()
        checkForAdmin()
        setupSignalCellHolder()
        backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        MainTab.menuBarLabel.text = "Signals"
        cellHolder.dataSource = self
        cellHolder.delegate = self
        cellHolder.showsVerticalScrollIndicator = false
        cellHolder.register(SignalsCell.self, forCellWithReuseIdentifier: SignalId)
        cellHolder.register(BlankSignalCell.self, forCellWithReuseIdentifier: BlankCellId)
        cellHolder.register(UpdateCell.self, forCellWithReuseIdentifier: UpdateCellId)
        cellHolder.refreshControl = refresher
        
        startAnimations()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSignals), name: Notification.Name("ReloadSignals"), object: nil)
    }
    
    func startAnimations() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.play()
        animationView.loopMode = .loop
        
        addSubview(pageOverlay)
        pageOverlay.addSubview(lotContainer)
        lotContainer.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            pageOverlay.topAnchor.constraint(equalTo: topAnchor),
            pageOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lotContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            lotContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: lotContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: lotContainer.centerYAnchor),
            ])
        
        // MARK: Launch loading function.
        DispatchQueue.main.async {
            
            // execute
            self.pipCount()
            self.handleWalkthrough()
            self.fetchSignals()
            
            
            //
        }
    }
    
    func startSignalCheckerTimer() {
        Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(SignalView.fetchNewSignals), userInfo: nil, repeats: true)
        
    }
    
    func checkForAdmin() {
        let isAdmin: Bool? = KeychainWrapper.standard.bool(forKey: "isAdmin")
        if isAdmin == true {
            setupTopBarAdmin()
        }else if isAdmin == nil {
            setupTopBar()
        }else {
            setupTopBar()
        }
    }
    
    func setupSignalCellHolder() {
        addSubview(cellHolder)
        
        cellHolder.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        cellHolder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellHolder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cellHolder.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
    }
    
    func setupTopBarAdmin() {
        addSubview(topSpacer)
        addSubview(bottomSpacer)
        addSubview(topView)
        topView.addSubview(totalPipLabel)
        topView.addSubview(editButton)
        topView.addSubview(addSignal)
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
            editButton.widthAnchor.constraint(equalToConstant: 80),
            editButton.heightAnchor.constraint(equalToConstant: 36),
            editButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            totalPipLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            totalPipLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            secondPipLabel.leadingAnchor.constraint(equalTo: totalPipLabel.trailingAnchor, constant: 5),
            secondPipLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            addSignal.widthAnchor.constraint(equalToConstant: 36),
            addSignal.heightAnchor.constraint(equalToConstant: 36),
            addSignal.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            addSignal.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -15)
            ])
    }
    
    // MARK: Handles walkthrough
    func handleWalkthrough() {
        let key: Bool? = KeychainWrapper.standard.bool(forKey: "SawSignalsWalkthrough")
        if key == nil {
            openWalkthrough()
            
        }else if key == false {
            openWalkthrough()
            
        }else{
            print("already watched walkthrough")
        }
    }
    
    func setupWalkthrough() {
        let stackOne = UIStackView()
        stackOne.translatesAutoresizingMaskIntoConstraints = false
        stackOne.addArrangedSubview(walkthroughTitleLabel)
        stackOne.axis = .vertical
        stackOne.distribution = .equalSpacing
        stackOne.alignment = .leading
        
        // finish setting up walkthrough
        let v2 = walkthroughHolder
        v2.translatesAutoresizingMaskIntoConstraints = false
        let v3 = walkthroughButton
        let v4 = walkthroughBackgroundImage
        let v5 = stackOne
        v3.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(v2)
        v2.addSubview(v4)
        v2.addSubview(v5)
        v2.addSubview(v3)
        
        v2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        v2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        v2.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor).isActive = true
        
        v3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        v3.widthAnchor.constraint(equalToConstant: 40).isActive = true
        v3.trailingAnchor.constraint(equalTo: v2.trailingAnchor, constant: -15).isActive = true
        v3.centerYAnchor.constraint(equalTo: v2.centerYAnchor).isActive = true
        
        v4.topAnchor.constraint(equalTo: v2.topAnchor).isActive = true
        v4.bottomAnchor.constraint(equalTo: v2.bottomAnchor).isActive = true
        v4.trailingAnchor.constraint(equalTo: v2.trailingAnchor).isActive = true
        v4.leadingAnchor.constraint(equalTo: v2.leadingAnchor).isActive = true
        
        v5.topAnchor.constraint(equalTo: v2.topAnchor, constant: 10).isActive = true
        v5.bottomAnchor.constraint(equalTo: v2.bottomAnchor, constant: -10).isActive = true
        v5.trailingAnchor.constraint(equalTo: v3.leadingAnchor, constant: -10).isActive = true
        v5.leadingAnchor.constraint(equalTo: v2.leadingAnchor, constant: 15).isActive = true
        
    }
    
    @objc func closeWalkthrough() {
        walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseOut, animations: {
            self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 300)
        }) { (_) in
            // here
            self.walkthroughHolder.removeFromSuperview()
        }
        
        KeychainWrapper.standard.set(true, forKey: "SawSignalsWalkthrough")
    }
    
    @objc func openWalkthrough() {
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.setupWalkthrough()
            self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 300)
            
            UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseIn, animations: {
                self.walkthroughHolder.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (_) in
                // here
                // MARK: Frames here
                
            }
        }
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
            topView.heightAnchor.constraint(equalToConstant: 60),
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
    
    func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 1000
        
        let size = CGSize(width: cellHolder.frame.width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.init(name: "GorditaBlack", size: 11)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if data1.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlankCellId, for: indexPath) as! BlankSignalCell
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignalId, for: indexPath) as! SignalsCell
//            let renderCell = collectionView.cellForItem(at: indexPath)
            var iP = data1[indexPath.row]
            let signalsGenerated = iP["pips"] as? String
            let signalSymbol = iP["symbol"] as? String
            let dateGenerated = iP["date"] as? String
            
            let dateShortened = dateGenerated?.components(separatedBy: ",").first
            if signalSymbol == "AUDCAD" {
                cell.signalsImageView.image = UIImage(named: "AUDCAD")
            }else if signalSymbol == "AUDCHF" {
                cell.signalsImageView.image = UIImage(named: "AUDCHF")
            }else if signalSymbol == "AUDJPY" {
                cell.signalsImageView.image = UIImage(named: "AUDJPY")
            }else if signalSymbol == "AUDNZD" {
                cell.signalsImageView.image = UIImage(named: "AUDNZD")
            }else if signalSymbol == "AUDUSD" {
                cell.signalsImageView.image = UIImage(named: "AUDUSD")
            }else if signalSymbol == "CADCHF" {
                cell.signalsImageView.image = UIImage(named: "CADCHF")
            }else if signalSymbol == "CADJPY" {
                cell.signalsImageView.image = UIImage(named: "CADJPY")
            }else if signalSymbol == "EURAUD" {
                cell.signalsImageView.image = UIImage(named: "EURAUD")
            }else if signalSymbol == "EURCAD" {
                cell.signalsImageView.image = UIImage(named: "EURCAD")
            }else if signalSymbol == "EURCHF" {
                cell.signalsImageView.image = UIImage(named: "EURCHF")
            }else if signalSymbol == "EURGBP" {
                cell.signalsImageView.image = UIImage(named: "EURGBP")
            }else if signalSymbol == "EURJPY" {
                cell.signalsImageView.image = UIImage(named: "EURJPY")
            }else if signalSymbol == "EURNZD" {
                cell.signalsImageView.image = UIImage(named: "EURNZD")
            }else if signalSymbol == "EURUSD" {
                cell.signalsImageView.image = UIImage(named: "EURUSD")
            }else if signalSymbol == "GBPAUD" {
                cell.signalsImageView.image = UIImage(named: "GBPAUD")
            }else if signalSymbol == "GBPCAD" {
                cell.signalsImageView.image = UIImage(named: "GBPCAD")
            }else if signalSymbol == "GBPCHF" {
                cell.signalsImageView.image = UIImage(named: "GBPCHF")
            }else if signalSymbol == "GBPJPY" {
                cell.signalsImageView.image = UIImage(named: "GBPJPY")
            }else if signalSymbol == "GBPNZD" {
                cell.signalsImageView.image = UIImage(named: "GBPNZD")
            }else if signalSymbol == "GBPUSD" {
                cell.signalsImageView.image = UIImage(named: "GBPUSD")
            }else if signalSymbol == "MXNUSD" {
                cell.signalsImageView.image = UIImage(named: "MXNUSD")
            }else if signalSymbol == "NZDCAD" {
                cell.signalsImageView.image = UIImage(named: "NZDCAD")
            }else if signalSymbol == "NZDCHF" {
                cell.signalsImageView.image = UIImage(named: "NZDCHF")
            }else if signalSymbol == "NZDJPY" {
                cell.signalsImageView.image = UIImage(named: "NZDJPY")
            }else if signalSymbol == "NZDUSD" {
                cell.signalsImageView.image = UIImage(named: "NZDUSD")
            }else if signalSymbol == "USDCHF" {
                cell.signalsImageView.image = UIImage(named: "USDCHF")
            }else if signalSymbol == "USDJPY" {
                cell.signalsImageView.image = UIImage(named: "USDJPY")
            }else if signalSymbol == "USDCAD" {
                cell.signalsImageView.image = UIImage(named: "USDCAD")
            }else if signalSymbol == "XAUUSD" {
                cell.signalsImageView.image = UIImage(named: "XAUUSD")
            }else if signalSymbol == "US30" {
                cell.signalsImageView.image = UIImage(named: "US30")
            } else {
                cell.signalsImageView.image = UIImage(named: "UNKNOWNPAIR")
            }
            
            if signalsGenerated?.prefix(1) == "-" {
                cell.newPipLabel.textColor = .red
                cell.newPipLabel.text = "\(signalsGenerated ?? "") pips"
                cell.signalActivityIndicator.backgroundColor = .red
            }else if signalsGenerated == "-" {
                cell.newPipLabel.textColor = .white
                cell.newPipLabel.text = "\(signalsGenerated ?? "")"
                cell.signalActivityIndicator.backgroundColor = .red
            }else if signalsGenerated == "0" {
                cell.newPipLabel.textColor = .white
                cell.newPipLabel.text = "\(signalsGenerated ?? "") pips"
                cell.signalActivityIndicator.backgroundColor = .red
            }else if signalsGenerated == nil {
                cell.newPipLabel.textColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
                cell.newPipLabel.text = "Pips"
            }else{
                cell.newPipLabel.textColor = .green
                cell.newPipLabel.text = "+\(signalsGenerated ?? "") pips"
                cell.signalActivityIndicator.backgroundColor = .red
            }
            
            
            
            cell.dateLabel.text = dateShortened
            cell.tradeStyleAmountLabel.text = iP["order_instant"]?.description
            cell.entryAmountTwoLabel.text = iP["buy_area_zone"]?.description
            
            cell.tradeTypeAmountLabel.text = iP["type"]?.description
            cell.slAmountLabel.text = iP["stop_loss"]?.description
            cell.tpAmountOneLabel.text = iP["take_profit"]?.description
            cell.tpAmountTwoLabel.text = iP["take_profit2"]?.description
            
            if let comment = iP["comment"]?.description {
                cell.updateAmountLabel.text = comment
            }
            
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if data1.count == 0 {
            print("placeholder selected")
        }else{
            if let selectedType = (data1[indexPath.row] as NSDictionary).object(forKey: "type") as? String {
                KeychainWrapper.standard.set(selectedType, forKey: "selectedType")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedType")
            }
            
            if let selectedDate = (data1[indexPath.row] as NSDictionary).object(forKey: "date") as? String {
                KeychainWrapper.standard.set(selectedDate, forKey: "selectedSignalDate")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedSignalDate")
            }
            
            if let selectedSL = (data1[indexPath.row] as NSDictionary).object(forKey: "stop_loss") as? String {
                KeychainWrapper.standard.set(selectedSL, forKey: "selectedSL")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedSL")
            }
            
            if let selectedTP = (data1[indexPath.row] as NSDictionary).object(forKey: "take_profit") as? String {
                KeychainWrapper.standard.set(selectedTP, forKey: "selectedTP")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedTP")
            }
            
            if let selectedTPTwo = (data1[indexPath.row] as NSDictionary).object(forKey: "take_profit2") as? String {
                KeychainWrapper.standard.set(selectedTPTwo, forKey: "selectedTP2")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedTP2")
            }
            
            if let selectedEntry = (data1[indexPath.row] as NSDictionary).object(forKey: "buy_area_zone") as? String {
                KeychainWrapper.standard.set(selectedEntry, forKey: "selectedEntry")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedEntry")
            }
            
            if let selectedStyle = (data1[indexPath.row] as NSDictionary).object(forKey: "order_instant") as? String {
                KeychainWrapper.standard.set(selectedStyle, forKey: "selectedStyle")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedStyle")
            }
            
            if let selectedPips = (data1[indexPath.row] as NSDictionary).object(forKey: "pips") as? String {
                KeychainWrapper.standard.set(selectedPips, forKey: "selectedPips")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedPips")
            }
            
            if let selectedSymbol = (data1[indexPath.row] as NSDictionary).object(forKey: "symbol") as? String {
                KeychainWrapper.standard.set(selectedSymbol, forKey: "selectedSymbol")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedSymbol")
            }
            
            if let selectedUpdate = (data1[indexPath.row] as NSDictionary).object(forKey: "comment") as? String {
                KeychainWrapper.standard.set(selectedUpdate, forKey: "selectedUpdate")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedUpdate")
            }
            
            if let selectedID = (data1[indexPath.row] as NSDictionary).object(forKey: "signal_id") as? String {
                KeychainWrapper.standard.set(selectedID, forKey: "selectedID")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedID")
            }
            
            if let selectedRiskReward = (data1[indexPath.row] as NSDictionary).object(forKey: "risk_reward") as? String {
                KeychainWrapper.standard.set(selectedRiskReward, forKey: "selectedRiskReward")
            }else{
                KeychainWrapper.standard.set("", forKey: "selectedRiskReward")
            }
            
            NotificationCenter.default.post(name: Notification.Name("OpenExpandedSignalView"), object: nil)

        }
        
    }
    
    func setupAdminPanel() {
        
        // present view controller
        let mainController = CreateNewSignalVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
            
        }
        
        topVC?.present(navigationController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if data1.count == 0 {
            return CGSize(width: frame.width, height: 300)
        }else {
            var iP = data1[indexPath.row]
            if iP["comment"] as? String == "" {
                return CGSize(width: frame.width, height: 300)
            }else {
                if let commentStr = iP["comment"]?.description {
                    var height: CGFloat = 400
                    
                    //we are just measuring height so we add a padding constant to give the label some room to breathe!
                    let padding: CGFloat = 30
                    
                    //estimate each cell's height
                    height = estimateFrameForText(text: commentStr).height + padding
                    
                    return CGSize(width: cellHolder.frame.width, height: 338 + height)
                }else{
                    
                }
                return CGSize(width: frame.width, height: 400)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
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
    
    @objc func fetchSignals() {
        
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
                        self.animationView.stop()
                        self.pageOverlay.removeFromSuperview()
                    }
                }
                
        }
    }
    
    @objc func fetchNewSignals() {
        
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
//                        self.animationView.stop()
//                        self.pageOverlay.removeFromSuperview()
                    }
                }
                
        }
    }
    
    @objc func editButtonTapped() {
        print("edit button tapped")
    }
    
    
    @objc func showGraphButton() {
        print("show graph tapped")
        // present view controller
        
    }
    
    @objc func addNewSignal() {
        print("creating new signal")
        // present view controller
        let mainController = CreateNewSignalVC() as UIViewController
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.isHidden = true
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC?.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }

        topVC?.present(navigationController, animated: true, completion: nil)
    }
    
    
}
