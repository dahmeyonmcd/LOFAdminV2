//
//  SignalGraphView.swift
//  LionsofForexAdminApp
//
//  Created by UnoEast on 6/1/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class SignalGraphView: UIView {
    
    weak var curvedlineChart:LineChart!
    
    let curvedChart: LineChart = {
        let chart = LineChart()
        chart.isCurved = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .clear
        return chart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        
        setupViews()
        
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
                                        
                                        if let firstString = pipString.components(separatedBy: " ").first {
                                            print("first string is: \(firstString)")
                                            if let intString: Int = Int(firstString) {
                                                print("int string is: \(intString)")
                                                let dateFormatterGet = DateFormatter()
                                                dateFormatterGet.dateFormat = "dd MMMM, h:mm a"
                                                
                                                var date = dateFormatterGet.date(from: dateString)
                                                //replace that zero with a index id later
                                                date?.addTimeInterval(TimeInterval(24*60*60*index))
                                                index = index + 1
                                                
                                                //                            print(PointEntry(value: Int(pipString)!, label: formatter.string(from: date!)))
                                                results.append(PointEntry(value: intString, label: formatter.string(from: date!)))
                                            }
                                            DispatchQueue.main.async {
                                                // we will update the graph here because we have all the POintEntry by noe
                                                print(results.count)
                                                self.curvedChart.dataEntries = results
                                                //                    self.curvedlineChart.isCurved = true
                                                
                                            }
                                            
                                        }
                                        
                                        
//                                        let dateFormatterGet = DateFormatter()
//                                        dateFormatterGet.dateFormat = "dd MMMM, h:mm a"
//
//                                        var date = dateFormatterGet.date(from: dateString)
//                                        //replace that zero with a index id later
//                                        date?.addTimeInterval(TimeInterval(24*60*60*index))
//                                        index = index + 1
//
//                                        //                            print(PointEntry(value: Int(pipString)!, label: formatter.string(from: date!)))
//                                        results.append(PointEntry(value: Int(firstString!)!, label: formatter.string(from: date!)))
                                        
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
    
    func setupViews() {
        addSubview(curvedChart)
        
        NSLayoutConstraint.activate([
            curvedChart.topAnchor.constraint(equalTo: topAnchor),
            curvedChart.bottomAnchor.constraint(equalTo: bottomAnchor),
            curvedChart.leadingAnchor.constraint(equalTo: leadingAnchor),
            curvedChart.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
