//
//  GlobalManager.swift
//  MillionaireMentorship App
//
//  Created by Dahmeyon McDonald on 6/2/20.
//  Copyright © 2020 Dahmeyon McDonald. All rights reserved.
//

import UIKit
import FirebaseFirestore

class GlobalManager: NSObject {
    
    func globalBackgroundColor() -> UIColor {
        return UIColor.init(red: 22/255.0, green: 24/255.0, blue: 25/255.0, alpha: 1.0)
    }
    
    func globalHilightColor() -> UIColor {
        return UIColor.init(red: 37/255.0, green: 39/255.0, blue: 42/255.0, alpha: 1.0)
    }
    
    func globalBlueAccentColor() -> UIColor {
         return UIColor.init(red: 17/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1.0)
    }
    
    func openPrivacy() {
        Firestore.firestore().collection("global").document("privacy").getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                if let snapshot = snapshot {
                    if let value = snapshot.data() {
                        if let innerURL = value["url"] as? String {
                            if let url = URL(string: innerURL) {
                                UIApplication.shared.open(url)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func openTerms() {
        Firestore.firestore().collection("global").document("contact").getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                if let snapshot = snapshot {
                    if let value = snapshot.data() {
                        if let innerURL = value["url"] as? String {
                            if let url = URL(string: innerURL) {
                                UIApplication.shared.open(url)
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
