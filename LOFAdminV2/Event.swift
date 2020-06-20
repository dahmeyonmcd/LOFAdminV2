//
//  Event.swift
//  Lions of Forex
//
//  Created by UnoEast on 4/12/19.
//  Copyright © 2019 Dahmeyon McDonald. All rights reserved.
//

import Foundation


struct Event {
    let id: String
    let date: String
    let name: String
    let city: String
    let type: String
    let description: String
    let descriptionTwo: String
    let price: String
    
    init(data: [String:Any]) {
        
        self.id = data["id"] as! String
        self.date = data["date"] as! String
        self.name = data["name"] as! String
        self.city = data["city"] as! String
        self.type = data["type"] as! String
        self.description = data["description"] as! String
        self.descriptionTwo = data["descriptionTwo"] as! String
        self.price = data["price"] as! String
        
    }
    
    
}

struct Booking {
    let id: String
    let booking: Event
    var status: BookingStatus
    let time: String
    
    enum BookingStatus: String {
        case pending = "Pending"
        case accepted = "Accepted"
        case cancelled = "Cancelled"
    }
    
}
