//
//  SIgnalGraphView.swift
//  Lions of Forex
//
//  Created by UNO EAST on 2/22/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class SignalsGraphView: UIViewController {
    
    weak var curvedlineChart:LineChart!
    
    let curvedChart: LineChart = {
       let chart = LineChart()
        chart.isCurved = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .clear
        return chart
    }()
    
    let viewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 46/255, green: 48/255, blue: 57/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainSignalCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardViewBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainCardBackground")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let signalCardViewBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TopCardBackgroundV3")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        let userName: String = KeychainWrapper.standard.string(forKey: "nameToken") ?? "User"
        let firstName = userName.components(separatedBy: " ").first
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.text = "\(firstName ?? ""), here is your \nSignal Overview"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userblankprofile-1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        let whiteColor = UIColor.white.cgColor
        imageView.layer.borderColor = whiteColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "Dashboard_Icon"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dashboardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let greetingMessage: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Congratulations, You caught --- pips!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dashboardBorderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DashboardBorder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let dashboardHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartView()
    }
    
    func DATA() -> [PointEntry] {
        var results: [PointEntry] = []
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
                    
                    
                    var index = 0
                    if let innerJson = jsondata.dictionary?["success"]?.arrayValue {
                        for result in innerJson {
                            if let data  = result.dictionary {
                                
                                let pip = data["pips"]
                                let date = data["date"]
                                if  let pipString:String = pip?.description,
                                    let dateString:String = date?.description {
                                    if pipString != "null" {
                                        
                                        print(pipString,dateString)
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "d MMM"
                                        
                                        let firstString = pipString.components(separatedBy: " ").first

                                        
                                        let dateFormatterGet = DateFormatter()
                                        dateFormatterGet.dateFormat = "dd MMMM, h:mm a"
                                        
                                        var date = dateFormatterGet.date(from: dateString)
                                        //replace that zero with a index id later
                                        date?.addTimeInterval(TimeInterval(24*60*60*index))
                                        index = index + 1
                                        
                                        //                            print(PointEntry(value: Int(pipString)!, label: formatter.string(from: date!)))
                                        results.append(PointEntry(value: Int(firstString!)!, label: formatter.string(from: date!)))
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                }
                DispatchQueue.main.async {
                    // we will update the graph here because we have all the POintEntry by noe
                    print(results.count)
                    self.curvedChart.dataEntries = results
//                    self.curvedlineChart.isCurved = true
                    
                }
        }
        
        return results
    }
    
    func setupChartView() {
        view.addSubview(viewBackground)
        view.addSubview(dashboardHolder)
        dashboardHolder.addSubview(settingsButton)
//        viewBackground.addSubview(curvedChart)
        dashboardHolder.addSubview(dashboardBorderImage)
        dashboardHolder.addSubview(dashboardTitleLabel)
//        dashboardHolder.addSubview(profileImage)
        viewBackground.addSubview(mainCardView)
        viewBackground.addSubview(mainSignalCardView)
        mainSignalCardView.addSubview(signalCardViewBackgroundImage)
        mainSignalCardView.addSubview(curvedChart)
        mainCardView.addSubview(cardViewBackgroundImage)
        mainCardView.addSubview(greetingLabel)
        mainCardView.addSubview(greetingMessage)
        
        // setup constraints
        NSLayoutConstraint.activate([
            viewBackground.topAnchor.constraint(equalTo: view.topAnchor),
            dashboardHolder.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            dashboardHolder.topAnchor.constraint(equalTo: viewBackground.topAnchor),
            dashboardHolder.leadingAnchor.constraint(equalTo: viewBackground.leadingAnchor),
            dashboardHolder.trailingAnchor.constraint(equalTo: viewBackground.trailingAnchor),
            dashboardBorderImage.topAnchor.constraint(equalTo: dashboardHolder.topAnchor),
            dashboardBorderImage.widthAnchor.constraint(equalTo: dashboardHolder.widthAnchor),
            dashboardBorderImage.leadingAnchor.constraint(equalTo: dashboardHolder.leadingAnchor),
            dashboardBorderImage.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor),
            dashboardBorderImage.heightAnchor.constraint(equalTo: dashboardHolder.heightAnchor),
            dashboardTitleLabel.bottomAnchor.constraint(equalTo: dashboardHolder.bottomAnchor),
            dashboardTitleLabel.leadingAnchor.constraint(equalTo: dashboardHolder.leadingAnchor, constant: 25),
            viewBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            curvedChart.bottomAnchor.constraint(equalTo: mainSignalCardView.bottomAnchor),
            curvedChart.topAnchor.constraint(equalTo: mainSignalCardView.topAnchor),
            curvedChart.trailingAnchor.constraint(equalTo: mainSignalCardView.trailingAnchor),
            curvedChart.leadingAnchor.constraint(equalTo: mainSignalCardView.leadingAnchor),
            mainCardView.topAnchor.constraint(equalTo: dashboardHolder.bottomAnchor, constant: 30),
            mainCardView.leadingAnchor.constraint(equalTo: viewBackground.leadingAnchor, constant: 25),
            mainCardView.trailingAnchor.constraint(equalTo: viewBackground.trailingAnchor, constant: -25),
            mainCardView.heightAnchor.constraint(equalTo: viewBackground.heightAnchor, multiplier: 0.22),
            mainSignalCardView.topAnchor.constraint(equalTo: mainCardView.bottomAnchor, constant: 30),
            mainSignalCardView.leadingAnchor.constraint(equalTo: viewBackground.leadingAnchor, constant: 25),
            mainSignalCardView.trailingAnchor.constraint(equalTo: viewBackground.trailingAnchor, constant: -25),
            mainSignalCardView.heightAnchor.constraint(equalTo: viewBackground.heightAnchor, multiplier: 0.22),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            settingsButton.widthAnchor.constraint(equalToConstant: 50),
            settingsButton.centerYAnchor.constraint(equalTo: dashboardTitleLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: dashboardHolder.trailingAnchor, constant: -30),
            greetingLabel.topAnchor.constraint(equalTo: mainCardView.topAnchor, constant: 25),
            greetingLabel.leadingAnchor.constraint(equalTo: mainCardView.leadingAnchor, constant: 20),
            greetingMessage.bottomAnchor.constraint(equalTo: mainCardView.bottomAnchor, constant: -20),
            greetingMessage.leadingAnchor.constraint(equalTo: mainCardView.leadingAnchor, constant: 20),
            greetingMessage.trailingAnchor.constraint(equalTo: mainCardView.trailingAnchor, constant: -20),
            
            
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    
    
    @objc func settingsTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
