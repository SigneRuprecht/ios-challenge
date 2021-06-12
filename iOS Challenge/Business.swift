//
//  Business.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/11/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import Foundation

class Business {
    
    var id: String
    var name: String
    var rating: Double
    
    var phone: String?
    var price: String?
    var address: String?
    var aliases: [String]?
    
    init(id: String, name: String, rating: Double) {
        self.id = id
        self.name = name
        self.rating = rating
    }
    
}
