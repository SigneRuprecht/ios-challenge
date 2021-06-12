//
//  Business.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/11/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import Foundation
import MapKit

class Business: NSObject, MKAnnotation {
    
    let id: String
    let title: String?
    let rating: Double
    let coordinate: CLLocationCoordinate2D
    
    init(id: String, name: String, rating: Double, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.id = id
        self.title = name
        self.rating = rating
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
