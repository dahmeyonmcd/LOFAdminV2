//
//  LOFMember.swift
//  LOFAdminV2
//
//  Created by Dahmeyon McDonald on 6/19/20.
//  Copyright © 2020 LionsOfForex. All rights reserved.
//

import UIKit

struct LOFMember: Codable {
    
    var id: String
    var name: String
    var package: LOFPackage
    var added: String
    var email: String
    var mobile: String
    var photo: String
    var country: String
    var experience: String
    var active: Bool
    var firebase: Bool
    var mobile_register: Bool
    
    enum LOFPackage: String, Codable {
        case Signals = "13"
        case Essentials = "14"
        case Advanced = "15"
        case Elite = "31"
        case Unknown
    }
    
    init(id: String, name: String, package: LOFPackage, added: String, email: String, mobile: String, photo: String, country: String, experience: String, active: Bool, firebase: Bool, mobile_register: Bool) {
        self.id = id
        self.name = name
        self.package = package
        self.added = added
        self.email = email
        self.mobile = mobile
        self.photo = photo
        self.country = country
        self.experience = experience
        self.active = active
        self.firebase = firebase
        self.mobile_register = mobile_register
    }
}
