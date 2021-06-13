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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var userLatitude: CLLocationDegrees?
    var userLongitude: CLLocationDegrees?
    
    var business: Business?
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var numOfReviewsLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    
    @IBOutlet weak var oneStarImage: UIImageView!
    @IBOutlet weak var twoStarImage: UIImageView!
    @IBOutlet weak var threeStarImage: UIImageView!
    @IBOutlet weak var fourStarImage: UIImageView!
    @IBOutlet weak var fiveStarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        if let currBusiness = self.business {
            getBusinessDetails(currBusiness: currBusiness)
        }
    }
    
    func getBusinessDetails(currBusiness: Business) {
        
        let apikey = "fIbyljOuO_kXY7RN5afW6Xk8I8rhu_DgpbmJSgmzH_xJ-feuDEauPpsQlR6xB5SoueCm2FRkZHvC5Dam6va0x2PGHJWXAKu740r9v3UIobkWSZrpvqbKx0NbXffDYHYx"
        let client = YLPClient(apiKey: apikey)
        
        client.business(withId: currBusiness.id, completionHandler: { (business, error)  in
              
            if let err = error {
                // Unable to get business details. Display what we know from original search and hide the rest
                print(err.localizedDescription)
                self.businessNameLabel.text = currBusiness.title
                self.numOfReviewsLabel.text = ""
                self.addressLabel.text = ""
                self.phoneNumberButton.setTitle("", for:  UIControl.State.normal)
                self.categoriesLabel.text = ""
                self.setRating(rating: currBusiness.rating)
            }
            
            if let result = business {
                
                DispatchQueue.main.async {
                    currBusiness.updateDetails(phone: result.phone, location: result.location, categories: result.categories, reviews: result.reviewCount)
                    self.businessNameLabel.text = currBusiness.title
                    self.numOfReviewsLabel.text = currBusiness.getNumOfReviews()
                    self.addressLabel.text = currBusiness.getAddress()
                    self.phoneNumberButton.setTitle(currBusiness.getPhoneNumber(), for:  UIControl.State.normal)
                    self.categoriesLabel.text = currBusiness.getCategories()
                    self.setRating(rating: result.rating)
                    self.business = currBusiness
                }
              
            }
        })
        
    }
    
    @IBAction func callPhoneNumber(_ sender: Any) {
        
        guard let number = self.phoneNumberButton.currentTitle else {
            return
        }
  
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func setRating(rating: Double) {
        
        switch(rating) {
        case 0:
            break
        case 0.5:
            oneStarImage.image = UIImage(named: "starHalf24")
            break
        case 1:
            oneStarImage.image = UIImage(named: "starFull24")
            break
        case 1.5:
            oneStarImage.image = UIImage(named: "starFull24")
            twoStarImage.image = UIImage(named: "starHalf24")
            break
        case 2:
            oneStarImage.image = UIImage(named: "starFull24")
            twoStarImage.image = UIImage(named: "starFull24")
            break
        case 2.5:
            oneStarImage.image = UIImage(named: "starFull24")
            twoStarImage.image = UIImage(named: "starFull24")
            threeStarImage.image = UIImage(named: "starHalf24")
            break
        case 3:
            oneStarImage.image = UIImage(named: "starFull24")
            twoStarImage.image = UIImage(named: "starFull24")
            threeStarImage.image = UIImage(named: "starFull24")
            break
        case 3.5:
            oneStarImage.image = UIImage(named: "starFull24")
            twoStarImage.image = UIImage(named: "starFull24")
            threeStarImage.image = UIImage(named: "starFull24")
            fourStarImage.image = UIImage(named: "starHalf24")
            break
        case 4:
            oneStarImage.image = UIImage(named: "starFull24")
            twoStarImage.image = UIImage(named: "starFull24")
            threeStarImage.image = UIImage(named: "starFull24")
            fourStarImage.image = UIImage(named: "starFull24")
            break
        case 4.5:
            oneStarImage.image = UIImage(named: "starFull24")
            twoStarImage.image = UIImage(named: "starFull24")
            threeStarImage.image = UIImage(named: "starFull24")
            fourStarImage.image = UIImage(named: "starFull24")
            fiveStarImage.image = UIImage(named: "starHalf24")
            break
        case 5:
            oneStarImage.image = UIImage(named: "starFull24")
            twoStarImage.image = UIImage(named: "starFull24")
            threeStarImage.image = UIImage(named: "starFull24")
            fourStarImage.image = UIImage(named: "starFull24")
            fiveStarImage.image = UIImage(named: "starFull24")
            break
        default:
            break
        }
        
    }
}
// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
      
        if let currBusiness = self.business, let currLatitude = self.userLatitude, let currLongitude = self.userLongitude {
     
           let userPin: MKPointAnnotation = MKPointAnnotation()
           userPin.coordinate = CLLocationCoordinate2D(latitude: currLatitude, longitude: currLongitude)
           userPin.title = "You are here"
           mapView.addAnnotation(userPin)
           mapView.addAnnotation(currBusiness)
            
           let p1 = MKMapPoint(userPin.coordinate)
           let p2 = MKMapPoint(currBusiness.coordinate)
           
           self.distanceLabel.text = self.business?.calculateDistance(latitude: currLatitude, longitude: currLongitude)
            
           let width = fabs(p1.x-p2.x) * 1.4
           let xChange = fabs(p1.x-p2.x) * 0.2
           let height = fabs(p1.y-p2.y) * 1.4
           let yChange = fabs(p1.y-p2.y) * 0.2

            let mapRect = MKMapRect(x: fmin(p1.x,p2.x) - xChange, y: fmin(p1.y,p2.y) - yChange, width: width, height: height);
            mapView.setVisibleMapRect(mapRect, animated: true)
        }
    }
    
}

