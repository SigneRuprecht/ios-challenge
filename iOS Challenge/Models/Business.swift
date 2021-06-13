//
//  Business.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/11/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import Foundation
import MapKit
import YelpAPI

class Business: NSObject, MKAnnotation {
    
    let id: String
    let title: String?
    let rating: Double
    let coordinate: CLLocationCoordinate2D
    
    var phoneNumber: String?
    var location: YLPLocation?
    var categories: [YLPCategory]?
    var numOfReviews: UInt?
    
    init(id: String, name: String, rating: Double, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.id = id
        self.title = name
        self.rating = rating
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func updateDetails(phone: String?, location: YLPLocation, categories: [YLPCategory], reviews: UInt) {
        self.phoneNumber = phone
        self.location = location
        self.categories = categories
        self.numOfReviews = reviews
    }
    
    func calculateDistance(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
        let userLocation = CLLocation(latitude: latitude, longitude: longitude)
        let buisnessLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let distanceMeters = userLocation.distance(from: buisnessLocation)
        
        if(distanceMeters < 650) {
            return String(format: "%.1f m", distanceMeters)
        } else {
            let distanceMiles = distanceMeters / 1609.0
            return String(format: "%.2f mi", distanceMiles)
        }
    }
    
    func getAddress() -> String {
        
        guard let loc = self.location else {
            return ""
        }
        
        var addressText: String = ""
        if loc.address.count > 0 {
            addressText.append(loc.address[0])
            addressText.append("\n")
        }
        
        addressText.append(loc.city + ", " + loc.stateCode + " " + loc.postalCode)
        
        return addressText
    }
    
    func getPhoneNumber() -> String {
        guard let number = self.phoneNumber else {
            return ""
        }
        
        return number
    }
    
    func getNumOfReviews() -> String {
        guard let reviews = self.numOfReviews else {
            return ""
        }
        
        return "(" + String(reviews) + ")"
    }
    
    func getCategories() -> String {
        var display = 2
        var categories = ""
        
        guard let categoryStrings = self.categories else {
            return ""
        }
        
        if(categoryStrings.count < 3) {
            display = categoryStrings.count - 1
        }
        
        for i in 0...display {
            categories = categories + categoryStrings[i].name
            if(i != display) {
                categories = categories + " • "
            }
        }
        
        return categories
    }
    
}
