//
//  ViewController.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/11/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import UIKit
import CoreLocation
import YelpAPI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var businessTableView: UITableView!
    
    var businesses: [Business] = [Business]()
    var selectedBusiness: Business?
    
    @IBOutlet weak var pageLabel: UILabel!
    var pageLocation: PageLocation = PageLocation()
    
    var locationManager = CLLocationManager()
    var currLongitude: CLLocationDegrees!
    var currLatitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.businessTableView.dataSource = self
        self.businessTableView.delegate = self
        self.registerTableViewCells()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            if let mapViewController = segue.destination as? MapViewController {
                mapViewController.business = self.selectedBusiness
                mapViewController.userLatitude = self.currLatitude
                mapViewController.userLongitude = self.currLongitude
            }
        }
    }
    
    // MARK: User location functions
    private func getLocation() {
        let status = CLLocationManager.authorizationStatus()

        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            presentLocationPermissionUIAlert()
            return
        }
        
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.requestLocation()
    }

    // MARK: Search Yelp functions
    @IBAction func searchYelp(_ sender: Any) {
        self.pageLocation.resetPage()
        self.pageLabel.text = self.pageLocation.pageDescription
        getLocation()
    }
    
    func searchBusinesses(searchTerm: String, longitude: CLLocationDegrees, latitude: CLLocationDegrees, offset: Int) {
        let apikey = "fIbyljOuO_kXY7RN5afW6Xk8I8rhu_DgpbmJSgmzH_xJ-feuDEauPpsQlR6xB5SoueCm2FRkZHvC5Dam6va0x2PGHJWXAKu740r9v3UIobkWSZrpvqbKx0NbXffDYHYx"
        let client = YLPClient(apiKey: apikey)
        
        self.businesses.removeAll()
          
        let location = YLPCoordinate(latitude: latitude, longitude: longitude)
    
        client.search(with: location, term: searchTerm, limit: 20, offset: UInt(offset), sort: .bestMatched, completionHandler: { (search, error)  in
              
            if let err = error {
                print(err.localizedDescription)
                self.pageLocation.setPageNotFound()
                DispatchQueue.main.async {
                    self.pageLabel.text = self.pageLocation.pageDescription
                    self.businessTableView.reloadData()
                }
            }
              
            if let result = search {
                self.pageLocation.setTotalPages(totalResults: result.total)
               
                for business in result.businesses {
                    
                    if let lat = business.location.coordinate?.latitude, let long = business.location.coordinate?.longitude {
                        let b = Business(id: business.identifier, name: business.name, rating: business.rating, latitude: lat, longitude: long)
                        self.businesses.append(b)
                    }
                }
                DispatchQueue.main.async {
                    self.pageLabel.text = self.pageLocation.pageDescription
                    self.businessTableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func showPreviousResults(_ sender: Any) {
        
        self.pageLocation.decrementPage()
        searchBusinesses(searchTerm: searchTextField.text!, longitude: currLongitude, latitude: currLatitude, offset: Int(20 * (self.pageLocation.currPage - 1)))
        
    }
    
    @IBAction func showNextResults(_ sender: Any) {
        
        self.pageLocation.incrementPage()
        searchBusinesses(searchTerm: searchTextField.text!, longitude: currLongitude, latitude: currLatitude, offset: Int(20 * (self.pageLocation.currPage - 1)))
    }
    
    func presentLocationPermissionUIAlert() {
        let alert = UIAlertController(title: "This feature requires Location Services", message: "Turn on Location Services to search businesses near you", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in

            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func presentLocationUIAlert() {
        let alert = UIAlertController(title: "Could not get user location", message: "Location Services are unavailable at this time", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in

            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    // MARK: UITableViewDelegate
    private func registerTableViewCells() {
        let businessCell = UINib(nibName: "BusinessTableViewCell",
                                  bundle: nil)
        self.businessTableView.register(businessCell,
                                forCellReuseIdentifier: "BusinessTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as? BusinessTableViewCell {
            cell.setCell(business: businesses[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBusiness = self.businesses[indexPath.row]
        self.performSegue(withIdentifier: "showMap", sender: nil)
    }
    
    // MARK: CLLocationManagerDelegate
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentLocationUIAlert()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currLongitude = location.coordinate.longitude
            currLatitude = location.coordinate.latitude
            searchBusinesses(searchTerm: searchTextField.text!, longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, offset: 0)
        }
    }
    
   
}

