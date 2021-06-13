//
//  MapViewController.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/12/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import UIKit
import MapKit
import YelpAPI

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var userLatitude: CLLocationDegrees?
    var userLongitude: CLLocationDegrees?
    
    var business: Business?
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var numOfReviews: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStar: UIImageView!
    @IBOutlet weak var threeStar: UIImageView!
    @IBOutlet weak var fourStar: UIImageView!
    @IBOutlet weak var fiveStar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        if let currBusiness = self.business {
            getBusinessDetails(currBusiness: currBusiness)
        }
    }
    
    func calculateDistance(location1: CLLocation, location2: CLLocation) -> String {
        let distanceMeters = location1.distance(from: location2)
        
        if(distanceMeters < 650) {
            return String(format: "%.1f m", distanceMeters)
        } else {
            let distanceMiles = distanceMeters / 1609.0
            return String(format: "%.2f mi", distanceMiles)
        }
    }
    
    func getBusinessDetails(currBusiness: Business) {
        
        let apikey = "fIbyljOuO_kXY7RN5afW6Xk8I8rhu_DgpbmJSgmzH_xJ-feuDEauPpsQlR6xB5SoueCm2FRkZHvC5Dam6va0x2PGHJWXAKu740r9v3UIobkWSZrpvqbKx0NbXffDYHYx"
        let client = YLPClient(apiKey: apikey)
        
        client.business(withId: currBusiness.id, completionHandler: { (business, error)  in
              
            if let err = error {
                // Unable to get business details. Display what we know from original search and hide the rest
                print(err.localizedDescription)
                self.businessName.text = currBusiness.title
                self.numOfReviews.text = ""
                self.setRating(rating: currBusiness.rating)
                self.categories.text = ""  
            }
            
            if let result = business {
                
                DispatchQueue.main.async {
                    let address = result.location.address[0] + "\n" + result.location.city + ", " + result.location.stateCode + " " + result.location.postalCode
                    
                    var display = 2
                    var categories = ""
                    if(result.categories.count < 3) {
                        display = result.categories.count - 1
                    }
                    
                    for i in 0...display {
                        categories = categories + result.categories[i].name
                        if(i != display) {
                            categories = categories + " • "
                        }
                    }
                    
                    self.businessName.text = result.name
                    self.numOfReviews.text = "(" + String(result.reviewCount) + ")"
                    self.phoneNumber.text = result.phone
                    self.address.text = address
                    self.categories.text = categories
                    self.setRating(rating: result.rating)
                }
              
            }
        })
        
    }
    
    func setRating(rating: Double) {
        
        switch(rating) {
        case 0:
            break
        case 0.5:
            oneStar.image = UIImage(named: "starHalf24")
            break
        case 1:
            oneStar.image = UIImage(named: "starFull24")
            break
        case 1.5:
            oneStar.image = UIImage(named: "starFull24")
            twoStar.image = UIImage(named: "starHalf24")
            break
        case 2:
            oneStar.image = UIImage(named: "starFull24")
            twoStar.image = UIImage(named: "starFull24")
            break
        case 2.5:
            oneStar.image = UIImage(named: "starFull24")
            twoStar.image = UIImage(named: "starFull24")
            threeStar.image = UIImage(named: "starHalf24")
            break
        case 3:
            oneStar.image = UIImage(named: "starFull24")
            twoStar.image = UIImage(named: "starFull24")
            threeStar.image = UIImage(named: "starFull24")
            break
        case 3.5:
            oneStar.image = UIImage(named: "starFull24")
            twoStar.image = UIImage(named: "starFull24")
            threeStar.image = UIImage(named: "starFull24")
            fourStar.image = UIImage(named: "starHalf24")
            break
        case 4:
            oneStar.image = UIImage(named: "starFull24")
            twoStar.image = UIImage(named: "starFull24")
            threeStar.image = UIImage(named: "starFull24")
            fourStar.image = UIImage(named: "starFull24")
            break
        case 4.5:
            oneStar.image = UIImage(named: "starFull24")
            twoStar.image = UIImage(named: "starFull24")
            threeStar.image = UIImage(named: "starFull24")
            fourStar.image = UIImage(named: "starFull24")
            fiveStar.image = UIImage(named: "starHalf24")
            break
        case 5:
            oneStar.image = UIImage(named: "starFull24")
            twoStar.image = UIImage(named: "starFull24")
            threeStar.image = UIImage(named: "starFull24")
            fourStar.image = UIImage(named: "starFull24")
            fiveStar.image = UIImage(named: "starFull24")
            break
        default:
            break
        }
        
    }
    
    // MARK: MKMapViewDelegate
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        // this is where visible maprect should be set
        if let currBusiness = self.business, let currLatitude = self.userLatitude, let currLongitude = self.userLongitude {
          //
           
           let userPin: MKPointAnnotation = MKPointAnnotation()
           userPin.coordinate = CLLocationCoordinate2D(latitude: currLatitude, longitude: currLongitude)
           userPin.title = "You are here"
           mapView.addAnnotation(userPin)
           mapView.addAnnotation(currBusiness)
            
            let p1 = MKMapPoint(userPin.coordinate)
            let p2 = MKMapPoint(currBusiness.coordinate)
           
           self.distance.text = calculateDistance(location1: CLLocation(latitude: currLatitude, longitude: currLongitude), location2: CLLocation(latitude: currBusiness.coordinate.latitude, longitude: currBusiness.coordinate.longitude))
            
            let width = fabs(p1.x-p2.x) * 1.4
            let xChange = fabs(p1.x-p2.x) * 0.2
            let height = fabs(p1.y-p2.y) * 1.4
            let yChange = fabs(p1.y-p2.y) * 0.2

            let mapRect = MKMapRect(x: fmin(p1.x,p2.x) - xChange, y: fmin(p1.y,p2.y) - yChange, width: width, height: height);
            mapView.setVisibleMapRect(mapRect, animated: true)
        }
    }

}

